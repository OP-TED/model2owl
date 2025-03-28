#!/bin/bash
SCRIPT_DIR=$(realpath $(dirname "${BASH_SOURCE[0]}"))
PROJ_DIR=$(dirname $(dirname $SCRIPT_DIR))

SAXON_DIR=${PROJ_DIR}/saxon-12.5
XSPEC=${PROJ_DIR}/target/xspecmaven/xspec-framework/xspec-3.0.3/bin/xspec.sh

SAXON_HOME=${SAXON_DIR} find ${PROJ_DIR}/test/unitTests -name '*.xspec' -exec sh -c "$XSPEC -c {}" \; 

# uncomment to copy the reports into a single new directory
# cd ${PROJ_DIR}/test/unitTests
# mkdir -p coverage/coverage-reports
# find . -name '*-coverage.html' -exec cp -t coverage/coverage-reports {} +
# cd - &> /dev/null
