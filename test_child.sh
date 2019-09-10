#!/bin/bash

# Load a bunch of variables
. settings.sh

usage () {
  echo "This script is supposed to be called from test_start.sh."
  echo "Usage:"
  echo "$0 <read|write> script_for_running_the_transfers"
  exit
}

timer_start () {
  START=`python -c "import time; print time.time()"`
  echo $START
}

timer_stop () {
  START=$1
  STOP=`python -c "import time; print time.time()"`
  python -c "print 'time:'+str($STOP)+';'+str($TESTFILE_SIZE_KB/1024.0)+' MB; '+str($STOP-$START)+' sec; Throughput: '+str($TESTFILE_SIZE_KB/(($STOP-$START)*1024.0))+' MB/s.'"
}

get_random_file_number () {
  if [ "$#" -ne 1 ]; then
      echo "Illegal number of parameters"
      exit 1
  fi
  if [ -z "$1" ] ; then 
    echo "Function get_random_file_number needs a max number."
    exit 1
  fi
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Sorry integers only."
    exit 1
  fi

  NUMBER=`$(( ( RANDOM % $1 )  + 1 ))`
  echo $NUMBER
}

test () {

  if [ "$#" -ne 2 ]; then
      echo "Illegal number of parameters"
      exit 1
  fi
  if [ -z "$1" ] ; then 
    echo "Function test needs a transfer script."
    exit 1
  fi
  if [ -z "$2" ] ; then 
    echo "Function test needs to know if you are reading or writing."
    exit 1
  fi

  transfer_cmd=$1
  if [ ! -x ${transfer_cmd} ]; then
    echo "${transfer_cmd} not found."
    exit 1
  fi

  type=$2
  if [ "x$type" != "xread" ] && [ "x$type" != "xwrite" ] ; then
      echo "Illegal transfer type. Should be read or write."
      exit 1
  fi


  while true; do
    if [ "x$type" == "xread" ]; then
        NUMBER=`get_random_file_number $FILES`
    else
        NUMBER=$(uuidgen)
    fi

    START=`timer_start`
    ret=`eval ${transfer_cmd} ${type} ${NUMBER}`
    timer_stop $START
    if [ "x${ret}" != "x0" ]; then
        break
    fi
  done
}

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

type=$1
transfer_cmd=$2

test ${transfer_cmd} ${type}
