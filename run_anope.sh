#!/bin/bash
while true
do
if pgrep -f services 1> /dev/null;then
	sleep 1
else
        echo SERVER CRASHED
        /home/unreal/unrealircd/services/bin/services -nofork -debug
fi
done
