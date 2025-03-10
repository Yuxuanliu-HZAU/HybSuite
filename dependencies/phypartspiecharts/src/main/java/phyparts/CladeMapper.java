/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phyparts;

import jade.tree.JadeNode;
import jade.tree.JadeTree;
import jade.tree.NodeOrder;
import jade.tree.Tree;
import jade.tree.TreeNode;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import org.opentree.bitarray.CompactLongSet;


/**
 * This differs by taking a bipartition centric instead of tree centric
 * view
 * @author smitty
 */
public class CladeMapper {
    JadeTree mapTree;
    Map<Tree, Collection<TLongBipartition>> biparts_by_tree;
    HashSet<TLongBipartition> all_biparts;
    HashMap<TLongBipartition,HashSet<Tree>> all_biparts_by_tree;
    Map<TreeNode, TLongBipartition> mapBiparts;
    TreeDeconstructor td;
    HashMap<Tree, String> tfilename;

    public CladeMapper(Map<Tree, Collection<TLongBipartition>> biparts, JadeTree mTree,
            HashMap<TreeNode, TLongBipartition> mapBiparts, TreeDeconstructor td, HashMap<Tree, String> tfilename) {
        this.biparts_by_tree = biparts;
        this.mapTree = mTree;
        this.mapBiparts = mapBiparts;
        this.td = td;
        this.tfilename = tfilename;
        all_biparts = new HashSet<TLongBipartition>();
        all_biparts_by_tree = new HashMap<TLongBipartition,HashSet<Tree>>();
        for(Tree tr: biparts_by_tree.keySet()){
            for(TLongBipartition tlb: biparts_by_tree.get(tr)){
                if(all_biparts.contains(tlb)==false){
                    //System.out.println(tlb);
                    all_biparts.add(tlb);
                    all_biparts_by_tree.put(tlb, new HashSet<Tree>());
                }
                all_biparts_by_tree.get(tlb).add(tr);
            }
        }
        for (TLongBipartition tlb : mapBiparts.values()) {
            if (all_biparts.contains(tlb) == false) {
                //System.out.println(tlb);
                all_biparts.add(tlb);
                //all_biparts_by_tree.put(tlb, new HashSet<Tree>());
            }
            //all_biparts_by_tree.get(tlb).add(mapTree);
        }
        
        System.out.println("Total number of unique clades: "+all_biparts.size());
    }

