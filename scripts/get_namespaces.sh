#!/bin/bash
# 
# Gets namespaces from an XML file with the model2owl project namespaces and
# prepares argument list from them to be used with `rdfpipe` tool. Uses Saxon
# installed in the project main directory.
# 
# USAGE: get_namespaces.sh NAMESPACES_XML_FILE_PATH
PROJECT_DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))
SAXON=${PROJECT_DIR}/saxon/saxon.jar

if [ -z "$1" ]; then
	echo "ERROR: path to *.xml file with namespaces not given."
	exit 1
fi
namespaces_file_path="$1"

namespaces_file_dir=$(dirname $(realpath $namespaces_file_path))
namespaces_file_name=$(basename $namespaces_file_path)

cd ${namespaces_file_dir}
namespaces=$(
    java -cp $SAXON net.sf.saxon.Query -s:${namespaces_file_name} \
		-qs:'for $x in /*:prefixes/*:prefix return concat(string($x/@name), "=", string($x/@value))' \
		\!method=text
)
ns_args=$( \
	echo "$namespaces" | tr ' ' '\n' | awk '{printf("--ns='\''%s'\'' ", $0)}'
)

echo "$ns_args"
