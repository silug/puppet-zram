#!/bin/bash
#
# Puppet Task Name: reload
#
# This task disables all zram swap, unloads the zram kernel module, and
# reloads the module (which will enable the swap).  Use this after
# making changes to zram configuration.

set -e

die() {
    echo "$@" >&2
    exit 1
}

verbose() {
    if [ "$PT_verbose" = 'true' ] ; then
        echo "$@" >&2
    fi
}

execute() {
    message="$1"
    shift

    verbose "$message"

    if [ "$PT__noop" = 'true' ] ; then
        echo "NOOP: $@" >&2
    else
        "$@"
    fi
}

export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin

if [ -t 2 ] ; then
    PT_verbose='true'
fi

if ! grep -q '^zram\>' /proc/modules ; then
    die 'zram kernel module is not loaded.  Reload skipped.'
fi

for device in $( awk '($1 ~ /^\/dev\/zram[0-9]*$/) { print $1 }' /proc/swaps ) ; do
    execute "Disabling swap device $device..." swapoff "$device"
done

if [ "$PT__noop" != 'true' \
    -a "$( lsmod | awk '($1 == "zram") { print $3 }' )" -gt 0 ] ; then
    die 'zram kernel module still in use.  Reload failed!'
fi

execute 'Removing zram module...' rmmod zram

execute 'Loading zram module...' modprobe zram
