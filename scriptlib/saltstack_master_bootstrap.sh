#!/bin/bash
#
# Install saltstack on the new ubuntu instance.
#
# Oisin Mulvihill
# 2014-07-04
#
SCRIPTLIB="/vagrant/scriptlib/"

# If this file is present
SKIP_THE_BOOTSTRAP="/root/.skip-saltstack-bootstrap.txt"

source $SCRIPTLIB/functions.sh

function bootstrap() {
    # Bootstrap a salt-master and salt-minion
    accept_key="$1" # This is the initial key to accept, if any

    if [ -a "$SKIP_THE_BOOTSTRAP" ] ; then
        echo "Boostrap disabled. Delete '$SKIP_THE_BOOTSTRAP' to re-run."
        return 0
    fi

    #sudo apt-get -y --force-yes update || die "Failed to update package index"

    sudo apt-get -y install curl salt-master salt-minion || die "Failed to install system dependencies"

    $SCRIPTLIB/saltstack_accept_key.sh $accept_key;

    echo "Bootstrap ran OK! Disabling as its no longer needed."
    touch $SKIP_THE_BOOTSTRAP

    return 0
}

# Kick of the bootstrap process:
#
bootstrap $@
exit $?
