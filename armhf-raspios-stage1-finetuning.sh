#!/bin/bash

# https://github.com/RPi-Distro/pi-gen/tree/2021-05-07-raspbian-buster/stage1
STAGE_DIR=/stage1
STAGE_WORK_DIR="${STAGE_DIR}/work"
mkdir -p "$STAGE_WORK_DIR"

# https://github.com/RPi-Distro/pi-gen/blob/2021-05-07-raspbian-buster/stage0/01-locale
SUB_STAGE_DIR="${STAGE_DIR}/01-locale"

install -m 644 "${SUB_STAGE_DIR}/cmdline.txt" /boot/
install -m 644 "${SUB_STAGE_DIR}/config.txt" /boot/

# https://github.com/RPi-Distro/pi-gen/tree/2021-05-07-raspbian-buster/stage1/01-sys-tweaks
SUB_STAGE_DIR="${STAGE_DIR}/01-sys-tweaks"

for i in {00..99}; do
	if [ -d "${i}-patches" ]; then
		pushd "${STAGE_WORK_DIR}" > /dev/null
		QUILT_PATCHES="${SUB_STAGE_DIR}/${i}-patches"
		SUB_STAGE_QUILT_PATCH_DIR="$(basename "$SUB_STAGE_DIR")-pc"
		mkdir -p "$SUB_STAGE_QUILT_PATCH_DIR"
		ln -snf "$SUB_STAGE_QUILT_PATCH_DIR" .pc
		quilt upgrade
		RC=0
		quilt push -a || RC=$?
		case "$RC" in
			0|2)
				;;
			*)
				false
				;;
		esac
		popd > /dev/null
	fi
done

install -d "/etc/systemd/system/getty@tty1.service.d"
install -m 644 "${SUB_STAGE_DIR}/noclear.conf" "/etc/systemd/system/getty@tty1.service.d/noclear.conf"

# https://github.com/RPi-Distro/pi-gen/tree/2021-05-07-raspbian-buster/stage1/02-net-tweaks
SUB_STAGE_DIR="${STAGE_DIR}/02-net-tweaks"
