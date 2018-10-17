#!/bin/bash
# 
# Copyright (c) 2018, Takeshi Yonezu. All Rights Reserved.
#

for i in $(seq 4); do
  cat node${i}.pub | xxd -r -p | base64
done

exit 0
