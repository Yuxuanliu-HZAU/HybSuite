#!/usr/bin/env python

helptext= '''
Generate the "Pie Chart" representation of gene tree conflict from Smith et al. 2015 from
the output of phyparts, the bipartition summary software described in the same paper.
The input files include three files produced by PhyParts, and a file containing a species
tree in Newick format (likely, the tree used for PhyParts). The output is an SVG containing
the phylogeny along with pie charts at each node.
Requirements:
Python 3
ete3
matplotlib
'''

import matplotlib,sys,argparse,re,json
from ete3 import Tree, TreeStyle, TextFace,NodeStyle,faces, COLOR_SCHEMES


#Read in species tree and convert to ultrametric

#Match phyparts nodes to ete3 nodes
def get_phyparts_nodes(sptree_fn,phyparts_root):
	sptree = Tree(sptree_fn)
	sptree.convert_to_ultrametric()

	phyparts_node_key = [line for line in open(phyparts_root+".node.key")]
	subtrees_dict = {n.split()[0]:Tree(n.split()[1]+";") for n in phyparts_node_key}
	subtrees_topids = {}
	for x in subtrees_dict:
		subtrees_topids[x] = subtrees_dict[x].get_topology_id()
	#print(subtrees_topids['1'])
	#print()
	for node in sptree.traverse():
		node_topid = node.get_topology_id()
		if "Takakia_4343a" in node.get_leaf_names():
			print(node_topid)
			print(node)
		for subtree in subtrees_dict:
			if node_topid == subtrees_topids[subtree]:
				node.name = subtree
	return sptree,subtrees_dict,subtrees_topids

#Summarize concordance and conflict from Phyparts
def get_concord_and_conflict(phyparts_root,subtrees_dict,subtrees_topids):

	with open(phyparts_root + ".concon.tre") as phyparts_trees:
		concon_tree = Tree(phyparts_trees.readline())
		conflict_tree = Tree(phyparts_trees.readline())

	concord_dict = {}
	conflict_dict = {}


	for node in concon_tree.traverse():
		node_topid = node.get_topology_id()
		for subtree in subtrees_dict:
			if node_topid == subtrees_topids[subtree]:
				concord_dict[subtree] = node.support
	
	for node in conflict_tree.traverse():
		node_topid = node.get_topology_id()
		for subtree in subtrees_dict:
			if node_topid == subtrees_topids[subtree]:
				conflict_dict[subtree] = node.support
	return concord_dict, conflict_dict    
    
#Generate Pie Chart data
def get_pie_chart_data(phyparts_root,total_genes,concord_dict,conflict_dict):

	phyparts_hist = [line for line in open(phyparts_root + ".hist")]
	phyparts_pies = {}
	phyparts_dict = {}

	for n in phyparts_hist:
		n = n.split(",")
		tot_genes = float(n.pop(-1))
		node_name = n.pop(0)[4:]
		concord = float(n.pop(0))
		concord = concord_dict[node_name]
		all_conflict = conflict_dict[node_name]
	
		if len(n) > 0:   
			most_conflict = max([float(x) for x in n])
		else:
			most_conflict = 0.0
	
		adj_concord = (concord/total_genes) * 100 
		adj_most_conflict = (most_conflict/total_genes) * 100
		other_conflict = (all_conflict - most_conflict) / total_genes * 100
		the_rest = (total_genes - concord - all_conflict) / total_genes * 100
	
		pie_list = [adj_concord,adj_most_conflict,other_conflict,the_rest]
		
		phyparts_pies[node_name] = pie_list
	
		phyparts_dict[node_name] = [int(round(concord,0)),int(round(tot_genes-concord,0))]
		
	return phyparts_dict, phyparts_pies    


def node_text_layout(mynode):
	F = faces.TextFace(mynode.name,fsize=20)
	faces.add_face_to_node(F,mynode,0,position="branch-right")

