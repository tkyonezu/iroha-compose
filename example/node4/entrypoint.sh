#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

cd ${IROHA_HOME}/config

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_BLOCK=$(cat ${IROHA_CONF} | grep block_store_path |
  sed -e 's/^.*: "//' -e 's/".*$//')
IROHA_GENESIS=${IROHA_GENESIS:-genesis.block}
IROHA_NODEKEY=${IROHA_NODEKEY:-node0}

if grep -q pg_opt ${IROHA_CONF}; then
  PG_HOST=$(cat ${IROHA_CONF} | grep pg_opt | sed -e 's/^.*host=//' -e 's/ .*//')
  PG_PORT=$(cat ${IROHA_CONF} | grep pg_opt | sed -e 's/^.*port=//' -e 's/ .*//')
else
  PG_HOST=$(cat ${IROHA_CONF} | grep host | sed -e 's/^.*host" *: *"//' -e 's/".*//')
  PG_PORT=$(cat ${IROHA_CONF} | grep "[^_]port" | sed -e 's/^.*port" *: *//' -e 's/,.*//')
fi

if [ -x /wait-for-it.sh ]; then
  /wait-for-it.sh -h ${PG_HOST} -p ${PG_PORT} -t 60 -- true
else
  /opt/iroha/bin/wait-for-it.sh -h ${PG_HOST} -p ${PG_PORT} -t 60 -- true
fi

# Raspberry Pi, Wait until PostgreSQL is stabilized
if [ "$(uname -m)" = "armv7l" ]; then
  # Raspberry Pi 4B does'nt need sleep
  if ! grep ^Model /proc/cpuinfo | grep -q "Raspberry Pi 4"; then
    sleep 30
  fi
fi

if [ -f ${IROHA_BLOCK}0000000000000002 ]; then
  echo "$ irohad --config ${IROHA_CONF} --keypair_name ${IROHA_NODEKEY}"

  irohad --config ${IROHA_CONF} \
    --keypair_name ${IROHA_NODEKEY}
else
  echo "$ irohad --config ${IROHA_CONF} --genesis_block ${IROHA_GENESIS} --keypair_name ${IROHA_NODEKEY}"

  irohad --config ${IROHA_CONF} \
    --genesis_block ${IROHA_GENESIS} \
    --keypair_name ${IROHA_NODEKEY}
fi
