#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -eq 0 ]; then
  echo "Usage: iroha-addpeer <node_name>"
  echo "       iroha-addpeer [ down | restart ]"
  exit 0
fi

if [[ $# -eq 1 && ("$1" = "down" || "$1" = "restart")]]; then
  cd example/multi-node

  echo "$ docker-compose -f docker-compose.yml $1"
  docker-compose -f docker-compose.yml $1

  exit 0
fi

cd example/multi-node

if [ $# -ge 1 ]; then
  IROHA_NODEKEY=$1
else
  IROHA_NODEKEY=node0
fi

cat docker-compose.yml.in |
  sed -e "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=${IROHA_NODEKEY}/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
