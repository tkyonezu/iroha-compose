#!/bin/bash
#
# Copyright (c) 2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

for peer in senzu8.local senta11.local iroha.local raspi.local; do
  echo "$ ssh ${peer} docker compose up -d"
  ssh ${peer} "(cd github.com/tkyonezu/iroha-compose/example/multi-node; docker-compose up -d)"
done

exit 0
