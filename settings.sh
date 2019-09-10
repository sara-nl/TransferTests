#!/bin/bash

# What is the transfer mechanism that you want to use
TRANSFER_CMD=./curl.sh

# If you change the values below, you may need to do a test_prepare.sh!

#Testfile size in KB
TESTFILE_SIZE_KB=1

# Number of files (not nessecerily same as number of transfers)
FILES=10

# The number of concurrent writes during the tests
# Can be 0 or greater
WRITES=1

# The number of concurrent writes during the tests
# Can be 0 or greater
READS=1

#The stuff below you can leave as is.
#----------------------------------------------------

WRITEDIR=`pwd`/input_files

error=0

if [ -z ${FILES} ]; then
    echo "Please specify FILES in settings.sh"
    error=1
fi

if [ -z ${TESTFILE_SIZE_KB} ]; then
    echo "Please specify TESTFILE_SIZE_KB in settings.sh"
    error=1
fi

if [ -z ${READS} ]; then
    echo "Please specify READS in settings.sh"
    error=1
fi

if [ -z ${WRITES} ]; then
    echo "Please specify WRITES in settings.sh"
    error=1
fi

if [ $error -ne 0 ]; then
    exit 1
fi
