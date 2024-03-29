#!/bin/bash

disksize="$1"

if [ -z "$DEVNAME" ] ; then
    echo '$DEVNAME not defined.  Exiting.' >&2
    exit 2
fi

if [ ! -b "$DEVNAME" ] ; then
    echo "$DEVNAME is not a block device.  Exiting." >&2
    exit 3
fi

if [ "$ACTION" = add ] ; then
    if [ "$disksize" -gt 0 ] ; then
        echo "$disksize" > /sys"$DEVPATH"/disksize || exit 4
        if [ "$( cat /sys"$DEVPATH"/disksize )" -lt "$disksize" ] ; then
            echo "Setting size failed.  Exiting." >&2
            exit 5
        fi
    else
        echo "Need to pass disk size > 0 as first argument." >&2
        exit 6
    fi

    delay=1

    if type -p systemd-run > /dev/null ; then
        systemd_run_version=$( systemd-run --version )
        systemd_run_version="${systemd_run_version#systemd }"
        systemd_run_version="${systemd_run_version%%[$'\n' ]*}"
        if [ "$systemd_run_version" -gt 219 ] ; then
            systemd-run --no-block /bin/bash -c "sleep $delay ; /sbin/mkswap $DEVNAME && /sbin/swapon -p 32767 $DEVNAME" || exit 7
        else
            systemd-run /bin/bash -c "sleep $delay ; /sbin/mkswap $DEVNAME && /sbin/swapon -p 32767 $DEVNAME" || exit 7
        fi
    else
        ( sleep $delay ; /sbin/mkswap "$DEVNAME" && /sbin/swapon -p 32767 "$DEVNAME" ) &
    fi
fi