#convert internal phypartspiechart.py data files to csv and export to current directory (for use as ggtree tree data in R)
def pie_data_to_csv(phyparts_dict, phyparts_pies):
	phyparts_dist_bin = {}
	phyparts_pies_bin = {}
	dist_replaced = {}
	pies_replaced = {}

	phyparts_dist_bin = json.dumps(phyparts_dist)
	phyparts_pies_bin = json.dumps(phyparts_pies)


	dist_replaced = re.sub(r'{',r'node,concord,genes-concord\n',phyparts_dist_bin)
	dist_replaced = re.sub(r'"(\d*)":\s\[(\d*),\s(\d*)\],\s', r'\1,\2,\3\n', dist_replaced)
	dist_replaced = re.sub(r'"(\d*)":\s\[(\d*),\s(\d*)\]}', r'\1,\2,\3', dist_replaced)

	pies_replaced = re.sub(r'{',r'node,adj_concord,adj_most_conflict,other_conflict,the_rest\n',phyparts_pies_bin)
	pies_replaced = re.sub(r'"(\d*)":\s\[(\d*.\d*),\s(\d*.\d*),\s(\d*.\d*),\s(\d*.\d*)\],\s', r'\1,\2,\3,\4,\5\n', pies_replaced)
	pies_replaced = re.sub(r'"(\d*)":\s\[(\d*.\d*),\s(\d*.\d*),\s(\d*.\d*),\s(\d*.\d*)\]}', r'\1,\2,\3,\4,\5', pies_replaced)

	with open('phyparts_dist.csv','w') as file:
		for line in dist_replaced:
			file.write(line)
	with open('phyparts_pies.csv','w') as file:
		for line in pies_replaced:
			file.write(line)


parser = argparse.ArgumentParser(description=helptext,formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('species_tree',help="Newick formatted species tree topology.")
parser.add_argument('phyparts_root',help="File root name used for Phyparts.")
parser.add_argument('num_genes',type=int,default=0,help="Number of total gene trees. Used to properly scale pie charts.")
parser.add_argument('--taxon_subst',help="Comma-delimted file to translate tip names.")
parser.add_argument("--svg_name",help="File name for SVG generated by script",default="pies.svg")
parser.add_argument("--show_nodes",help="Also show tree with nodes labeled same as PhyParts",action="store_true",default=False)
parser.add_argument("--colors",help="Four colors of the pie chart: concordance (blue) top conflict (green), other conflict (red), no signal (gray)",nargs="+",default=["blue","green","red","dark gray"])	
parser.add_argument("--no_ladderize",help="Do not ladderize the input species tree.",action="store_true",default=False)
parser.add_argument("--to_csv",help="Output data files to csv for import into ggtree in R",action="store_true",default=False)

args = parser.parse_args()
if args.no_ladderize:
    ladderize=False
else:
    ladderize=True
plot_tree,subtrees_dict,subtrees_topids = get_phyparts_nodes(args.species_tree, args.phyparts_root)
#print(subtrees_dict)
concord_dict, conflict_dict = get_concord_and_conflict(args.phyparts_root,subtrees_dict,subtrees_topids)
phyparts_dist, phyparts_pies = get_pie_chart_data(args.phyparts_root,args.num_genes,concord_dict,conflict_dict)

if args.taxon_subst:
	taxon_subst = {line.split(",")[0]:line.split(",")[1] for line in open(args.taxon_subst,'U')}
	for leaf in plot_tree.get_leaves():
		try:
			leaf.name = taxon_subst[leaf.name]
		except KeyError:
			print(leaf.name)
			continue
def phyparts_pie_layout(mynode):
    if mynode.name in phyparts_pies:
        pie= faces.PieChartFace(phyparts_pies[mynode.name],
                              #colors=COLOR_SCHEMES["set1"],
                              colors = args.colors,
                              width=50, height=50)
        pie.border.width = None
        pie.opacity = 1
        faces.add_face_to_node(pie,mynode, 0, position="branch-right")
        
        concord_text = faces.TextFace(str(int(concord_dict[mynode.name]))+'   ',fsize=20)
        conflict_text = faces.TextFace(str(int(conflict_dict[mynode.name]))+'   ',fsize=20)
        
        faces.add_face_to_node(concord_text,mynode,0,position = "branch-top")
        faces.add_face_to_node(conflict_text,mynode,0,position="branch-bottom")
        
        
    else:
        F = faces.TextFace(mynode.name,fsize=20)
        faces.add_face_to_node(F,mynode,0,position="aligned")

#Plot Pie Chart	
ts = TreeStyle()
ts.show_leaf_name = False

ts.layout_fn = phyparts_pie_layout
nstyle = NodeStyle()
nstyle["size"] = 0
for n in plot_tree.traverse():
	n.set_style(nstyle)
	n.img_style["vt_line_width"] = 0

ts.draw_guiding_lines = True
ts.guiding_lines_color = "black"
ts.guiding_lines_type = 0
ts.scale = 30
ts.branch_vertical_margin = 10
plot_tree.convert_to_ultrametric()
if args.to_csv:
    pie_data_to_csv(phyparts_dist, phyparts_pies)

if ladderize:
    plot_tree.ladderize(direction=1)    
my_svg = plot_tree.render(args.svg_name,tree_style=ts,w=595,dpi=300)

if args.show_nodes:
	node_style = TreeStyle()
	node_style.show_leaf_name=False
	node_style.layout_fn = node_text_layout
	plot_tree.render("tree_nodes.pdf",tree_style=node_style)

     
    

