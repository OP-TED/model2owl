from rdflib import Graph
import argparse

parser = argparse.ArgumentParser(description='Convert RDF/XML into Turtl format.')
parser.add_argument('--input', help='input file in any format e.g. RDF/XML', required=True)
parser.add_argument('--output', help='output file in turtl format', required=True)

args = parser.parse_args()

g = Graph() 
g.parse(args.input)
g.serialize(destination=args.output, format='turtle')
