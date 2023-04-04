import sys
from greedy_t import greedy_t
from apdm import APDM_Reader
from math import radians, cos, sin, asin, sqrt
import os
import networkx as nx
import time


def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    r = 6371 # Radius of earth in kilometers. Use 3956 for miles
    return c * r


def run_traffic():
    graphfile = '../data/traffic/event_tree_graph.uel'
    apdm_dir = '../data/traffic/traffic-eventTree-APDM/'
    gmlfile = '../data/traffic/d07_2014_04_29.gml' # for node coordinates
    gml = nx.read_gml(gmlfile)
    assert(33 in gml)
    files =sorted(os.listdir(apdm_dir))
    G = nx.Graph()
    lbda = 0.075
    reader = APDM_Reader()

    # load traffic graph
    print "Loading graph"
    with open(graphfile) as f:
        for line in f:
            tokens = line.split()
            u, v = int(tokens[0]), int(tokens[1])
            weight = float(tokens[2])
            path = [int(i) for i in tokens[3:]]
            G.add_edge(u, v, weight=weight, path=path)
    print "done"

    # process files
    print "Processing files"
    for fname in files:
        H, S = reader.read(os.path.join(apdm_dir, fname))
        for node, data in H.nodes_iter(data=True):
            G.node[node]['weight'] = data['weight']
        start = time.time()
        S = greedy_t(G, lbda)
        # recover full solution
        S_star = set()
        score = sum(lbda * data['weight'] for u, data in G.nodes_iter(data=True))
        print "Total weight is", score
        seen = set()
        for u, v in S.edges_iter():
            path = G[u][v]['path']
            for i in xrange(len(path) - 1):
                x, y = path[i], path[i + 1]
                edge = (x, y) if x < y else (y, x)
                if edge not in S_star:
                    S_star.add(edge)
                    lat_x, lon_x = gml.node[x]['lat'], gml.node[x]['lon']
                    lat_y, lon_y = gml.node[y]['lat'], gml.node[y]['lon']
                    #edge_weight = haversine(lon_x, lat_x, lon_y, lat_y)
                    edge_weight = G[x][y]['weight']
                    score += edge_weight 
                    if x not in seen:
                        seen.add(x)
                        score -= lbda * G.node[x]['weight']
                    if y not in seen:
                        seen.add(y)
                        score -= lbda * G.node[y]['weight']
        end = time.time()
        print "%s,%s,%s" % (fname, score, end - start)
        print "Pred set: %s" % list(S_star)


if __name__ == "__main__":
    run_traffic()
