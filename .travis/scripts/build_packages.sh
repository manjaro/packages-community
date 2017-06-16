#!/bin/bash
# to build specified packages

# commit range for which we are checking package changes
COMMIT_RANGE=$1

# regenerate packages to build in case we are in a chroot
# assuming we are in base git directory (packages-openrc)
/bin/bash .travis/scripts/changed_packages.sh $COMMIT_RANGE > /dev/null

# get the changed packages
PKGS=$(cat /tmp/packages_changed.txt)

# there are special flags for init system
BUILDPKG_FLAGS=
[ "$INIT" = openrc ] && BUILDPKG_FLAGS="-u"

# import common functions
. .travis/scripts/functions.sh

# record exit status to determine if all packages got build
STATUS=0

# build the changed packages
for pkg in ${PKGS}; do
	[ ! -e "$pkg" ] && continue  # package probably deleted
	#cd "${pkg}"

	travis_fold start "build_${pkg}"
	echo "building $pkg"
	echo "$pkg" >> /tmp/packages_attempted.txt
	if [ "$VERBOSE_BUILD" -eq 1 ]; then
		# redirect to log
		travis_ping start "$pkg"
		buildpkg -c $BUILDPKG_FLAGS -b unstable -p "$pkg" >> /tmp/build_${pkg}.log
	else
		# show package building output
		buildpkg -c $BUILDPKG_FLAGS -b unstable -p "$pkg"
	fi
	if [ ! "$?" -eq 0 ]; then
		STATUS=1  # build failed
		echo "$pkg" >> /tmp/packages_failed.txt
	fi
	if [ "$VERBOSE_BUILD" -eq 1 ]; then
		travis_ping stop
		echo "first 150 lines of log"
		head -n 150 /tmp/build_${pkg}.log
		echo "..."
		echo "last 150 lines of log"
		tail -n 150 /tmp/build_${pkg}.log
	fi
	travis_fold end "build_${pkg}"

	#cd ..
done

exit $STATUS
