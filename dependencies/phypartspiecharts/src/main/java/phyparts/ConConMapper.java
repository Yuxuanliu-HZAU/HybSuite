package phyparts;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Collection;

import jade.tree.JadeNode;
import jade.tree.JadeTree;
import jade.tree.NodeOrder;
import jade.tree.Tree;
import jade.tree.TreeNode;

import org.opentree.bitarray.CompactLongSet;


/*
 * this is a conflict and concordance mapper
 */
public class ConConMapper {

    JadeTree mapTree;
    Map<Tree, Collection<TLongBipartition>> biparts_by_tree;
    Map<TLongBipartition,Map<Tree,Collection<TLongBipartition>>> biparts_mapped_to_tree_biparts;
    Map<TreeNode, TLongBipartition> mapBiparts;
    TreeDeconstructor td;
    HashMap<Tree, String> tfilename;

    public ConConMapper(Map<Tree, Collection<TLongBipartition>> biparts, JadeTree mTree,
            HashMap<TreeNode, TLongBipartition> mapBiparts, TreeDeconstructor td, HashMap<Tree, String> tfilename) {
        this.biparts_by_tree = biparts;
        this.mapTree = mTree;
        this.mapBiparts = mapBiparts;
        this.td = td;
        this.tfilename = tfilename;
    }

