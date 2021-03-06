#!/bin/bash
#
# Copyright (c) 2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

for peer in iroha1 iroha2 iroha3 iroha4; do
  echo "$ ssh ${peer} docker compose up -d"
  ssh ${peer} "(cd github.com/tkyonezu/iroha-compose/example/multi-node; docker-compose up -d)"
done

exit 0
