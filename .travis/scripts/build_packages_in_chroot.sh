#!/bin/bash
# to build the packages after entering into the chroot

CHROOT_DIR_NAME="manjaro-chroot"
CHROOT_DIR_LOC="${HOME}/manjaro-chroot"
CHROOT_BUILD_DIR_NAME="build"
CHROOT_BUILD_DIR_LOC="${CHROOT_DIR_LOC}/${CHROOT_BUILD_DIR_NAME}"

user=$USER

# commit range for which we will be building the packages
COMMIT_RANGE=$1

# get repo name
REPO_NAME=$(echo $TRAVIS_REPO_SLUG | cut -f 2 -d /)

# import common functions
. .travis/scripts/functions.sh

# chroot!
DEST=${CHROOT_DIR_LOC}
sudo mount -t proc proc $DEST/proc/
sudo mount -t sysfs sys $DEST/sys/
sudo mount -o bind /dev $DEST/dev/
sudo mount -o bind /run $DEST/run/
sudo cp /etc/resolv.conf $DEST/etc/resolv.conf

# setup environment in the chroot (pacman keys and stuff)
travis_fold start setup_chroot_environment
echo "setting up chroot"
sudo chroot "${CHROOT_DIR_LOC}" /bin/bash -c "cd /build/$REPO_NAME && .travis/scripts/setup_chroot_environment.sh $user"
travis_fold end setup_chroot_environment

# build the packages in the chroot
sudo chroot "${CHROOT_DIR_LOC}" /bin/bash -c "cd /build/$REPO_NAME && .travis/scripts/build_packages.sh $COMMIT_RANGE"
BUILD_STATUS=$?

# move out the build logs
cp -v "${CHROOT_DIR_LOC}/tmp/packages_attempted.txt" /tmp/
cp -v "${CHROOT_DIR_LOC}/tmp/packages_failed.txt" /tmp/

# cleanup
sudo umount $DEST/proc/
sudo umount $DEST/sys/
sudo umount $DEST/dev/
sudo umount $DEST/run/

# exit based on whether packages got built
BUILT_PKG_DIR="${HOME}/manjaro-chroot/var/cache/manjaro-tools/pkg/unstable/x86_64"
if [ "$FAIL_STRICT" -eq 0 ]; then
	# we fail if any package failed to build
	retval=$BUILD_STATUS
else
	retval=0
	if [ "$(ls -1 ${BUILT_PKG_DIR} | wc -l)" -eq 0 ]; then
		# no packages got built, ie, failure
		retval=1
	fi
fi

[ ! "$retval" -eq 0 ] && echo "some packages failed to build"
exit $retval
