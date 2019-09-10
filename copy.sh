#!/bin/bash

. settings.sh

# Provide information like URLs, storage locations, credentials etc. to access the remote storage that is to be tested.

# Specify the remote server to copy to and from
REMOTE_SERVER=

# What directory or bucket shall we read the files from
STORAGE_READ=

# What directory pr bucket shall we write the files to
STORAGE_WRITE=

USER=
PASSWD=

# For debugging purposes mou can set this to something else
output=/dev/null

cmd=$1

ret=0
if [ "x${cmd}" == "xwrite" ]; then

    number=$2
    ret=`**COMMAND TO WRITE THE FILE FROM TO THE REMOTE SERVER** >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xread" ]; then

   number=$2
    ret=`**COMMAND TO READ THE FILE AND WRITE IT TO SOME LOCATION**  >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xdelreaddir" ]; then

    **COMMAND TO DELETE DIRECTORY ON REMOTE SERVER TO READ FILES FROM** >${output} 2>&1

elif [ "x${cmd}" == "xdelwritedir" ]; then

    **COMMAND TO DELETE DIRECTORY ON REMOTE SERVER TO WRITE FILES TO** >${output} 2>&1

elif [ "x${cmd}" == "xcreatereaddir" ]; then

    ret=`**COMMAND TO CREATE DIRECTORY ON REMOTE SERVER TO READ FILES FROM** >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xcreatewritedir" ]; then

    ret=`**COMMAND TO CREATE DIRECTORY ON REMOTE SERVER TO WRITE FILES TO** >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xcreatereadfile" ]; then

    number=$2
    ret=`**COMMAND TO CREATE FILE-${number} ON REMOTE SERVER TO BE READ BACK DURING THE TESTS** >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xkill" ]; then

    **COMMAND TO KILL THE TRANSFER PROCESS**

else

    ret=1

fi

echo $ret

