#!/bin/bash -ex

HELP_FILE={{ dt_help_txt_file }}
echo > $HELP_FILE

export PYTHON_EGG_CACHE=$HOME/.python-eggs


# eggproxy running locally can be used with easy_install $BASKET somepkg. This
# relies on the cache folder mounted form the host. Packages will be downloaded
# the first time they are needed. The next time the local cache version will be
# returned.
#
#export BASKET='-i http://localhost:8888'

echo -e "\n-- Developer Commands ----------------------------------------------\n" >> $HELP_FILE


# Wrap python setup.py . By default it will run a python setup.py develop. If
# there is a BASKET environment variable set it will use this as the sole
# source for egg dependancies.
#
# The function will first test for the presence of the setup.py file. If its
# not present it will exit.
#
function sd() {
    if [ "$1" == "" ]; then
        COMMAND="develop"
    else
        COMMAND=$1
    fi

    if [ -e setup.py ]; then
        if [ -z "$BASKET" ]; then
            # No basket defined so don't use it as a source
            python setup.py $COMMAND
        else
            # The BASKET if set will need to specify -i/-f.
            # For example: BASKET="-i http...."
            # For example: BASKET="-f http...."
            #
            if [ $COMMAND == "develop" ]; then
                # only use basket for develop. It does not work
                # with other options.
                python setup.py develop $BASKET
            else
                python setup.py $COMMAND
            fi
        fi
    else
        echo -e "No setup.py found here: '"`pwd`"'"
    fi
}

echo -e "sd:\n\tshort for 'python setup.py <action>'. The default action is develop and it looks for 'setup.py' in the current dir." >> $HELP_FILE

function superctl() {
    sudo supervisorctl -c /etc/supervisor/supervisord.conf $@
}

echo -e "superctl:\n\tA quick wrapper of supervisorctl with sudo for quicker calls." >> $HELP_FILE



function service_logs() {
    sudo tail -f /var/log/supervisor/*.log
}

echo -e "service_logs:\n\ttail -f all the logs in /var/log/supervisor." >> $HELP_FILE


function net_logs() {
    sudo tail -f /var/log/nginx/*.log
}

echo -e "net_logs:\n\ttail -f all the logs in /var/log/nginx." >> $HELP_FILE


function netreset() {
    sudo /etc/init.d/networking restart
}

echo -e "netreset:\n\tRestart ubuntu's networking. Handy if host machine's networking changes e.g. home to office wifi." >> $HELP_FILE


function python_setup() {
    echo "Running through python source set up."
    for pkg in pkglib project-templates pp-pkglib pp-utils pp-db pp-auth pp-apiaccesstoken pp-testing pp-web-base pp-user; do
        echo -e "\n\n-- Changing into: $pkg --\n\n"
        cd ~/src/$pkg
        python setup.py develop $BASKET
    done
}

echo -e "python_setup:\n\tSetup python source checkouts in the current env"  >> $HELP_FILE




# Set up the help message and print out the available commands.
#
echo -e "dthelp:\n\tPrint out the help message." >> $HELP_FILE


function dthelp () {
    cat $HELP_FILE
}

dthelp

