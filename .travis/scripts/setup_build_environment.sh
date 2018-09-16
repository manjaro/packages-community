#!/bin/bash
# to setup test environment where packages can be built

ORIGINAL_DIR="$(pwd)"
CHROOT_DIR_NAME="manjaro-chroot"
CHROOT_DIR="${HOME}/manjaro-chroot"
CHROOT_BUILD_DIR_NAME="build"
CHROOT_BUILD_DIR="${CHROOT_DIR}/${CHROOT_BUILD_DIR_NAME}"

# import common functions
. .travis/scripts/functions.sh

# download script to setup chroot for building
cd "$HOME"

git clone https://github.com/aadityabagga/manjaro-bootstrap.git
cd manjaro-bootstrap
# setup bootstrap config
if [ -e "${ORIGINAL_DIR}/.travis/config/manjaro-bootstrap-config.sh" ]; then
	cp -v "${ORIGINAL_DIR}/.travis/config/manjaro-bootstrap-config.sh" config.sh
fi

LOG_NAME=arch-bootstrap.log
LOG_LOC=/tmp/${LOG_NAME}

travis_ping start manjaro-bootstrap # since we are redirecting to log file
sudo ./arch-bootstrap.sh -d "${HOME}/pkg_download" "${CHROOT_DIR}" >> "${LOG_LOC}" 2>&1
travis_ping stop
echo "last 200 lines of ${LOG_LOC}"
tail -n 200 "$LOG_LOC"

cd "${ORIGINAL_DIR}"

# copy things forward to a new directory within the chroot
sudo mkdir "${CHROOT_BUILD_DIR}"
sudo chmod -R 777 "${CHROOT_BUILD_DIR}"
cp -a "${ORIGINAL_DIR}" "${CHROOT_BUILD_DIR}"
