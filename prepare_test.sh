#!/bin/bash

. settings.sh

SEC=0.1

IF=/dev/zero
OF=/dev/null

usage () {
  echo "Usage: $0"
}

transfer_cmd=$TRANSFER_CMD
if [ ! -x ${transfer_cmd} ]; then
  echo "${transfer_cmd} not found."
  exit 1
fi

mkdir -p $WRITEDIR
NUMCONCURRENT=2
output=output${TESTFILE_SIZE_KB}
error=error${TESTFILE_SIZE_KB}

# Create test file to be copied to the remote machine
dd if=$IF of=$WRITEDIR/file${TESTFILE_SIZE_KB} bs=${TESTFILE_SIZE_KB} count=1024 2>&1 | sed -e "s/^/write $i: /" > $output &
wait

# If remote directory to read files from already exists, then delete it.
eval ${transfer_cmd} delreaddir >/dev/null 2>&1

# If remote directory to write files to already exists, then delete it.
eval ${transfer_cmd} delwritedir >/dev/null 2>&1

# Create remote directory to read files from
ret=`eval ${transfer_cmd} createreaddir`
if [ "x$ret" != "x0" ]; then
  echo "Unable to create remote read directory."
  exit 1
fi

# Create remote directory to write files to
ret=`eval ${transfer_cmd} createwritedir`
if [ "x$ret" != "x0" ]; then
  echo "Unable to create remote write directory."
  exit 1
fi

# Loop over all files that will be created on the remote machine to do the read
# tests
k=1
while [ $k -le $FILES ]
do

# Write the files concurrently
    i=1
    while [ $i -le ${NUMCONCURRENT} -a $k -le $FILES ]
    do
        ret=`eval ${transfer_cmd} createreadfile ${k}`
        if [ "x$ret" != "x0" ]; then
          echo "Unable to write remote file."
          exit 1
        fi

        i=`expr $i + 1`
        k=`expr $k + 1`
        sleep $SEC

    done
    wait

done
