package phyparts;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import jade.tree.JadeTree;
import jade.tree.JadeNode;
import jade.tree.NodeOrder;
import jade.tree.Tree;
import jade.tree.TreeNode;
import jade.tree.TreeParseException;
import jade.tree.TreeReader;

import org.apache.commons.cli.*;
import org.opentree.bitarray.CompactLongSet;

public class CmdLineInt {

    private Options options = new Options();
    private String[] args = null;

    public void parse() {
        CommandLineParser parser = new BasicParser();
        CommandLine cmd = null;
        try {
            cmd = parser.parse(options, args);
            double support = 0;
            boolean verbose = false;
            Collection<String> ignore = new HashSet<String>();
            String mapTreeFile = null;
            String outprepend = "out";
            if (cmd.hasOption("help") || cmd.getOptions().length == 0) {
                help();
            }
            if (cmd.hasOption("x")) {
                secret(cmd.getOptionValue("secret"));
                return;
            }
            if (cmd.hasOption("d") == false) {
                System.out.println("you have to have some directory or file (-d)");
                return;
            }
            if (cmd.hasOption("v") == true) {
                System.out.println("VERBOSE mode");
                verbose = true;
            }
            if (cmd.hasOption("a") == false && cmd.hasOption("y") == false) {
                System.out.println("you have to have some analysis (-a)");
                return;
            }
            if (cmd.hasOption("s") == true) {
                support = Double.valueOf(cmd.getOptionValue("support"));
            }
            if (cmd.hasOption("o") == true) {
                outprepend = cmd.getOptionValue("outpr");
            }
            if (cmd.hasOption("i") == true) {
                for (String st : cmd.getOptionValue("ignore").split(",")) {
                    ignore.add(st);
                }
                System.err.println("Ignoring:" + ignore);
            }
            if (cmd.hasOption("m")) {
                mapTreeFile = cmd.getOptionValue("mtree");
                System.err.println("Mapping tree:" + mapTreeFile);
            }
            String fileORdir = cmd.getOptionValue("dtree");
            if (cmd.getOptionValue("analysis").equals("0")) {
                decon(fileORdir, support, ignore, mapTreeFile, false, verbose, outprepend);
            } else if (cmd.getOptionValue("analysis").equals("1")) {
                decon(fileORdir, support, ignore, mapTreeFile, true, verbose, outprepend);
            } else if (cmd.getOptionValue("analysis").equals("2")) {
                dupl(fileORdir, support, ignore, mapTreeFile, verbose, outprepend);
            }
        } catch (ParseException e) {

        }
    }

    private void secret(String filename) {
        try {
            BufferedReader br = new BufferedReader(new FileReader(filename));
            String treeString = "";
            Tree t = null;
            while ((treeString = br.readLine()) != null) {
                t = TreeReader.readTree(treeString);
                for (TreeNode tn : t.externalNodes()) {
                    ((JadeNode) tn).setName(tn.getLabel().toString().split("_ott")[1]);//tn.getLabel();
                }
            }
            br.close();
            System.out.println(t + ";");
        } catch (Exception e) {

        }
    }

    public CmdLineInt(String[] args) {
        this.args = args;
        options.addOption("a", "analysis", true, "what kind of analysis (0 - concon, 1 - fullconcon, 2 - duplications)");
        options.addOption("m", "mtree", true, "mapping tree (for mapping)");
        options.addOption("d", "dtree", true, "directory of trees (for deconstruct)");
        options.addOption("s", "support", true, "support cutoff (only keep things with greater support than the one specified)");
        options.addOption("i", "ignore", true, "comma separated list of things to ignore");
        options.addOption("v", "verbose", false, "include verbose output");
        options.addOption("o", "outpr", true, "prepend output files with this");
        options.addOption("x", "secret", true, " ");
        options.addOption("y", "secret2", false, " ");
        options.addOption("h", "help", false, "show help");
    }

    private void help() {
        HelpFormatter formater = new HelpFormatter();
        formater.printHelp("phyparts", options);
        System.exit(0);
    }

