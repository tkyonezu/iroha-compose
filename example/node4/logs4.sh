#!/bin/sh

#
# Copyright 2018 Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [[ "$(uname -s)" == "Darwin"  && "$(uname -m)" == "x86_64" ]]; then
  SYST="MacOS"
elif [[ "$(uname -s)" == "Linux" && "$(uname -m)" == "x86_64" ]]; then
  SYST="Linux"
elif [[ "$(uname -s)" == "Linux" && "$(uname -m)" == "armv7l" ]]; then
  SYST="RaspberryPi"
else
  echo "($(uname -s)/$(uname -m)) Doesn't Support."
  exit 1
fi


if [ "${SYST}" == "MacOS" ]; then
  TERM="/dev/ttys00"
  n=$(tty | sed 's|/dev/ttys||')
  n=$((n+=0))
elif [ "${SYST}" == "Linux" ]; then
  if echo $(uname -r) | grep -q Microsoft; then
    TERM="/dev/tty"
  else
    TERM="/dev/pts/"
  fi
  n=$(tty | sed "s|${TERM}||")
elif [ "${SYST}" == "RaspberryPi" ]; then
  TERM="/dev/pts/"
fi

for i in $(seq 4); do
  docker logs -f iroha-node${i} >${TERM}$((n + i - 1)) &
done
