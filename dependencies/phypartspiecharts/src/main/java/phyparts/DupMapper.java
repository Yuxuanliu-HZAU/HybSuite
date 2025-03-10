package phyparts;

import jade.tree.JadeNode;
import jade.tree.JadeTree;
import jade.tree.NodeOrder;
import jade.tree.Tree;
import jade.tree.TreeNode;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import org.opentree.bitarray.CompactLongSet;

public class DupMapper {

    Map<Tree, Collection<CompactLongSet>> dups_by_tree;
    JadeTree mapTree;
    Map<TreeNode, TLongBipartition> mapBiparts;
    HashMap<Tree, String> tfilename;

    public DupMapper(Map<Tree, Collection<CompactLongSet>> dups, JadeTree mTree,
            HashMap<TreeNode, TLongBipartition> mapBiparts, HashMap<Tree, String> tfilename) {
        this.dups_by_tree = dups;
        this.mapTree = mTree;
        this.mapBiparts = mapBiparts;
        this.tfilename = tfilename;
    }

    public void mapDuplications(boolean verbose, String outprepend) {
        HashMap<TreeNode, Integer> node_counts = new HashMap<TreeNode, Integer>();
        HashMap<TreeNode, HashSet<String>> gene_names = new HashMap<TreeNode, HashSet<String>>();
        for (Tree t : dups_by_tree.keySet()) {
            for (CompactLongSet cls : dups_by_tree.get(t)) {
                boolean match = false;
                TreeNode shallowest = null;
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    if (mapBiparts.get(tn) == null)
                        continue;
                    if (mapBiparts.get(tn).ingroup().containsAll(cls)) {
                        match = true;
                        shallowest = tn;
                    }
                }
                if (match) {
                    if (node_counts.containsKey(shallowest) == false) {
                        node_counts.put(shallowest, 0);
                        gene_names.put(shallowest, new HashSet<String>());
                    }
                    node_counts.put(shallowest, node_counts.get(shallowest) + 1);
                    gene_names.get(shallowest).add(tfilename.get(t));
                }
            }
        }

        if (verbose) {
            try {
                FileWriter fw = new FileWriter(outprepend + ".node.key");
                int nnum = 0;
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    FileWriter fw2 = new FileWriter(outprepend + ".dupl." + nnum);
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    if (gene_names.containsKey(tn) == false) {
                        nnum += 1;
                        continue;
                    }
                    fw.write(nnum + " " + tn + "\n");
                    for (String name : gene_names.get(tn)) {
                        fw2.write(name + "\n");
                    }
                    fw2.close();
                    nnum += 1;
                }
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        /*
         * print the trees for figure goodness
         */
        try {
            FileWriter fw = new FileWriter(outprepend + ".dupl.tre");
            //first the number of duplications
            for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                if (tn == mapTree.getRoot()) {
                    continue;
                }
                if (node_counts.containsKey(tn) == false) {
                    ((JadeNode) tn).setName(String.valueOf(0));
                } else {
                    ((JadeNode) tn).setName(String.valueOf(node_counts.get(tn)));
                }
            }
            fw.write(mapTree + "\n");
            //now the nmber of gene regions
            for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                if (tn == mapTree.getRoot()) {
                    continue;
                }
                if (node_counts.containsKey(tn) == false) {
                    ((JadeNode) tn).setName(String.valueOf(0));
                } else {
                    ((JadeNode) tn).setName(String.valueOf(gene_names.get(tn).size()));
                }
            }
            fw.write(mapTree + "\n");
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
