
# curl -L -o jena.zip "https://dlcdn.apache.org/jena/binaries/apache-jena-5.0.0.zip" && unzip jena.zip && rm -rf jena.zip

# make shacl
# ./jena/apache-jena-5.0.0/bin/riot --output=ttl output/ePO_CM_shapes.rdf > output/ePO_CM_shapes.ttl

java -jar ./saxon/saxon.jar -s:test/missing-properties/eAccess.xml -xsl:test/missing-properties/node-edge-mini.xsl -o:output/node-edge-mini.xml

java -jar ./saxon/saxon.jar -s:test/missing-properties/eAccess.xml -xsl:test/missing-properties/shacl-mini.xsl -o:output/shacl-mini.ttl
./jena/apache-jena-5.0.0/bin/riot --output=ttl output/shacl-mini.ttl > output/shacl-mini.pretty.ttl
