#!/bin/bash

# https://github.com/RPi-Distro/pi-gen/tree/2021-05-07-raspbian-buster/stage0
STAGE_DIR='/stage0'

# https://github.com/RPi-Distro/pi-gen/blob/2021-05-07-raspbian-buster/stage0/01-locale/
SUB_STAGE_DIR="${STAGE_DIR}/01-locale"

for i in {00..99}; do
	if [ -f "${SUB_STAGE_DIR}/${i}-debconf" ]; then
		debconf-set-selections "${SUB_STAGE_DIR}/${i}-debconf"
	fi
done
