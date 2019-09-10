#!/bin/bash

. settings.sh

killall -9 test_start.sh
killall -9 test_child.sh
killall -9 prepare_test.sh
killall -9 dd

eval ${TRANSFER_CMD} kill