    private void dupl(String fileORdir, double support, Collection<String> ignore, String mapTreeFile, boolean verbose, String outprepend) {
        File file = new File(fileORdir);
        ArrayList<String> filenames = new ArrayList<String>();
        if (file.isFile()) {
            filenames.add(fileORdir);
        } else {
            for (File infl : file.listFiles()) {
                // skip files that have a leading .
                if (infl.getName().charAt(0) == '.')
                    continue;
                filenames.add(infl.getPath());
            }
        }
        BufferedReader br;
        try {
            List<Tree> lt = new ArrayList<Tree>();
            HashMap<Tree, String> tfilename = new HashMap<Tree, String>();
            Set<String> nms = new HashSet<String>();
            String treeString = "";
            for (String infl : filenames) {
                br = new BufferedReader(new FileReader(infl));
                while ((treeString = br.readLine()) != null) {
                    Tree t = TreeReader.readTree(treeString);
                    lt.add(t);
                    for (TreeNode tn : t.externalNodes()) {
                        nms.add(((String) tn.getLabel()).split("@")[0]);
                    }
                    tfilename.put(t, infl);
                }
                br.close();
            }
            System.err.println("Read " + lt.size() + " trees");
            HashMap<String, Long> name_long_map = new HashMap<String, Long>();
            Long ct = 0L;
            for (String nm : nms) {
                name_long_map.put(nm, ct);
                ct += 1L;
            }
            TreeDeconstructor td = new TreeDeconstructor(name_long_map);
            Map<Tree, Collection<CompactLongSet>> dups_by_tree = new HashMap<Tree, Collection<CompactLongSet>>();
            int totdup = 0;
            int gtotdup = 0;
            for (Tree t : lt) {
                HashMap<TreeNode, CompactLongSet> dups = td.calculateDups(t, support, ignore);
                dups_by_tree.put(t, dups.values());
                if (dups.size() > 0) {
                    gtotdup += 1;
                }
                totdup += dups.size();
                /*for(String d: td.getStringTreeSet(dups.values())){
                 System.out.println(tfilename.get(t)+" "+d);
                }*/
            }
            double avgdup = totdup / Double.valueOf(lt.size());
            System.err.println("Finished calculating duplicates");
            System.err.println("Total number of duplications: " + totdup);
            System.err.println("Total number of gene trees with duplications: " + gtotdup);
            System.err.println("Average number of duplications/tree: " + avgdup);

            /*
             * if maptreefile is there then we are going to summarize as well
             */
            if (mapTreeFile != null) {
                JadeTree maptree = null;
                br = new BufferedReader(new FileReader(mapTreeFile));
                while ((treeString = br.readLine()) != null) {
                    maptree = (JadeTree) TreeReader.readTree(treeString);
                }
                br.close();
                //System.out.println(maptree);
                HashMap<TreeNode, TLongBipartition> mtbiparts = new HashMap<TreeNode, TLongBipartition>();
                for (TreeNode tn : maptree.internalNodes(NodeOrder.PREORDER)) {
                    mtbiparts.put(tn, td.getBipartForTreeNode(tn, maptree));
                }
                DupMapper ccm = new DupMapper(dups_by_tree, maptree, mtbiparts, tfilename);
                ccm.mapDuplications(verbose, outprepend);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private void decon(String fileORdir, double support, Collection<String> ignore, String mapTreeFile, boolean fullAnalysis,
            boolean verbose, String outprepend) {
        File file = new File(fileORdir);
        ArrayList<String> filenames = new ArrayList<String>();
        if (file.isFile()) {
            filenames.add(fileORdir);
        } else {
            for (File infl : file.listFiles()) {
                filenames.add(infl.getPath());
            }
        }
        BufferedReader br;
        try {
            List<Tree> lt = new ArrayList<Tree>();
            HashMap<Tree, String> tfilename = new HashMap<Tree, String>();
            Set<String> nms = new HashSet<String>();
            String treeString = "";
            for (String infl : filenames) {
                br = new BufferedReader(new FileReader(infl));
                while ((treeString = br.readLine()) != null) {
                    if (treeString.length() < 2)
                        continue;
                    try{
                        Tree t = TreeReader.readTree(treeString);
                        lt.add(t);
                        for (TreeNode tn : t.externalNodes()) {
                            nms.add(((String) tn.getLabel()).split("@")[0]);
                        }
                        tfilename.put(t, infl);
                    }catch(TreeParseException e){
                        System.out.println("I don't think "+infl+" has any trees. Skipping");
                        continue;
                    }
                }
                br.close();
            }
            System.err.println("Read " + lt.size() + " trees");
            HashMap<String, Long> name_long_map = new HashMap<String, Long>();
            Long ct = 0L;
            for (String nm : nms) {
                name_long_map.put(nm, ct);
                ct += 1L;
            }
            TreeDeconstructor td = new TreeDeconstructor(name_long_map);
            System.err.println("Finished initializing deconstructor");
            Map<Tree, Collection<TLongBipartition>> biparts_by_tree = new HashMap<Tree, Collection<TLongBipartition>>();
            int totbip = 0;
            double avgbip = 0.;
            for (Tree t : lt) {
                Collection<TLongBipartition> col = td.deconstructTreeAccountDups(t, support, ignore);
                biparts_by_tree.put(t, col);
                /*for(String ts: td.getStringTreeBiparts(col)){
                 //System.out.println(tfilename.get(t)+" "+ts);
                 System.out.println(ts);
                 }*/
                totbip += col.size();
            }
            avgbip += totbip / Double.valueOf(lt.size());

            System.err.println("Finished calculating clades");
            System.err.println("Total number of clades: " + totbip);
            System.err.println("Average number of clades/tree: " + avgbip);
            /*
             * if maptreefile is there then we are going to summarize as well
             */
            if (mapTreeFile != null) {
                JadeTree maptree = null;
                br = new BufferedReader(new FileReader(mapTreeFile));
                while ((treeString = br.readLine()) != null) {
                    maptree = (JadeTree) TreeReader.readTree(treeString);
                }
                br.close();
                //System.out.println(maptree);
                HashMap<TreeNode, TLongBipartition> mtbiparts = new HashMap<TreeNode, TLongBipartition>();
                for (TreeNode tn : maptree.internalNodes(NodeOrder.PREORDER)) {
                    if (tn == maptree.getRoot()) {
                        continue;
                    }
                    mtbiparts.put(tn, td.getBipartForTreeNode(tn, maptree));
                }
                //ConConMapper ccm = new ConConMapper(biparts_by_tree, maptree, mtbiparts, td, tfilename);
                CladeMapper ccm = new CladeMapper(biparts_by_tree, maptree, mtbiparts, td, tfilename);
                ccm.mapConcordanceConflict(fullAnalysis, verbose, outprepend);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
