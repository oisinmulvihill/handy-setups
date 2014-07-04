#!/bin/bash
#
# This is run once to boostrap a newly started Amazon EC2 instance. It updates
# the machine and then installs puppet 3 ready for the main provision step to
# begin. It could also set hostname and other types of things based on quering
# the amazon environment.
#
# Oisin Mulvihill
# 2013-10-21
#

# If this file is present
SKIP_THE_BOOTSTRAP="/tmp/skipbootstrap.txt"


export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales


function bootstrap() {

    if [ -a "$SKIP_THE_BOOTSTRAP" ] ; then
        echo "Boostrap disabled. Delete '$SKIP_THE_BOOTSTRAP' to re-run."
        return 0
    fi

    echo "Updating and upgrading system packages:"
    sudo apt-get -fy update && sudo apt-get -fy upgrade

    # Test for the packages presence and install if its not already. If its not
    # puppet 3 attempt to reinstall as the machine may have come with 2.7.
    PVER=`sudo dpkg -l puppet | grep 3.*ubuntu > /dev/null`
    if [ "$?" -eq 1 ] ; then
        echo "Install puppet APT repository to get puppet v3+"
        rm -f puppetlabs-release-precise*.deb
        wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
        sudo dpkg -i puppetlabs-release-precise.deb
        sudo apt-get -fy update

        echo "Removing any prior puppet version present."
        echo $PVER
        sudo apt-get -fy remove puppet

        echo "Installing puppet prior to a provision run."
        sudo apt-get -fy install puppet

        if [ $? -ne "0" ] ; then
            echo "Puppet failed to install!"
            return 1
        fi

        echo "Testing to make sure puppet 3 is installed."
        sudo dpkg -l puppet | grep 3.* > /dev/null
        if [ "$?" -eq 1 ] ; then
            echo "Failed to install puppet 3!"
            return 1
        fi

    fi

    echo "Bootstrap ran OK! Disabling as its no longer needed. "
    touch $SKIP_THE_BOOTSTRAP

    return 0
}


# Kick of the bootstrap process:
#
bootstrap
exit $?
