package phyparts;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map.Entry;

import jade.tree.NodeOrder;
import jade.tree.Tree;
import jade.tree.TreeBipartition;
import jade.tree.TreeNode;

import org.opentree.bitarray.CompactLongSet;

/*
 * this is intended to take a tree and then deconstruct it
 * into the sets of ingroup and outgroup
 */
public class TreeDeconstructor {

    HashMap<String, Long> name_long_map;
    HashMap<Long, String> long_name_map;
    Collection<TLongBipartition> treeBiparts = new HashSet<TLongBipartition>();

    public TreeDeconstructor(HashMap<String, Long> name_long_map) {
        this.name_long_map = name_long_map;
        long_name_map = new HashMap<Long, String>();
        for (Entry<String, Long> tls : name_long_map.entrySet()) {
            long_name_map.put(tls.getValue(), tls.getKey());
        }
    }

    public void deconstructTree(Tree tree) {
        for (TreeNode node : tree.internalNodes(NodeOrder.PREORDER)) {
            TLongBipartition b = getBipartForTreeNode(node, tree);
            treeBiparts.add(b);
        }
    }

    public HashMap<TreeNode, CompactLongSet> calculateDups(Tree tree, double support, Collection<String> ignore) {
        Collection<CompactLongSet> ingroup_dups = new ArrayList<CompactLongSet>();
        HashMap<TreeNode, CompactLongSet> ingroup_dups_nodes = new HashMap<TreeNode, CompactLongSet>();
        HashMap<TreeNode, CompactLongSet> node_sets = new HashMap<TreeNode, CompactLongSet>();
        for (TreeNode tn : tree.externalNodes()) {
            CompactLongSet ns = new CompactLongSet();
            if (ignore.contains(getReducedLabel((String) tn.getLabel())) == false) {
                ns.add(name_long_map.get(getReducedLabel((String) tn.getLabel())));
            }
            node_sets.put(tn, ns);
        }
        for (TreeNode tn : tree.internalNodes(NodeOrder.POSTORDER)) {
            CompactLongSet ns = new CompactLongSet();
            int lvs = 0;
            for (TreeNode n : tn.getDescendantLeaves()) {
                if (ignore.contains(getReducedLabel((String) n.getLabel())) == false) {
                    ns.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
                    lvs += 1;
                }
            }
            node_sets.put(tn, ns);
            if (lvs <= 2) {
                continue;
            }
            if (support != 0) {
                if (((String) tn.getLabel()).isEmpty() == true) {
                    continue;
                }
                if (Double.valueOf((String) tn.getLabel()) <= support) {
                    continue;
                }
                boolean bspass = true;
                for (TreeNode tn2 : tn.getChildren()) {
                    if (tn2.isExternal()) {
                        continue;
                    }
                    if (((String) tn2.getLabel()).isEmpty() == true) {
                        bspass = false;
                        continue;
                    }
                    if (Double.valueOf((String) tn2.getLabel()) <= support) {
                        bspass = false;
                        continue;
                    }
                }
                if (bspass == false) {
                    continue;
                }
            }
            if (ns.size() > 1) {
                CompactLongSet ts = new CompactLongSet();
                for (TreeNode tn2 : tn.getChildren()) {
                    long tlen = ts.size();
                    if (ts.intersection(node_sets.get(tn2)).size() < 2) {
                        ts.addAll(node_sets.get(tn2));
                        continue;
                    }
                    ts.addAll(node_sets.get(tn2));
                    long nlen = ts.size();
                    if (nlen != tlen + node_sets.get(tn2).size()) {
                        ingroup_dups.add(ts);
                        ingroup_dups_nodes.put(tn, ts);
                        /* for joe: prints more information on the dups
                        if (tn.getParent() != tree.getRoot() && tn.getParent() != null){
                            System.out.println("=="+getStringTreeCompactSet(ts)+" | "+
                                    getStringTreeCompactSet(getBipartForTreeNode(tn.getParent(),tree).ingroup())+
                                    " | "+tree.getRoot().getDescendantLeaves());
                        }else{
                            System.out.println("=="+getStringTreeCompactSet(ts)+" | "+
                                " | "+tree.getRoot().getDescendantLeaves());
                        }*/
                    }
                }
            }
        }

        return ingroup_dups_nodes;
    }

    public Collection<TLongBipartition> deconstructTreeAccountDups(Tree tree, double support, Collection<String> ignore) {
        Collection<TLongBipartition> sptreeBiparts = new ArrayList<TLongBipartition>();
        TreeBipartition root = tree.getBipartition(tree.getRoot());
        CompactLongSet rootcls = new CompactLongSet();
        for (TreeNode n : root.ingroup()) {
            if (ignore.contains(getReducedLabel((String) n.getLabel()))) {
                continue;
            }
            rootcls.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
        }
        for (TreeNode node : tree.internalNodes(NodeOrder.PREORDER)) {
            if (node == tree.getRoot()) {
                continue;
            }
            if (support != 0) {
                if (((String) node.getLabel()).isEmpty() == true) {
                    continue;
                }
                if (Double.valueOf((String) node.getLabel()) <= support) {
                    continue;
                }
            }
            TLongBipartition b = getBipartForTreeNodeAccountDuplicates(node, rootcls, tree, ignore);
            if (b.ingroup().size() < 2) {
                continue;
            }
            treeBiparts.add(b);
            sptreeBiparts.add(b);
        }
        return sptreeBiparts;
    }

