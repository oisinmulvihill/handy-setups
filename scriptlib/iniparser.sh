#!/bin/bash
#
# Example usage:
#
#    CONFIG_FILE=$HOME/dev-devops.ini
#    config_section=devbox
#
#    dev-devops.ini:
#    [devbox]
#    hostname="www.example.com"
#
#    # Run the parser
#    #
#    echo "Reading config vars from [$config_section] inside '$CONFIG_FILE'"
#    cfg_parser $CONFIG_FILE
#
#    # Check the parse section function is present and ran OK:
#    #
#    eval "cfg.section.$config_section" > /dev/null 2>&1
#    if [ "$?" -ne 0 ] ; then
#        echo "The config section [$config_section] was not found in '$CONFIG_FILE'!"
#        return 1
#    fi
#
#    # Now I can get at the hostname variable after the function was called.
#    # You may want to put quotes around values as.
#    #
#    echo "HOSTNAME: '$hostname'"
#

function cfg_parser()
{
    # Ini file parser from:
    #  * http://ajdiaz.wordpress.com/2008/02/09/bash-ini-parser
    #
    ini="$(<$1)"                # read the file
    ini="${ini//[/\[}"          # escape [
    ini="${ini//]/\]}"          # escape ]
    IFS=$'\n' && ini=( ${ini} ) # convert to line-array
    ini=( ${ini[*]//;*/} )      # remove comments with ;
    ini=( ${ini[*]/\    =/=} )  # remove tabs before =
    ini=( ${ini[*]/=\   /=} )   # remove tabs be =
    ini=( ${ini[*]/\ =\ /=} )   # remove anything with a space around =
    ini=( ${ini[*]/#\\[/\}$'\n'cfg.section.} ) # set section prefix
    ini=( ${ini[*]/%\\]/ \(} )    # convert text2function (1)
    ini=( ${ini[*]/=/=\( } )    # convert item to array
    ini=( ${ini[*]/%/ \)} )     # close array parenthesis
    ini=( ${ini[*]/%\\ \)/ \\} ) # the multiline trick
    ini=( ${ini[*]/%\( \)/\(\) \{} ) # convert text2function (2)
    ini=( ${ini[*]/%\} \)/\}} ) # remove extra parenthesis
    ini[0]="" # remove first element
    ini[${#ini[*]} + 1]='}'    # add the last brace
    eval "$(echo "${ini[*]}")" # eval the result
}
