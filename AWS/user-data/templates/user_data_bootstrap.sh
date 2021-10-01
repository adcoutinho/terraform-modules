#!/bin/bash -e
#
# This script will bootstrap and run the instance

start_time=`date +%s%N`

set -o pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Only called by root
if [ $UID != 0 ]; then
  echo "this script needs to be run as root. exiting..."
  exit 1
fi

# redirect stdout to /var/log/init
exec >> /var/log/init

# redirect stderr to /var/log/init.err
exec 2>> /var/log/init.err

hostname=${instance_domain_name}

##
## Commmon Functions
##

update() {
    echo "updating repository metadata"
    case $OS_PACKAGE_MANAGER in
      apt)
        apt-get update 1>&2
        ;;
      yum)
        yum check-update 1>&2 || true
        ;;
    esac
}

install() {
    case $OS_PACKAGEMANAGER in
      apt)
        if ! (dpkg -l | awk '{print $2}' | grep -q ^$1$ ); then
            echo installing $1...
            export DEBIAN_FRONTEND=noninteractive
            apt-get install -y $1 1>&2
        fi
        ;;
      yum)
        rpm -q $1 2>&1 > /dev/null || yum install -y $1
        ;;
    esac
}

