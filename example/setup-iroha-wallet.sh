#!/bin/bash
# 
# Copyright (c) 2018, Takeshi Yonezu. All Rights Reserved.
#

CONTAINER_NAME="iroha_node_1"

IROHA_IP=0.0.0.0
IROHA_PORT=50051

function tx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  docker exec -i ${CONTAINER_NAME} iroha-cli \
    --account_name admin@test \
    --key_path /opt/iroha/config \
    <<EOF | grep -E '(2018|^Congratulation|^Its)' | sed 's/^>.*: //'
1
$2
$3
$4
$5
$6
$7
$8
2
${IROHA_IP}
${IROHA_PORT}
EOF
}

tx CreateAccount 12 alice test $(cat alice@test.pub)
tx CreateAccount 12 bob test $(cat bob@test.pub)
tx CreateAsset 14 coolcoin test 2
tx CreateAsset 14 hotcoin test 5
tx AddAssetQuantity 16 admin@test 'coolcoin#test' 1000 0
tx AddAssetQuantity 16 admin@test 'hotcoin#test' 1000 0
tx TransferAsset 5 admin@test alice@test 'coolcoin#test' 50 2
tx TransferAsset 5 admin@test alice@test 'hotcoin#test' 50000 5
tx TransferAsset 5 admin@test bob@test 'coolcoin#test' 50 2
tx TransferAsset 5 admin@test bob@test 'hotcoin#test' 50000 5

exit 0
