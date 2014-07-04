#!/bin/bash
#
# Boostrap keys for salt master and minions on vagrant hosts
#
set -x
SCRIPTLIB="/vagrant/scriptlib"

# If this file is present
SKIP_THE_BOOTSTRAP="/root/.skip-saltstack-vagrant-bootstrap.txt"

source $SCRIPTLIB/functions.sh

machine_name="$1"

if [ -a "$SKIP_THE_BOOTSTRAP" ] ; then
    echo "Boostrap disabled. Delete '$SKIP_THE_BOOTSTRAP' to re-run."
    exit 0
fi

sudo rm -rf /etc/salt || die "Failed to clear keys"
sudo cp -r /srv/etc-salt /etc/salt || die "Failed to copy keys"

sudo start salt-master || sudo restart salt-master || die "Failed to start master"
sudo start salt-minion || sudo restart salt-master || die "Failed to start minion"

$SCRIPTLIB/saltstack_accept_key.sh $accept_key $machine_name;

echo "Bootstrap ran OK! Disabling as its no longer needed."
touch $SKIP_THE_BOOTSTRAP