    public LinkedList<String> getStringTreeBiparts(Collection<TLongBipartition> sptreeBiparts) {
        LinkedList<String> tbss = new LinkedList<String>();
        for (TLongBipartition tlb : sptreeBiparts) {
            HashSet<String> ings = new HashSet<String>();
            for (Long tl : tlb.ingroup()) {
                ings.add(long_name_map.get(tl));
            }
            HashSet<String> outgs = new HashSet<String>();
            for (Long tl : tlb.outgroup()) {
                outgs.add(long_name_map.get(tl));
            }
            tbss.add(Utils.concatWithCommas(ings) + " " + Utils.concatWithCommas(outgs));
        }
        return tbss;
    }

    public String getStringTreeBipart(TLongBipartition tlb) {
        HashSet<String> ings = new HashSet<String>();
        for (Long tl : tlb.ingroup()) {
            ings.add(long_name_map.get(tl));
        }
        HashSet<String> outgs = new HashSet<String>();
        for (Long tl : tlb.outgroup()) {
            outgs.add(long_name_map.get(tl));
        }
        return Utils.concatWithCommas(ings) + " " + Utils.concatWithCommas(outgs);
    }
    
    public String getStringTreeCompactSet(CompactLongSet tlb) {
        HashSet<String> ings = new HashSet<String>();
        for (Long tl : tlb) {
            ings.add(long_name_map.get(tl));
        }
        return Utils.concatWithCommas(ings);
    }

    /*
     * this is for duplications convert names
     */
    public LinkedList<String> getStringTreeSet(Collection<CompactLongSet> sptreedups) {
        LinkedList<String> tbss = new LinkedList<String>();
        for (CompactLongSet cls : sptreedups) {
            HashSet<String> ings = new HashSet<String>();
            for (Long tl : cls) {
                ings.add(long_name_map.get(tl));
            }
            tbss.add(Utils.concatWithCommas(ings));
        }
        return tbss;
    }

    public TLongBipartition getBipartForTreeNode(TreeNode p, Tree t) {
        CompactLongSet ingroup = new CompactLongSet();
        CompactLongSet outgroup = new CompactLongSet();
        TreeBipartition b = t.getBipartition(p);

        for (TreeNode n : b.ingroup()) {
            if (name_long_map.containsKey(getReducedLabel((String) n.getLabel()))) {
                ingroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
            }
        }
        for (TreeNode n : b.outgroup()) {
            if (name_long_map.containsKey(getReducedLabel((String) n.getLabel()))) {
                outgroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
            }
        }
        if (ingroup.size() == 0 || outgroup.size() == 0) {
            return null;
        }
        return new TLongBipartition(ingroup, outgroup);
    }

    private TLongBipartition getBipartForTreeNodeAccountDuplicates(TreeNode p, CompactLongSet rootcls, Tree t, Collection<String> ignore) {
        CompactLongSet ingroup = new CompactLongSet();
        CompactLongSet outgroup = new CompactLongSet();
        TreeBipartition b = t.getBipartition(p);
        for (TreeNode n : b.ingroup()) {
            if(ignore.size() == 0){
                ingroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
            }else {
                if (ignore.contains(getReducedLabel((String) n.getLabel())) == false) {
                    ingroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
                }
            }
        }
        for (TreeNode n : b.outgroup()) {
            if(ignore.size() == 0){
                outgroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
            }else {
                if (ignore.contains(getReducedLabel((String) n.getLabel())) == false) {
                    outgroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
                }
            }
        }
        /*
         * then there are dups and we need to fix
         */
        if (ingroup.containsAny(outgroup)) {
            CompactLongSet outgroup2 = new CompactLongSet();
            TreeNode parent = p.getParent();
            TreeNode last = p;
            while (parent != null) {
                List<TreeNode> childs = new ArrayList(parent.getChildren());
                childs.remove(last);
                TreeNode othern = childs.get(0);
                CompactLongSet tgroup = new CompactLongSet();
                for (TreeNode n : othern.getDescendantLeaves()) {
                    if (ignore.contains(getReducedLabel((String) n.getLabel())) == false) {
                        tgroup.add(name_long_map.get(getReducedLabel((String) n.getLabel())));
                    }
                }
                if (ingroup.containsAny(tgroup) == false) {
                    for (Long l : tgroup) {
                        outgroup2.add(l);
                    }
                }
                last = parent;
                parent = last.getParent();
            }
            outgroup = outgroup2;
        }

        return new TLongBipartition(ingroup, outgroup);
    }

    /*
     * This will return the reduced label, taking off
     * @number if it is there
     */
    private String getReducedLabel(String lab) {
        String ret = "";
        ret = lab.split("@")[0];
        return ret;
    }

}
