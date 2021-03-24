#! /bin/bash

#constant variables
readonly MEMORY_LIM_IN_MEGABYTES=824

while :
do
    TELEGRAM_PID=$(pidof telegram-desktop)
    #wait until telegram will be opened
    while [ -z "$TELEGRAM_PID" ]
    do
        sleep 1m
        TELEGRAM_PID=$(pidof telegram-desktop) 
    done
    TELEGRAM_WINDOW_ID=$(xdotool search --sync --onlyvisible --pid ${TELEGRAM_PID})
    ACTIVE_WINDOW_ID=$(xdotool getactivewindow)
    let MEMORY_USED_BY_TELEGRAM_IN_MEGABYTES=$(ps -q ${TELEGRAM_PID} -o rss=)/1024
    if [ "$TELEGRAM_WINDOW_ID" -ne "$ACTIVE_WINDOW_ID" ] && [ "$MEMORY_USED_BY_TELEGRAM_IN_MEGABYTES" -ge "${MEMORY_LIM_IN_MEGABYTES}" ]
    then
        #restart telegram-desktop
        kill $(pidof telegram-desktop)
        nohup telegram-desktop &>/dev/null &
        #refresh pid and window id
        TELEGRAM_PID=$(pidof telegram-desktop)
        TELEGRAM_WINDOW_ID=$(xdotool search --sync --onlyvisible --pid ${TELEGRAM_PID})
        #minimize window 
        xdotool windowminimize $TELEGRAM_WINDOW_ID
    fi
    sleep 1m
done