    public void mapConcordanceConflict(boolean fullAnalysis, boolean verbose, String outprepend) {
        Map<TreeNode, HashSet<Tree>> concordanttrees = new HashMap<TreeNode, HashSet<Tree>>();
        Map<TreeNode, HashSet<Tree>> concordanttrees_ica = new HashMap<TreeNode, HashSet<Tree>>();
        Map<TreeNode, HashSet<Tree>> concordanttrees_perm = new HashMap<TreeNode, HashSet<Tree>>();
        Map<TreeNode, Double> icanodes = new HashMap<TreeNode, Double>();
        Map<TreeNode, HashMap<Tree, HashSet<TLongBipartition>>> conflicttrees = new HashMap<TreeNode, HashMap<Tree, HashSet<TLongBipartition>>>();
        int count = 0;
        /*
         * get concordance and conflict per map node
         */
        for (Tree tr : biparts_by_tree.keySet()) {
            System.err.println("tree:" + (count + 1) + " / " + biparts_by_tree.size());
            for (TLongBipartition tlb : biparts_by_tree.get(tr)) {
                //System.out.println(tlb);
                boolean match = false;
                TreeNode shallowest = null;
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    //System.out.println(" testing: "+tn+" "+mapBiparts.get(tn));
                    if (mapBiparts.get(tn) == null) {
                        continue;
                    }
                    if (mapBiparts.get(tn).containsAll(tlb)) {
                        match = true;
                        //System.out.println(" match "+tn+" "+mapBiparts.get(tn));
                        //we keep going to get the MRCA
                        shallowest = tn;
                    }
                    if (tlb.conflictsWith(mapBiparts.get(tn))) {
                        if (conflicttrees.containsKey(tn) == false) {
                            conflicttrees.put(tn, new HashMap<Tree, HashSet<TLongBipartition>>());
                        }
                        if (conflicttrees.get(tn).containsKey(tr) == false) {
                            conflicttrees.get(tn).put(tr, new HashSet<TLongBipartition>());
                        }
                        conflicttrees.get(tn).get(tr).add(tlb);
                    } else if (tlb.isCompatibleWith(mapBiparts.get(tn))) {
                        if (match == true) {
                            if (concordanttrees_ica.containsKey(shallowest) == false) {
                                concordanttrees_ica.put(shallowest, new HashSet<Tree>());
                            }
                            concordanttrees_ica.get(shallowest).add(tr);
                        }
                    }
                }
                if (match == true) {
                    if (concordanttrees.containsKey(shallowest) == false) {
                        concordanttrees.put(shallowest, new HashSet<Tree>());
                    }
                    concordanttrees.get(shallowest).add(tr);
                }
            }
            count += 1;
        }
        /*
         * get conflict sets 
         */
        int nnum = 0;
        if (fullAnalysis == true) {
            try {
                FileWriter ffw = new FileWriter(outprepend + ".hist");
                FileWriter ffwalts = new FileWriter(outprepend + ".hist.alts");

                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    HashMap<TLongBipartition, HashSet<Tree>> tlb_counts = new HashMap<TLongBipartition, HashSet<Tree>>();
                    HashMap<TLongBipartition, HashSet<TLongBipartition>> tlb_bipartss
                            = new HashMap<TLongBipartition, HashSet<TLongBipartition>>();
                    HashMap<TLongBipartition, CompactLongSet> totalSampling = new HashMap<TLongBipartition, CompactLongSet>();
                    HashSet<TLongBipartition> containedWithin = new HashSet<TLongBipartition>();
                    if (conflicttrees.containsKey(tn) == false) {
                        ffw.write("Node" + nnum + ",0\n");
                        icanodes.put(tn, 1.);
                        nnum += 1;
                        continue;
                    }
                    for (Tree tr : conflicttrees.get(tn).keySet()) {
                        for (TLongBipartition tlb : conflicttrees.get(tn).get(tr)) {
                            CompactLongSet tlbri;
                            if (totalSampling.containsKey(tlb) == false) {
                                tlbri = new CompactLongSet(tlb.ingroup());
                                tlbri.addAll(tlb.outgroup());
                                totalSampling.put(tlb, tlbri);
                            } else {
                                tlbri = totalSampling.get(tlb);
                            }
                            tlb_counts.put(tlb, new HashSet<Tree>());
                            tlb_counts.get(tlb).add(tr);
                            //tlb_bipartss.put(tlb,new HashSet<TLongBipartition>());
                            //tlb_bipartss.get(tlb).add(tlb);
                            for (Tree tr2 : conflicttrees.get(tn).keySet()) {
                                boolean match = false;
                                if (tr == tr2) {
                                    continue;
                                }
                                for (TLongBipartition tlb2 : conflicttrees.get(tn).get(tr2)) {
                                    CompactLongSet tlbro;
                                    if (totalSampling.containsKey(tlb2) == false) {
                                        tlbro = new CompactLongSet(tlb2.ingroup());
                                        tlbro.addAll(tlb2.outgroup());
                                        totalSampling.put(tlb2, tlbro);
                                    } else {
                                        tlbro = totalSampling.get(tlb2);
                                    }
                                    CompactLongSet tlbrint = tlbri.intersection(tlbro);
                                    TLongBipartition retlb = new TLongBipartition(tlb.ingroup().intersection(tlbrint), tlb.outgroup().intersection(tlbrint));
                                    TLongBipartition retlb2 = new TLongBipartition(tlb2.ingroup().intersection(tlbrint), tlb2.outgroup().intersection(tlbrint));
                                    if (retlb.ingroup().size() < 2) {
                                        continue;
                                    }
                                    if (retlb2.ingroup().size() < 2) {
                                        continue;
                                    }
                                    if (retlb.containsAll((retlb2))) {
                                        match = true;
                                        tlb_counts.get(tlb).add(tr2);
                                        //tlb_bipartss.get(tlb).add(tlb2);
                                        //System.out.println(tlb+" "+tlb2);
                                        if (tlb.equals(tlb2) == false && tlb.containsAll(tlb2)) {
                                            containedWithin.add(tlb2);
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (concordanttrees_ica.containsKey(tn)) {
                        //System.out.println(tn + " " + concordanttrees_ica.get(tn).size() + " " + conflicttrees.get(tn).size());
                    }
                    //need to combine/remove the results from those that are the same (i.e., subsets)
                    ArrayList<Integer> ints = new ArrayList<Integer>();
                    ArrayList<Integer> augints = new ArrayList<Integer>();
                    HashMap<TLongBipartition,HashSet<Tree>> augtlb_counts = new HashMap<TLongBipartition,HashSet<Tree>>();
                    tlb_counts.keySet().removeAll(containedWithin);
                    //TODO: make this more efficient
                    //adding permiscuous to conflicting sets
                    //map permiscuous to the conflict set
                    //TODO: make this a boolean
                    for (TLongBipartition al : tlb_counts.keySet()) {
                        augtlb_counts.put(al, new HashSet<Tree>());
                        for (Tree ttr : biparts_by_tree.keySet()) {
                            if (tlb_counts.get(al).contains(ttr)) {
                                continue;
                            }
                            for (TLongBipartition ttlb : biparts_by_tree.get(ttr)) {
                                if (ttlb.isCompatibleWith(al) == true && ttlb.ingroup().intersection(al.ingroup()).size() > 1) {
                                    augtlb_counts.get(al).add(ttr);
                                    break;
                                }
                            }
                        }
                    }
                    
                    //this gets the nested partitions within the conflicts to be added together
                    boolean going = true;
                    while (going) {
                        going = false;
                        TLongBipartition add = null;
                        TLongBipartition to = null;
                        TLongBipartition andnew = null;
                        ArrayList<TLongBipartition> tlba = new ArrayList<TLongBipartition>(tlb_counts.keySet());
                        for (int x =0; x< tlba.size();x++) {
                            for (int y=0;y<tlba.size();y++) {
                                if (y <= x) {
                                    continue;
                                }
                                TLongBipartition al = tlba.get(x);
                                TLongBipartition al2 = tlba.get(y);
                                TLongBipartition ss = al.sum(al2);
                                if (ss != null) {
                                    add = al;
                                    to = al2;
                                    andnew = ss;
                                    going = true;
                                }
                                if (going == true) {
                                    break;
                                }
                            }
                            if (going == true) {
                                break;
                            }
                        }
                        if (going == true) {
                            tlb_counts.put(andnew, tlb_counts.get(to));
                            tlb_counts.get(andnew).addAll(tlb_counts.get(add));
                            tlb_counts.remove(add);
                            tlb_counts.remove(to);
                            augtlb_counts.put(andnew, augtlb_counts.get(to));
                            augtlb_counts.get(andnew).addAll(augtlb_counts.get(add));
                            augtlb_counts.remove(add);
                            augtlb_counts.remove(to);
                        }
                    }
                    // goal is to add those that are concordant with the species tree to those that are 
                    // in conflict to the aug set for ica calculation
                    //add permisuous option
                    for (TLongBipartition al : tlb_counts.keySet()) {
                        ints.add(tlb_counts.get(al).size());
                        HashSet<Tree> nw = new HashSet<Tree>(tlb_counts.get(al));
                        nw.addAll(augtlb_counts.get(al));
                        //System.out.println("== "+al+" "+tlb_counts.get(al)+" , "+augtlb_counts.get(al));
                        augints.add(nw.size());
                    }
                    Collections.sort(ints);
                    Collections.reverse(ints);
                    Collections.sort(augints);
                    Collections.reverse(augints);
                    //calculate ,modified ica
                    // this uses the permiscuous mapping of the nodes
                    ArrayList<Integer> sup_ints = new ArrayList<Integer>();
                    if (concordanttrees_ica.containsKey(tn)) {
                        sup_ints.add(concordanttrees_ica.get(tn).size());
                        //sup_ints.addAll(ints);
                        sup_ints.addAll(augints);
                        //System.out.println(" "+sup_ints);
                        icanodes.put(tn, Utils.calculateICA(sup_ints));
                    } else {
                        sup_ints.add(0);
                        if (conflicttrees.get(tn).size() > 0) {
                            if(augints.size()>1){
                                sup_ints.addAll(augints);
                                icanodes.put(tn, -1*Math.abs(Utils.calculateICA(sup_ints)));
                            }else{
                                icanodes.put(tn,-1.);
                            }
                        } else {
                            icanodes.put(tn, 0.);//this boundary condition needs to be checked for more than test2
                        }
                    }

                    ffw.write("Node" + nnum);
                    if (ints.size() > 0) {
                        ffw.write(",");
                        for (int i = 0; i < ints.size(); i++) {
                            ffw.write(String.valueOf(ints.get(i)));
                            if (i < ints.size() - 1) {
                                ffw.write(",");
                            }
                        }
                        int cor = 0;
                        if (concordanttrees.containsKey(tn) == true) {
                            cor = concordanttrees.get(tn).size();
                        }
                        int con = 0;
                        if (conflicttrees.containsKey(tn) == true) {
                            con = conflicttrees.get(tn).size();
                        }
                        ffw.write("," + (cor + con));
                    }
                    ffw.write("\n");
                    for (TLongBipartition al : tlb_counts.keySet()) {
                        if (tlb_counts.get(al).size() == ints.get(0)) {
                            //ffwalts.write("reg:"+td.getStringTreeBipart(mapBiparts.get(tn))+"\n");
                            ffwalts.write("alt for " + nnum + " (" + tlb_counts.get(al).size() + "):" + td.getStringTreeBipart(al) + "\n");
                            break;
                        }
                    }
                    nnum += 1;
                }
                ffw.close();
                ffwalts.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        /*
         * write out the tree information and the conflict and concordance
         */
        try {
            FileWriter fw = new FileWriter(outprepend + ".node.key");
            nnum = 0;
            for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                if (tn == mapTree.getRoot()) {
                    continue;
                }
                fw.write(nnum + " " + tn + "\n");
                nnum += 1;
            }
            fw.close();
            /*
             * print the trees for figure goodness
             */
            fw = new FileWriter(outprepend + ".concon.tre");
            for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                if (tn == mapTree.getRoot()) {
                    continue;
                }
                if (concordanttrees.containsKey(tn) == false) {
                    ((JadeNode) tn).setName(String.valueOf(0));
                } else {
                    ((JadeNode) tn).setName(String.valueOf(concordanttrees.get(tn).size()));
                }
            }
            fw.write(mapTree + "\n");
            for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                if (tn == mapTree.getRoot()) {
                    continue;
                }
                if (conflicttrees.containsKey(tn) == false) {
                    ((JadeNode) tn).setName(String.valueOf(0));
                } else {
                    ((JadeNode) tn).setName(String.valueOf(conflicttrees.get(tn).size()));
                }
            }
            fw.write(mapTree + "\n");
            /*
             * if we have a full analysis than we can do the ICA calculation
             */
            if (fullAnalysis) {
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    if (icanodes.containsKey(tn) == false) {
                        ((JadeNode) tn).setName(String.valueOf(0));
                    } else {
                        ((JadeNode) tn).setName(String.valueOf(icanodes.get(tn)));
                    }
                }
                fw.write(mapTree + "\n");
            }
            fw.close();
            /*
             * if verbose then we will make a file for each node and give the genes for that support and conflict
             */
            if (verbose) {
                nnum = 0;
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    if (concordanttrees.containsKey(tn) == true) {
                        fw = new FileWriter(outprepend + ".concord.node." + nnum);
                        for (Tree tr : concordanttrees.get(tn)) {
                            fw.write(tfilename.get(tr) + "\n");
                        }
                        fw.close();
                    }
                    if (conflicttrees.containsKey(tn) == true) {
                        fw = new FileWriter(outprepend + ".conflict.node." + nnum);
                        for (Tree tr : conflicttrees.get(tn).keySet()) {
                            fw.write(tfilename.get(tr) + "\n");
                        }
                        fw.close();
                    }
                    nnum += 1;
                }
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
