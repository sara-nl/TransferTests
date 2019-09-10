#!/bin/bash

. settings.sh

# Specify the remote server to copy to and from
REMOTE_SERVER=webdav.grid.surfsara.nl:2882

# Specify the protocol used
PROTOCOL=https

STORAGE_READ=/pnfs/grid.sara.nl/data/users/ron/readfilestest
STORAGE_WRITE=pnfs/grid.sara.nl/data/users/ron/writefilestest

USER=
PASSWD=

output=/dev/null

cmd=$1

if [ "x${cmd}" == "xwrite" ]; then

    number=$2
    ret=`curl --fail -s -S -k --user $USER:$PASSWD -T $WRITEDIR/file${TESTFILE_SIZE_KB} -w "%{http_code}\n" -L ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_WRITE}/testfile_${TESTFILE_SIZE_KB}_${number} >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xread" ]; then

   number=$2
    ret=`curl --fail -s -S -k --user $USER:$PASSWD -L ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_READ}/testfile_${TESTFILE_SIZE_KB}_${number} -o /dev/null  >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xdelreaddir" ]; then

    curl --fail -s -S -k --user $USER:$PASSWD -X DELETE -L ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_READ} >${output} 2>&1

elif [ "x${cmd}" == "xdelwritedir" ]; then

    curl --fail -s -S -k --user $USER:$PASSWD -X DELETE -L ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_WRITE} 1>${output} 2>&1

elif [ "x${cmd}" == "xcreatereaddir" ]; then

    ret=`curl --fail -s -S -k --user $USER:$PASSWD -X MKCOL ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_READ} >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xcreatewritedir" ]; then

    ret=`curl --fail -s -S -k --user $USER:$PASSWD -X MKCOL ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_WRITE} >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xcreatereadfile" ]; then

    number=$2
    ret=`curl --fail -s -S -k --user $USER:$PASSWD -T $WRITEDIR/file${TESTFILE_SIZE_KB} -L ${PROTOCOL}://${REMOTE_SERVER}/${STORAGE_READ}/testfile_${TESTFILE_SIZE_KB}_${number} >${output} 2>&1; echo $?`

elif [ "x${cmd}" == "xkill" ]; then
    kill -9 curl
else

    ret=1

fi

echo $ret

