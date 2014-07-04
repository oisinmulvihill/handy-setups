#!/bin/bash
#
# Bash Shell Function Library
# Written by Louwrentius.
#

BSFL_VERSION=1.02

DEBUG=0

# Logging.
LOGDATEFORMAT="%b %e %H:%M:%S"
LOGFILE=log.txt

# Use colours in output.
RED="tput setaf 1"
GREEN="tput setaf 2"
YELLOW="tput setaf 3"
BLUE="tput setaf 4"
BOLD="tput bold"
DEFAULT="tput sgr0"

# Declare some vars
START_WATCH=0

function log () {


    NAME="$1"   # Name of the application or function. 
    TYPE="$2"   # FATAL ERROR WARNING NOTICE INFO DEBUG.
    MSG="$3"    # The actual log message. 

    DATE=`date +"$LOGDATEFORMAT"`

    LOGMESSAGE="$DATE - $NAME [$TYPE]: $MSG"
    #echo "$LOGMESSAGE" >> $LOGFILE

    if [ "$TYPE" == "ERROR" ] || [ "$TYPE" == "WARN" ] || [ "$DEBUG" == 1 ]
    then
        echo -e "$LOGMESSAGE"
    fi


}

function display_status () {


    function position_cursor () {

        let RES_COL=`tput cols`-12
        tput cuf $RES_COL
        tput cuu1
    }

    STATUS="$1"

    case $STATUS in 

    OK | ok ) 
            STATUS="   OK    "  
            STATUS_COLOUR="$GREEN"
            ;;
    PASSED | passed ) 
            STATUS=" PASSED  "  
            STATUS_COLOUR="$GREEN"
            ;;
    SUCCESS | SUCCESS ) 
            STATUS=" SUCCESS "  
            STATUS_COLOUR="$GREEN"
            ;;
    
    FAILURE | failure | FAILED | failed | ERROR | error)
            STATUS=" FAILURE "  
            STATUS_COLOUR="$RED"
            ;;
    INFO | info | NOTICE | notice)
            STATUS=" NOTICE  "  
            STATUS_COLOUR="$BLUE"
            ;;
    WARNING | warning | WARN )
            STATUS=" WARNING "  
            STATUS_COLOUR="$YELLOW"
            ;;
    esac

    position_cursor
    echo -n "["
    $DEFAULT
    $BOLD
    $STATUS_COLOUR
    echo -n "$STATUS"
    $DEFAULT
    echo "]"
 
}

function check_status () {

    ERROR="$1"
    if [ "$ERROR" == "0" ]
    then
        display_status OK
        return 0
    else
        display_status ERROR
        return 1
    fi
}

function exec_cmd () {

    CMD="$1"

    RESULT=$($CMD 2>&1 )
    check_status $?
    ERROR=$?

    if [ "$ERROR" == "0" ]
    then
        if [ "$DEBUG" == "1" ]
        then
            MESSAGE="$RESULT"
        else
            MESSAGE="Command executed successfuly."
        fi
         
        TYPE=NOTICE
        log "$CMD" $TYPE "$MESSAGE"
    else
        TYPE=ERROR
        log "$CMD" $TYPE "$RESULT"
    fi


    if [ "$DEBUG" == "1" ] 
    then
        echo "$RESULT"
    fi
}

function start_watch () {

    START_WATCH="$(date +%s)"
}

function stop_watch () {

    STOP="$(date +%s)"
    START="$START_WATCH"

    ELAPSED="$(expr $STOP - $START)"

    REMAINDER="$(expr $ELAPSED % 3600)"
    HOURS="$(expr $(expr $ELAPSED - $REMAINDER) / 3600)"

    SECS="$(expr $REMAINDER % 60)"
    MINS="$(expr $(expr $REMAINDER - $SECS) / 60)"

    echo "Elapsed time (h:m:s): $HOURS:$MINS:$SECS"
}

function exists () {

    ITEM="$1"

    if [ -e "$ITEM" ]
    then
        if [ -d "$ITEM" ]
        then
            log exists INFO "Directory $ITEM exists."
            return 0
        elif [ -f "$ITEM" ]
        then
            log exists INFO "File $ITEM exists."
            return 0
        else
            log exists INFO "Filesystem object exists."
            return 0
        fi
    else
        log exists ERROR "The file or directory $ITEM does not exist!"
        return 1
    fi
}

function isset () {

    VAR=$1
    VALUE=$(eval "echo \$$VAR")
    if [ -z "$VALUE" ]
    then
        log isset INFO "Var $VAR is not set."
        return 1
    else
        log isset INFO "Var $VAR is set to $VALUE."
        return 0
    fi
}


function die () {
	log "$0" ERROR "$1"
	exit 1
}


