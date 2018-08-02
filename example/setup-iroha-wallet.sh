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

function rx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  docker exec -i ${CONTAINER_NAME} iroha-cli \
    --account_name admin@test \
    --key_path /opt/iroha/config \
    <<EOF | grep -E '(2018|^Congratulation|^Its)' | sed 's/^>.*: //'
2
$2
$3
$4
$5
$6
$7
$8
1
${IROHA_IP}
${IROHA_PORT}
EOF
}

tx CreateAccount 12 alice test $(cat alice@test.pub)
sleep 1
rx GetAccountInformation 9 alice@test

tx CreateAccount 12 bob test $(cat bob@test.pub)
sleep 1
rx GetAccountInformation 9 bob@test

tx CreateAsset 14 coolcoin test 2
sleep 1
rx GetAssetInformation 3 'coolcoin#test'

tx CreateAsset 14 hotcoin test 5
sleep 1
rx GetAssetInformation 3 'hotcoin#test'

tx AddAssetQuantity 16 'coolcoin#test' 1000 0
sleep 1
rx GetAccountAsset 8 admin@test 'coolcoin#test'

tx AddAssetQuantity 16 'hotcoin#test' 1000 0
sleep 1
rx GetAccountAsset 8 admin@test 'hotcoin#test'

tx TransferAsset 5 admin@test alice@test 'coolcoin#test' 500.00
sleep 1
rx GetAccountAsset 8 alice@test 'coolcoin#test'

tx TransferAsset 5 admin@test alice@test 'hotcoin#test' 500.00000
sleep 1
rx GetAccountAsset 8 alice@test 'hotcoin#test'

tx TransferAsset 5 admin@test bob@test 'coolcoin#test' 500.00
sleep 1
rx GetAccountAsset 8 bob@test 'coolcoin#test'

tx TransferAsset 5 admin@test bob@test 'hotcoin#test' 500.00000
sleep 1
rx GetAccountAsset 8 bob@test 'hotcoin#test'

exit 0
