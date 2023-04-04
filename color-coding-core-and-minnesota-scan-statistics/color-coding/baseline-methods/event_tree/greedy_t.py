import networkx as nx

def greedy_t(G, lda=0.1):
    # initialize the solution to contain the node
    # with highest weight
    solution = nx.Graph()
    heaviest_node = max(G.nodes(), key=lambda x: G.node[x]['weight'])
    solution.add_node(heaviest_node, weight=G.node[heaviest_node]['weight'])
    # objective value of the solution defined above is the total weight of G
    # minus the weight of the heaviest node
    objective_value = sum([data['weight'] for node, data in G.nodes_iter(data=True)
                           if node != heaviest_node])
    nodes_in_solution = set([heaviest_node])
    nodes_not_in_solution = set(G.nodes()) - nodes_in_solution
    # main loop
    # keep going until S has all the nodes or
    # adding a node does not improve the quality
    while len(solution) < len(G):
        # search for node that maximizes gain
        best_gain = 0
        best_node = None
        best_neighbor = None
        best_distance = None
        for node in nodes_not_in_solution:
            # find closest node in the solution
            closest_neighbor_in_solution = min(nodes_in_solution, 
                                               key=lambda x: G[x][node]['weight'])
            distance_to_solution = G[closest_neighbor_in_solution][node]['weight']
            # compute gain of adding this node to the solution
            # and update as necessary
            gain = G.node[node]['weight'] - distance_to_solution
            if gain > best_gain:
                best_node = node
                best_gain = gain
                best_neighbor = closest_neighbor_in_solution
                best_distance = distance_to_solution
        # no further improvement can be done
        if best_gain == 0:
            break
        # add node and update objective value
        nodes_not_in_solution.remove(best_node)
        nodes_in_solution.add(best_node)
        solution.add_node(best_node, attr_dict=G.node[best_node])
        solution.add_node(best_neighbor, attr_dict=G.node[best_neighbor])
        solution.add_edge(best_node, best_neighbor, distance=best_distance)
        objective_value -= best_gain
    return solution
