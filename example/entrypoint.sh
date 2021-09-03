#!/bin/bash

# Copyright (c) 2017-2021 Takeshi Yonezu
# All Rights Reserved.

cd ${IROHA_HOME}/config

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_GENESIS=${IROHA_GENESIS:-genesis.block}
IROHA_NODEKEY=${IROHA_NODEKEY:-node1}

if [ ! -f ${IROHA_BLOCK}0000000000000001 ]; then
  echo "$ irohad --config ${IROHA_CONF} --genesis_block ${IROHA_GENESIS} --keypair_name ${IROHA_NODEKEY} --drop_state"

  irohad --config ${IROHA_CONF} \
    --genesis_block ${IROHA_GENESIS} \
    --keypair_name ${IROHA_NODEKEY} \
    --drop_state
elif [ ! -f ${IROHA_BLOCK}0000000000000002 ]; then
  echo "$ irohad --config ${IROHA_CONF} --genesis_block ${IROHA_GENESIS} --keypair_name ${IROHA_NODEKEY}"

  irohad --config ${IROHA_CONF} \
    --genesis_block ${IROHA_GENESIS} \
    --keypair_name ${IROHA_NODEKEY}
else
  echo "$ irohad --config ${IROHA_CONF} --keypair_name ${IROHA_NODEKEY}"

  irohad --config ${IROHA_CONF} \
    --keypair_name ${IROHA_NODEKEY}
fi