    public void mapConcordanceConflict(boolean fullAnalysis, boolean verbose, String outprepend) {
        Map<TreeNode, HashSet<Tree>> concordanttrees = new HashMap<TreeNode, HashSet<Tree>>();
        Map<TreeNode, HashSet<Tree>> concordanttrees_ica = new HashMap<TreeNode, HashSet<Tree>>();
        Map<TreeNode, Double> icanodes = new HashMap<TreeNode, Double>();
        Map<TreeNode, Double> ica2nodes = new HashMap<TreeNode, Double>();
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

                /**
                 * calculating the ICA things
                 * 
                 */
                HashMap<TLongBipartition, Collection<TLongBipartition>> sub_biparts = 
                        new HashMap<TLongBipartition, Collection<TLongBipartition>>();
                HashMap<TLongBipartition, Collection<TLongBipartition>> super_biparts = 
                        new HashMap<TLongBipartition, Collection<TLongBipartition>>();
                HashMap<TLongBipartition, Collection<TLongBipartition>> equ_biparts = 
                        new HashMap<TLongBipartition, Collection<TLongBipartition>>();
                HashMap<TLongBipartition, Collection<TLongBipartition>> con_biparts = 
                        new HashMap<TLongBipartition, Collection<TLongBipartition>>();
                for(TLongBipartition tlb: all_biparts){
                    for(TLongBipartition tlb2: all_biparts){
                        if(tlb2 == null || tlb == null)
                            continue;
                        //if(tlb.hashCode() == tlb2.hashCode())
                        //    continue;
                        if(tlb.conflictsWith(tlb2)){
                            if(con_biparts.containsKey(tlb)==false)
                                con_biparts.put(tlb, new HashSet<TLongBipartition>());
                            con_biparts.get(tlb).add(tlb2);
                        }else if(tlb2.ingroup().containsAll(tlb.ingroup()) &&
                                tlb2.outgroup().containsAll(tlb.outgroup())){
                            if(sub_biparts.containsKey(tlb)==false)
                                sub_biparts.put(tlb, new HashSet<TLongBipartition>());
                            if(super_biparts.containsKey(tlb2)==false)
                                super_biparts.put(tlb2, new HashSet<TLongBipartition>());
                            sub_biparts.get(tlb).add(tlb2);
                            super_biparts.get(tlb2).add(tlb);
                        }else if(tlb.sum(tlb2)!=null || tlb.equals(tlb2)){
                            if(equ_biparts.containsKey(tlb)==false)
                                equ_biparts.put(tlb, new HashSet<TLongBipartition>());
                            equ_biparts.get(tlb).add(tlb2);
                        }
                    }
                }

                for(TreeNode tn: mapTree.internalNodes(NodeOrder.PREORDER)){
                    if(tn.getParent()==null)
                        continue;
                    TLongBipartition mtlb = mapBiparts.get(tn);
                    //System.out.println(mtlb);
                    ArrayList<Double> icas = new ArrayList<Double> ();
                    ArrayList<Double> icas2 = new ArrayList<Double> ();
                    double support = 0;
                    HashSet<Tree> suptrees = new HashSet<Tree>();
                    HashSet<TLongBipartition> supequ = new HashSet<TLongBipartition>();
                    if(super_biparts.containsKey(mtlb)){
                        supequ.addAll(super_biparts.get(mtlb));
                    }if(equ_biparts.containsKey(mtlb)){
                        supequ.addAll(equ_biparts.get(mtlb));
                    }
                    for (TLongBipartition tlb:supequ){
                        if(all_biparts_by_tree.containsKey(tlb)==false)
                            continue;
                        HashSet<TLongBipartition> tbp = new HashSet<TLongBipartition>(mapBiparts.values());
                        tbp.retainAll(sub_biparts.get(tlb));
                        support += all_biparts_by_tree.get(tlb).size()*1/Double.valueOf(tbp.size());
                        //System.out.println("=="+support+" "+all_biparts_by_tree.get(tlb)+" "+tbp);
                        suptrees.addAll(all_biparts_by_tree.get(tlb));
                    }
                    icas.add(support);
                    icas2.add(Double.valueOf(suptrees.size()));
                    //System.out.println("   sup_trees:"+suptrees);
                    //System.out.println("   support:"+support);
                    HashSet<Tree> contrees = new HashSet<Tree>();
                    HashMap<TLongBipartition, HashSet<Tree>> consets = new HashMap<TLongBipartition, HashSet<Tree>>();
                    if(con_biparts.get(mtlb)!=null){
                        for (TLongBipartition tlb:con_biparts.get(mtlb)){
                            consets.put(tlb, all_biparts_by_tree.get(tlb));
                            contrees.addAll(all_biparts_by_tree.get(tlb));
                        }
                        boolean going = true;
                        while (going) {
                            going = false;
                            TLongBipartition add = null;
                            TLongBipartition to = null;
                            TLongBipartition andnew = null;
                            ArrayList<TLongBipartition> tlba = new ArrayList<TLongBipartition>(consets.keySet());
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
                                HashSet<Tree> tt = new HashSet<Tree>();
                                tt.addAll(consets.get(to));
                                tt.addAll(consets.get(add));
                                consets.remove(to);
                                consets.remove(add);
                                consets.put(andnew, tt);
                            }
                        }
                        for (TLongBipartition tlb:consets.keySet()){
                            icas.add(Double.valueOf(consets.get(tlb).size()));
                            icas2.add(Double.valueOf(consets.get(tlb).size()));
                            //System.out.println("   conflict:"+tlb+" "+consets.get(tlb).size()+" "+consets.get(tlb));
                        }
                    }
                    if(icas.size()>1){
                        double ic = Utils.calculateICAD(icas);
                        //System.out.println("    ICA:"+ic);
                        icanodes.put(tn, ic);
                        double ic2 = Utils.calculateICAD(icas2);
                        //System.out.println("    ICA2:"+ic2);
                        ica2nodes.put(tn, ic2);
                    }else{
                        //System.out.println("    ICA:1.");
                        icanodes.put(tn, 1.);
                        ica2nodes.put(tn, 1.);
                    }
                    ffw.write("Node" + nnum);
                    if (icas.size() > 0) {
                        ffw.write(",");
                        for (int i = 0; i < icas.size(); i++) {
                            ffw.write(String.valueOf(icas.get(i)));
                            if (i < icas.size() - 1) {
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
                    for (TLongBipartition al : consets.keySet()) {
                        ffwalts.write("alt for " + nnum + " (" + consets.get(al).size() + "):" + td.getStringTreeBipart(al) + "\n");
                        //for sidonie
                        String x = "genes : ";
                        for (Tree sidtree : consets.get(al)){
                            x += tfilename.get(sidtree) +" ";
                        }
                        System.err.print("alt for " + nnum + " (" + consets.get(al).size() + "):" + td.getStringTreeBipart(al) + " "+x+"\n");
                        
                    }
                    nnum += 1;
                    
                }
                ffw.close();
                ffwalts.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }/*
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
            fw.write(mapTree + ";\n");
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
            fw.write(mapTree + ";\n");
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
                fw.write(mapTree + ";\n");
                for (TreeNode tn : mapTree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == mapTree.getRoot()) {
                        continue;
                    }
                    if (icanodes.containsKey(tn) == false) {
                        ((JadeNode) tn).setName(String.valueOf(0));
                    } else {
                        ((JadeNode) tn).setName(String.valueOf(ica2nodes.get(tn)));
                    }
                }
                fw.write(mapTree + ";\n");
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
