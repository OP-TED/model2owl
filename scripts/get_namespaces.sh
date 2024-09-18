#!/bin/bash
# 
# Gets namespaces from namespaces.xml file and prepares argument
# list from them to be used with `rdfpipe` tool.
# Uses Saxon installed in the project main directory.

PROJECT_DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
NAMESPACES_DIR=${PROJECT_DIR}/test/ePO-default-config

cd ${NAMESPACES_DIR}
namespaces=$(
    java -cp ../../saxon/saxon.jar net.sf.saxon.Query -s:namespaces.xml \
		-qs:'for $x in /*:prefixes/*:prefix return concat(string($x/@name), "=", string($x/@value))' \
		\!method=text
)
ns_args=$( \
	echo "$namespaces" | tr ' ' '\n' | awk '{printf("--ns='\''%s'\'' ", $0)}'
)

echo "$ns_args"
