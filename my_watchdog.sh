#!/bin/sh
#sleep 100
DATE=`date +%Y-%m-%d-%H:%M:%S`
tries=0
gwip=$(ip route | grep "default" | awk '{print $3}')
echo --- my_watchdog start ---
while [[ $tries -lt 5 ]]
do
        if /bin/ping -c 1 114.114.114.114 >/dev/null; then
            echo --- exit ---
#           echo $DATE OK >>my_watchdog.log
            exit 0
        fi

        if /bin/ping -c 1 $gwip >/dev/null; then
            tries=$((tries+1))
            sleep 10
#           echo $DATE tries: $tries >>my_watchdog.log
            echo $DATE fix net >>my_watchdog.log
            /opt/fix_net.sh
        fi
done
