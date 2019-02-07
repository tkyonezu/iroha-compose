#!/bin/bash
# 
# Copyright (c) 2018, 2019, Takeshi Yonezu. All Rights Reserved.
#

IROHA_IP=127.0.0.1
IROHA_PORT=50051

if [ $# -gt 0 ]; then
  TRAN_NO=$1
fi

TRAN_NO=${TRAN_NO:-200}

function tx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name alice@test \
    --key_path /opt/iroha/config \
    <<EOF | grep -E '(^\[20|^Congratulation|^Its)' | sed 's/^>.*: //'
tx
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

for i in $(seq ${TRAN_NO}); do
  tx TransferAsset tran_ast alice@test bob@test 'hotcoin#test' 0.00001
done

exit 0
