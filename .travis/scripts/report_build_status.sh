#!/bin/bash
# report_build_status.sh: to report which packages were attempted and how many got failed

ATTEMPT_LOG=/tmp/packages_attempted.txt
FAIL_LOG=/tmp/packages_failed.txt

echo "packages attempted: $(cat $ATTEMPT_LOG | wc -l)"
cat $ATTEMPT_LOG

if [ ! -f "$FAIL_LOG" ]; then
	echo "packages failed: none"
else
	echo "packages failed: $(cat $FAIL_LOG | wc -l)"
	cat $FAIL_LOG
fi
