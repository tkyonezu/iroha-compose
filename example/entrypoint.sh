#!/bin/bash

# Copyright (c) 2017-2021 Takeshi Yonezu
# All Rights Reserved.

cd ${IROHA_HOME}/config

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_NODEKEY=${IROHA_NODEKEY:-node1}
IROHA_GENESIS=${IROHA_GENESIS:-genesis.block}

DB_TYPE=$(cat ${IROHA_CONF} |grep "type" | sed -e 's/^.*://' -e "s/ *\"//" -e "s/\".*,//")

if [ "${DB_TYPE}" = "postgres" ]; then
  if grep -q pg_opt ${IROHA_CONF}; then
    PG_HOST=$(cat ${IROHA_CONF} | grep pg_opt | sed -e 's/^.*host=//' -e 's/ .*//')
    PG_PORT=$(cat ${IROHA_CONF} | grep pg_opt | sed -e 's/^.*port=//' -e 's/ .*//')
  else
    PG_HOST=$(cat ${IROHA_CONF} | grep host | sed -e 's/^.*host" *: *"//' -e 's/".*//')
    PG_PORT=$(cat ${IROHA_CONF} | grep "[^_]port" | sed -e 's/^.*port" *: *//' -e 's/,.*//')
  fi

  WAIT_FOR_IT="/wait-for-it.sh"

  ${WAIT_FOR_IT} -h ${PG_HOST} -p ${PG_PORT} -t 60 -- true

  # if Raspberry Pi 3B or 3B+, Wait until PostgreSQL is stabilized
  if [ "$(uname -m)" = "armv7l" ]; then
    # Raspberry Pi 4B does'nt need sleep
    if ! grep ^Model /proc/cpuinfo | grep -q "Raspberry Pi 4"; then
      sleep 30
    fi
  fi
fi

echo "$ irohad --config ${IROHA_CONF} --genesis_block ${IROHA_GENESIS} --keypair_name ${IROHA_NODEKEY}"

irohad --config ${IROHA_CONF} \
  --genesis_block ${IROHA_GENESIS} \
  --keypair_name ${IROHA_NODEKEY}
