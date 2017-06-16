#!/bin/sh
#
# changed_packages.sh
# adapted from https://github.com/voidlinux/void-packages/blob/master/common/travis/changed_templates.sh

COMMIT_RANGE=$1

/bin/echo -e '\x1b[32mChanged packages:\x1b[0m'
#git diff --name-only FETCH_HEAD...HEAD | grep "PKGBUILD$" | cut -d/ -f 1 | tee /tmp/packages_changed.txt
git show --name-only $COMMIT_RANGE | grep "PKGBUILD$" | cut -d/ -f 1 | tee /tmp/packages_changed_dup.txt

# a package may have changed multiple times leading to multiple entries in the changed file
sort /tmp/packages_changed_dup.txt | uniq > /tmp/packages_changed.txt

# exit based on whether any packages changed
retval=0
if [ "$(cat /tmp/packages_changed.txt)" = "" ]; then
	retval=1
fi

exit $retval
