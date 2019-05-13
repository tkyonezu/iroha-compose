#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

GENESIS_BLOCK=example/multi-node/genesis.block

if [ $# -lt 4 ]; then
  echo "Usage: iroha-peers: <address1> <address2> <address3> <address4>"
  exit 1
fi

if [ ! -f ${GENESIS_BLOCK}.in ]; then
  echo "${GENESIS_BLOCK}.in file not found!"
  exit 1
fi

cat ${GENESIS_BLOCK}.in |
  sed -e "s/IP1/$1/" -e "s/IP2/$2/" -e "s/IP3/$3/" -e "s/IP4/$4/" >${GENESIS_BLOCK}

grep address ${GENESIS_BLOCK}

exit 0
