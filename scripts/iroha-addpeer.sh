#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

function usage {
  echo "Usage: iroha-addpeer <node_name>"
  echo "       iroha-addpeer [ restart | logs | down | clean ]"
  exit 0
}

if [ $# -eq 0 ]; then
  usage
fi

cd example/multi-node

case "$1" in
  logs)
    echo "$ docker logs -f iroha_node_1 &"
    docker logs -f iroha_node_1 &
    exit 0;;
  restart)
    echo "$ docker-compose -f docker-compose.yml $1"
    docker-compose -f docker-compose.yml $1

    exit 0;;
  down)
    echo "$ docker-compose -f docker-compose.yml $1"
    docker-compose -f docker-compose.yml $1

    echo "$ docker volume prune -f"
    docker volume prune -f

    exit 0;;
  clean)
    echo "$ rm -f block_store/0*"
    rm -f block_store/0*
    exit 0;;
esac

echo "Cleanup current block_store data:"
echo "$ rm -f block_store/0*"
rm -f block_store/0*

cat docker-compose.yml.in |
  sed -e "s/KEY=.*/KEY=${1}/" >docker-compose.yml

if [ "$(uname -s)" = "Darwin" ]; then
  sed -i '' "s/user:.*/user: \"$(id -u):$(id -g)\"/" docker-compose.yml
else
  sed -i "s/user:.*/user: \"$(id -u):$(id -g)\"/" docker-compose.yml
fi

echo "Current node:"
echo "    $(grep KEY docker-compose.yml | sed 's/.*KEY=//')"

PEERS=$(grep address genesis.block | sed 's/.*address":"/    /' | sed 's/",//')
echo "Peers:"
echo "${PEERS}"

if [ ! -d block_store ]; then
  echo "$ mkdir block_store"
  mkdir block_store

  echo "$ sudo chown $(id -u):$(id -g) block_store"
  sudo chown $(id -u):$(id -g) block_store
fi

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
