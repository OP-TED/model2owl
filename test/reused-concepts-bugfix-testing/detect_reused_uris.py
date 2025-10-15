"""
Script to detect reused URIs in an RDF graph. It identifies subjects that URIs
do not start with the specified namespace prefix.
"""

import sys
from rdflib import Graph


def find_reused_uris(graph):
    query = """
        PREFIX a4g: <http://data.europa.eu/a4g/ontology#>

        SELECT ?s ?p ?o
        WHERE {
            ?s ?p ?o
            FILTER (isURI(?s) && (!STRSTARTS(str(?s), str(a4g:))))
        }
    """
    return [row for row in graph.query(query)]
    

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python detect_reused_uris.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    g = Graph()
    g.parse(input_file, format="turtle")

    found_triples = find_reused_uris(g)
    assert not found_triples, (
        f"Reused URIs found in triples for file {input_file}.\n"
        f"Found triples:\n{found_triples}"
    )
    print(f"No reused URIs found in file {input_file}.")