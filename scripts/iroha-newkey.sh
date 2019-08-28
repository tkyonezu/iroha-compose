#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -lt 1 ]; then
  echo "Usage: iroha-newaccount {<account_name>|<node_name>}"
  exit 1
fi

if [ ! -f .env ]; then
  echo ".env file not found!"
  exit 1
fi

eval $(grep IROHA_PRJ .env)
eval $(grep IROHA_IMG .env)

docker run --rm \
  -v $(pwd)/example/multi-node:/opt/iroha/config \
  --entrypoint iroha-cli \
  --user "$(id -u):$(id -g)" \
  --workdir /opt/iroha/config \
  ${IROHA_PRJ}/${IROHA_IMG} \
  --new_account --account_name $1

exit 0
