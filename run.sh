
# curl -L -o jena.zip "https://dlcdn.apache.org/jena/binaries/apache-jena-5.0.0.zip" && unzip jena.zip && rm -rf jena.zip

java -jar ./saxon/saxon.jar -s:input/eAccess.xml -xsl:input/experiments/node-edge-mini.xsl -o:output/node-edge-mini.xml
java -jar ./saxon/saxon.jar -s:input/eAccess.xml -xsl:input/experiments/shacl-mini.xsl -o:output/shacl-mini.ttl
# ./jena/apache-jena-5.0.0/bin/riot --output=ttl output/shacl-mini.ttl > output/shacl-mini.pretty.ttl

java -jar ./saxon/saxon.jar -s:input/eAccess.xml -xsl:src/shacl-shapes.xsl -o:output/eAccess.rdf.xml
