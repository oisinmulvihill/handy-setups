#!/bin/bash
#
# This installs common helper functions which the box will source. This
# provides configuration from the ini file
#
# Oisin Mulvihill
# 2013-10-03
#
export CONFIG_FILE=${CONFIG_FILE:=$HOME/devops.ini}
export SCRIPTLIBDIR=${SCRIPTLIBDIR:=`pwd`}


# echo "\$SCRIPTLIBDIR: '$SCRIPTLIBDIR'"
if [ "$SCRIPTLIBDIR" == "" ] ; then
    echo "Error: 'SCRIPTLIBDIR' is not defined in environment."
    return 1
fi

# 'import' bash 'libs' we're using:
#
source $SCRIPTLIBDIR/read_ini.sh


function install_box () {
    BOX_IMG=$1
    BOX_URL=$2

    VIMG=`vagrant box list | grep $BOX_IMG`
    if [ "$?" != 0 ] ; then
        echo "$BOX_IMG box not installed. Installing..."
        vagrant box add $BOX_IMG $BOX_URL
    else
        echo "$BOX_IMG installed, skipping install."
    fi

    return 0
}

function recover_box() {
    # install the base box we use. This will download once if it is not present
    # otherwise no action will be taken.
    if [ "$VAGRANT_BOX" != "" ] ; then
        install_box $VAGRANT_BOX $VAGRANT_BOX_URL

        if [ $? -ne "0" ] ; then
            echo "install_box() failed!"
            return 1
        fi
    fi
}

function upload_box() {
    # Upload load a machine image to the dev boxes site.
    #
    image_to_upload=$1
    if [ "$image_to_upload" == "" ] ; then
        echo "Please specify the box to upload!"
        return 1
    fi

    loc="/var/lib/jenkins/jenkins/www_distrib_site_root/vargant/dev-boxes/"
    uri="jenkins@distrib.dev.pythonpro.eu:$loc"

    echo "Uploading '$image_to_upload' to '$uri'"
    scp $image_to_upload $uri
    if [ $? -ne "0" ] ; then
        echo "Failed to upload the new box!"
        return 1
    fi

    return 0
}


function install_vagrant_plugin() {
    # Get the plugins we need to run the show:
    VCPLUGING=`vagrant plugin list | grep "$1"`
    if [ "$?" != 0 ] ; then
        echo "'$1' plugin not installed. Installing..."
        vagrant plugin install $1
    else
        echo "plugin installed $1, skipping install."
    fi
}


function configure_saltstack_env() {

    # The given parameter is the section from the INI file we are to use.
    config_section=$1

    if ! [ -f "$CONFIG_FILE" ] ; then
        echo "No '$CONFIG_FILE' found! please create one."
        return 1
    fi

    echo "Reading config vars from [$config_section] inside '$CONFIG_FILE'"
    read_ini $CONFIG_FILE

    # substring comparission contains part of a string:
    #if [[ "$INI__ALL_SECTIONS" == *"$config_section"* ]] ; then
    # exact match in substring:
    if ! [[ "${INI__ALL_SECTIONS}" == *"$config_section"* ]] ; then
        echo "The config section [$config_section] was not found in '$CONFIG_FILE'!"
        return 1
    fi

    # Set up the VAGRANT_XXX variable that the "Vagrantfile" uses:
    #
    # vagrant set up
    export VAGRANT_BOX="$(eval echo \$INI__${config_section}__box_img)"
    export VAGRANT_BOX_URL="$(eval echo \$INI__${config_section}__box_url)"
    export VAGRANT_HOSTNAME="$(eval echo \$INI__${config_section}__hostname)"
    export VAGRANT_ADDRESS="$(eval echo \$INI__${config_section}__address)"

    echo "VAGRANT_BOX=$VAGRANT_BOX"
    echo "VAGRANT_BOX_URL=$VAGRANT_BOX_URL"
    echo "VAGRANT_HOSTNAME=$VAGRANT_HOSTNAME"
    echo "VAGRANT_ADDRESS=$VAGRANT_ADDRESS"

    install_vagrant_plugin "vagrant-cachier"
    install_vagrant_plugin "vagrant-hostmanager"

}


