#!/bin/bash
# deploy_built_packages.sh: to deploy built packages
# NOTE: uses encrypted variables

PKG_LOCATION="$HOME/manjaro-chroot/var/cache/manjaro-tools/pkg/unstable/x86_64/"
SFREPO="frs.sourceforge.net:/home/frs/project/mefiles/Manjaro/test/packages-community/x86_64/"
SFUSER="aaditya1234"

if [ ! -f "${HOME}/.ssh/id_rsa" ]; then
	# cant deploy without key
	echo "deployment key not found"
	exit 1
fi

# check what branch it is; we only deploy for certain branches
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" != "" ]; then
	# in case of pull request we check originating branch
	CURRENT_BRANCH=${TRAVIS_PULL_REQUEST_BRANCH}
else
	CURRENT_BRANCH=${TRAVIS_BRANCH}
fi

ALLOWED_BRANCHES=(master deploy)
ALLOW_DEPLOY=1
for branch in "${ALLOWED_BRANCHES[@]}"; do
	if [ "$CURRENT_BRANCH" = $branch ]; then
		# check if check above is robust enough
		ALLOW_DEPLOY=0
		break
	fi
done

if [ "$ALLOW_DEPLOY" -eq 1 ]; then
	echo "not allowed to deploy for $CURRENT_BRANCH"
	exit 1
fi

if [ "$(ls -1 ${PKG_LOCATION} | wc -l)" -gt 0 ]; then
	# upload to tmp repo for testing
	rsync -auvLPH -e ssh "${PKG_LOCATION}" "${SFUSER}"@"${SFREPO}"
fi
