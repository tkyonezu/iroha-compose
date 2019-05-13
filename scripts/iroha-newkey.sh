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

docker run --rm \
  -v $(pwd)/example/multi-node:/opt/iroha/config \
  --entrypoint iroha-cli \
  --workdir /opt/iroha/config \
  hyperledger/iroha \
  --new_account --account_name $1

exit 0
