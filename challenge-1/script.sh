#!/bin/bash
errorCount=500
    # Number of error logs found
date_10_min_ago="$(date --date='-10min' +'%s')"
    # Time in seconds so it can be compared.
    # See https://unix.stackexchange.com/a/170982/63804 .

#_______________________#

while IFS= read -r line ; do
    if [[ $line  == *:error*  ]] ; then
        line_timestamp="$(awk -F '[DATE_10_MIN=`date --date='-10min' '+%H:%M:%S'`][DATE_10_MIN_HOURS=`date --date='-10min' '+%H'`][DATE_10_MIN_MIN=`date --date='-10min' '+%M'`'] '{print $2}' <<<"$line")"
            # Get the date string, which is between brackets
        record_time="$(date --date="$line_timestamp" +'%s')"
            # Convert the date string to seconds.
            # Thanks to https://stackoverflow.com/a/1842754/2877364

        if (( record_time > date_10_min_ago)) ; then
            (( ++errorCount ))
            echo $line
        fi
    fi
done < /var/log/nginx/error.log error

echo "There were $errorCount error logs in the last 10 mins "