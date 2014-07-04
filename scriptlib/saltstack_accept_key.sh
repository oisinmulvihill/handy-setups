#!/bin/bash
# Accept minion keys
SCRIPTLIB="/vagrant/scriptlib/"

source $SCRIPTLIB/functions.sh

accept_key="$1"

if [ ! -z "$accept_key" ]; then
    while true; do
        if [ ! -z "$(sudo salt-key -L | grep $accept_key)" ]; then
            sudo salt-key -y --accept "$accept_key" || die "Failed to accept keys $accept_key"
            break
        fi
        echo "Waiting for salt to wake up.."
        sleep 2
    done
fi
