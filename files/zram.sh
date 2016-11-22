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

    if type -path systemd-run > /dev/null ; then
        systemd-run /bin/bash -c "sleep 1 ; /sbin/mkswap $DEVNAME && /sbin/swapon -p 32767 $DEVNAME" || exit 7
    else
        ( sleep 1 ; /sbin/mkswap "$DEVNAME" && /sbin/swapon -p 32767 "$DEVNAME" ) &
    fi
fi
