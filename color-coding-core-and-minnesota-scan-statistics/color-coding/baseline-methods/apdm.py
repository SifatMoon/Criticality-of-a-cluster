import networkx as nx


class APDM_Writer():

    def __init__(self):
        return

    def write(self, outfname, G, S=None, name=None):
        if name is None:
            name = "null"
        with open(outfname, 'w') as f:
            self._write_header(f)
            self._write_section1(f, G, name)
            self._write_section2(f, G)
            self._write_section3(f, G)
            self._write_section4(f, S)

    def _write_header(self, f):
        f.write("#################################################################\n")
        f.write("#APDM Input Graph, this input graph includes 3 sections:\n")
        f.write("#section1 : general information\n")
        f.write("#section2 : nodes\n")
        f.write("#section3 : edges\n")
        f.write("#section4 : trueSubGraph (Optional)\n")
        f.write("#\n")
        f.write("#if nodes haven't information set weight to null\n")
        f.write("#if nodes haven't information set weight to null\n")
        f.write("#################################################################\n")

    def _write_section1(self, f, G, name):
        f.write("SECTION1 (General Information)\n")
        f.write("numNodes = %s\n" % len(G))
        f.write("numEdges = %s\n" % G.number_of_edges())
        f.write("usedAlgorithm = KCCSM\n")
        f.write("dataSource = %s\n" % name)
        f.write("END\n")
        f.write("#################################################################\n")
        
    def _write_section2(self, f, G):
        f.write("SECTION2 (Node Information)\n")
        f.write("NodeID Weight\n")
        for node, data in G.nodes_iter(data=True):
            weight = data['weight'] if 'weight' in data else "null"
            f.write("%s %s\n" % (node, weight))
        f.write("END\n")
        f.write("#################################################################\n")

    def _write_section3(self, f, G):
        f.write("SECTION3 (Edges Information)\n")
        f.write("EndPoint0 EndPoint1 Weight\n")
        for u, v, data in G.edges_iter(data=True):
            weight = data['weight'] if 'weight' in data else "null"
            f.write("%s %s %s\n" % (u, v, weight))
        f.write("END\n")
        f.write("#################################################################\n")

    def _write_section4(self, f, S):
        f.write("SECTION4 (TrueSubgraphInformation)\n")
        f.write("EndPoint0 EndPoint1 Weight\n")
        if S is None:
            f.write("null\n")
        else:
            for node, data in S.nodes_iter(data=True):
                weight = data['weight'] if 'weight' in data else "null"
                f.write("%s %s\n" % (node, weight))
        f.write("END\n")
        f.write("#################################################################\n")


class APDM_Reader():

    def __init__(self):
        return

    def read(self, fname, parse_ids=True):
        G = nx.Graph()
        S = set()
        with open(fname) as f:
            # read number of nodes and edges
            n, m = self._read_section1(f)
            # read nodes
            self._read_section2(f, G, parse_ids)
            assert(len(G) == n)
            # read edges
            total = self._read_section3(f, G, parse_ids)
            assert(total == m)
            # read true subgraph 
            S = self._read_section4(f, parse_ids)
        return G, S

    def _read_section1(self, f):
        line = f.readline()
        while not line.startswith('SECTION1'):
            line = f.readline()
        n = int(f.readline().strip().split()[-1])
        m = int(f.readline().strip().split()[-1])
        return n, m

    def _read_section2(self, f, G, parse_ids=True):
        line = f.readline()
        while not line.startswith('SECTION2'):
            line = f.readline()
        line = f.readline()
        line = f.readline()
        while not line.startswith('END'):
            tokens = line.strip().split()
            node = int(tokens[0]) if parse_ids else tokens[0]
            G.add_node(node)
            if tokens[1] != "null":
                G.node[node]['weight'] = float(tokens[1])
            line = f.readline()

    def _read_section3(self, f, G, parse_ids=True):
        total = 0
        line = f.readline()
        line = f.readline()
        line = f.readline()
        line = f.readline()
        while not line.startswith('END'):
            total += 1
            tokens = line.strip().split()
            if parse_ids:
                u, v, weight = int(tokens[0]), int(tokens[1]), tokens[2]
            else:
                u, v, weight = tokens[0], tokens[1], tokens[2]
            assert(u in G and v in G)
            if weight == "null":
                G.add_edge(u, v)
            else:
                G.add_edge(u, v, weight=float(weight))
            line = f.readline()
        return total

    def _read_section4(self, f, parse_ids=True):
        line = f.readline()
        line = f.readline()
        line = f.readline()
        line = f.readline()
        if line.strip() == "null":
            return None
        S = set()
        while not line.startswith('END'):
            tokens = line.strip().split()
            if parse_ids:
                u, v, weight = int(tokens[0]), int(tokens[1]), tokens[2]
            else:
                u, v, weight = tokens[0], tokens[1], tokens[2]
            assert(u == v)
            S.add(u)
            line = f.readline()
        return S
