#!/bin/bash
# 
# Copyright (c) 2018-2019 Takeshi Yonezu
# All Rights Reserved.
#

IROHA_IP=127.0.0.1
IROHA_PORT=50051

function rx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name bob@test \
    --key_path /opt/iroha/config \
    <<EOF | grep -E '(^\[20|^Congratulation|^Its)' | sed 's/^>.*: //'
qry
$2
$3
$4
$5
$6
$7
$8
send
${IROHA_IP}
${IROHA_PORT}
EOF
}

while true; do
  rx GetAccountAsset get_acc_ast bob@test 'hotcoin#test'
  sleep 1
done

exit 0
