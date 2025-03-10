package jade.tree;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.Set;

public class JadeTree implements Tree {
	
	private JadeNode root;
	private HashMap<Object, JadeNode> namedNodes;
	private HashMap<String, Object> properties;
	private boolean hasBranchLengths = false;
	
	LinkedHashSet<JadeNode> internalNodes;
	LinkedHashSet<JadeNode> externalNodes;
	
	public JadeTree() {
		root = null;
		properties = new HashMap<String,Object>();
		update();
	}

	public JadeTree(JadeNode root) {
		this.root = root;
		properties = new HashMap<String,Object>();
		update();
	}

	@Override
	public String toString() {
//		TreePrinter t = new TreePrinter();
//		return t.printNH(this);
		return root.getNewick(false);
	}

	/**
	 * Initializes data members based on current root.
	 */
	public void update() {
		namedNodes = new HashMap<Object, JadeNode>();
		internalNodes = new LinkedHashSet<JadeNode>();
		externalNodes = new LinkedHashSet<JadeNode>();
		if (root == null) { return; }
		for (TreeNode node : nodes(NodeOrder.PREORDER)) {
			Object name = node.getLabel();
			//if (node.isExternal() == true && ! (name == null || (name instanceof String && ((String)name).length() < 1)) && namedNodes.containsKey(name)) {
			//	throw new IllegalStateException("duplicate node name: " + name);
			//}
			namedNodes.put(name, (JadeNode) node);
			if (node.isExternal()) {
				externalNodes.add((JadeNode) node);
			} else {
				internalNodes.add((JadeNode) node);
			}
		}
	}
	
	@Override
	public Iterable<TreeBipartition> bipartitions() {
		return new Iterable<TreeBipartition>() {
			public Iterator<TreeBipartition> iterator() {
				return new BipartIterator(JadeTree.this);
			}
		};
	}
	
	/**
	 * @return an iterator over all external nodes
	 */
	public Iterable<TreeNode> externalNodes() {
	    return new Iterable<TreeNode>() {
            public Iterator<TreeNode> iterator() {
            	return new TipIterator(root);
            }
	    };
	}

	/**
     * @return an iterator over all internal nodes
     */
    public Iterable<TreeNode> internalNodes(final NodeOrder order) {
        return new Iterable<TreeNode>() {
            public Iterator<TreeNode> iterator() {
                return new InternalNodeIterator(root, order);
            }
        };
    }
    
	/**
     * @return an iterator over all internal nodes
     */
    public Iterable<TreeNode> nodes(final NodeOrder order) {
        return new Iterable<TreeNode>() {
            public Iterator<TreeNode> iterator() {
                return new NodeIterator(root, order);
            }
        };
    }
    
    @Override
    public int internalNodeCount() {
    	return internalNodes.size();
    }

    @Override
    public int externalNodeCount() {
    	return externalNodes.size();
    }
    
    public int nodeCount() {
    	return externalNodes.size() + internalNodes.size();
    }

    public TreeBipartition getBipartition(TreeNode node) {
    	if (! internalNodes.contains(node) && ! externalNodes.contains(node)) {
    		throw new IllegalArgumentException("that node doesn't seem to be in the tree");
    	}
		Set<TreeNode> outgroup = new HashSet<TreeNode>();
		for (JadeNode t : externalNodes) {
			outgroup.add((TreeNode) t);
		}
		Set<TreeNode> ingroup = new HashSet<TreeNode>();
		for (TreeNode l : node.getDescendantLeaves()) {
			ingroup.add(l);
			outgroup.remove(l);
		}
		return new TreeBipartition(ingroup, outgroup);
    }
    
	public JadeNode getRoot() {return root;}

	public void setRoot(JadeNode root) {this.root = root;}

	/**
	 * Adds a mapping of key->obj for this tree. Unlike the JavaNode version,
	 *	this method does NOT guard against multiple keys being added. Note
	 *	that only the last object associated with a key will be accessible via
	 *	getObject
	 * @param key
	 * @param obj Object to be stored
	 */
	public void setProperty(String key, Object obj) {
		properties.put(key, obj);
	}

	/**
	 * Returns the object associated with the last call of assocObject with this key
	 * @param key
	 */
	public Object getProperty(String key) {
		return properties.get(key);
	}
	
	/**
	 * Just checks if there is an object associated (by the assocObject method) with this key
	 * @param key
	 * @return
	 */
	public boolean hasProperty(String key) {
		return properties.containsKey(key);
	}
	
	/**
	 * Return the HashMap of metadata associated with the tree
	 * @todo need to check
	 * @todo we should probably have a boolean flag to indicate whether or not the tree should be treated as rooted
	 */
	public HashMap<String, Object> getProperties() {
		return properties;
	}
	
	/**
	 * @todo need to check
	 * @todo we should probably have a boolean flag to indicate whether or not the tree should be treated as rooted
	 */
	public void unRoot(JadeNode inRoot) {
		update();
		if (this.getRoot().getChildCount() < 3) {
			tritomyRoot(inRoot);
		}
		update();
	}
	
	/**
	 * Reroots the tree by:
	 *		1. adding a new Node object halfway between `inRoot` and it parent, and
	 *		2. rooting the tree at this new node.
	 * @todo just need to verify that the rerooting treats the branch lengths correctly
	 * @todo should probably be renamed to "addRootBelow(JadeNode inRootChild)"
	 */
	public void reRoot(JadeNode inRoot) {
		update();
		if (this.getRoot().getChildCount() < 3) {
			tritomyRoot(inRoot);
		}
		//System.out.println(inRoot.getBL());
		if (inRoot == this.getRoot()) {
			System.err.println("you asked to root at the current root");
		} else {
			JadeNode tempParent = (JadeNode) inRoot.getParent();
			JadeNode newRoot = new JadeNode(tempParent);
			newRoot.addChild(inRoot);
			inRoot.setParent(newRoot);
			tempParent.removeChild(inRoot);
			tempParent.addChild(newRoot);
			newRoot.setParent(tempParent);
			newRoot.setBL(inRoot.getBL() / 2);
			inRoot.setBL(inRoot.getBL() / 2);
			ProcessReRoot(newRoot);
			setRoot(newRoot);
			update();
		}
	}

	/**
	 * Converts a root with outdegree 2 to a root of outdegree 3 by deleting a child
	 *	of the root. It guards against removing toberoot.
	 *
	 * just need to verify that the rerooting treats the branch lengths correctly
	 * @param toberoot the node that will be the next root of the tree (NOTE: this
	 *		does not make this node the new root, it is just passed in to avoid
	 *		deleting the node that was intended to be the root of the tree).
	 * Assumes that the current root has outdegree 2 (and that it is not a cherry).
	 * @todo the name of the removed node is lost (other code associated with rerooting the tree moves internal node names (see exchangeInfo)
	 */
	private void tritomyRoot(JadeNode toberoot) {
		JadeNode curroot = this.getRoot();
		assert curroot != null;
		assert curroot.getChildCount() == 2;
		
	 	// @todo code duplication could be lessened by using a pair of ints: toBeDeletedIndex, toGetExtraBLIndex set to (0,1) or (1,0)
		if (toberoot == null) {
			if (curroot.getChild(0).isInternal()) {
				JadeNode currootCH = curroot.getChild(0);
				double nbl = currootCH.getBL();
				curroot.getChild(1).setBL(curroot.getChild(1).getBL() + nbl);
				curroot.removeChild(currootCH);
				for (int i = 0; i < currootCH.getChildCount(); i++) {
					curroot.addChild(currootCH.getChild(i));
					//currootCH.getChild(i).setParent(curroot);
				}
			} else {
				JadeNode currootCH = curroot.getChild(1);
				assert currootCH.isInternal();
				double nbl = currootCH.getBL();
				curroot.getChild(0).setBL(curroot.getChild(0).getBL() + nbl);
				curroot.removeChild(currootCH);
				for (int i = 0; i < currootCH.getChildCount(); i++) {
					curroot.addChild(currootCH.getChild(i));
					//currootCH.getChild(i).setParent(curroot);
				}
			}
		} else {
			if (curroot.getChild(1) == toberoot) {
				JadeNode currootCH = curroot.getChild(0);
				assert currootCH.isInternal();
				double nbl = currootCH.getBL();
				curroot.getChild(1).setBL(curroot.getChild(1).getBL() + nbl);
				curroot.removeChild(currootCH);
				for (int i = 0; i < currootCH.getChildCount(); i++) {
					curroot.addChild(currootCH.getChild(i));
					//currootCH.getChild(i).setParent(curroot);
				}
			} else {
				JadeNode currootCH = curroot.getChild(1);
				assert currootCH.isInternal();
				double nbl = currootCH.getBL();
				curroot.getChild(0).setBL(curroot.getChild(0).getBL() + nbl);
				curroot.removeChild(currootCH);
				for (int i = 0; i < currootCH.getChildCount(); i++) {
					curroot.addChild(currootCH.getChild(i));
					//currootCH.getChild(i).setParent(curroot);
				}
			}
		}
	}

	/* NOT USED BY OPENTREE
	 * 
	 * @return the node in the tree that is the most recent common ancestor of all of the leaves specified
	 * @param innodes an array of leaf node names
	 * @todo this could be optimized (by not calling getMRCATraverse repeatedly)
	 *
	public JadeNode getMRCA(String [] innodes) {
		if (innodes.length == 1)
    		return this.getExternalNode(innodes[0]);
		ArrayList <String> outgroup = new ArrayList<String>();
		for (int i = 0;i < innodes.length; i++) {
			outgroup.add(innodes[i]);
		}
		JadeNode cur1 = this.getExternalNode(outgroup.get(0));
		outgroup.remove(0);
		JadeNode cur2 = null;
		JadeNode tempmrca = null;
		while (outgroup.size() > 0) {
			cur2 = this.getExternalNode(outgroup.get(0));
			outgroup.remove(0);
			tempmrca = getMRCATraverse(cur1, cur2);
			cur1 = tempmrca;
		}
		return cur1;
    } */
	
	/* NOT USED BY OPENTREE
	 * 
	 * @return the node in the tree that is the most recent common ancestor of all of the leaves specified
	 * @param innodes an array of leaf node names
	 * @todo this could be optimized (by not calling getMRCATraverse repeatedly)
	 *
	public JadeNode getMRCA(ArrayList<String> innodes) {
    	if (innodes.size() == 1) {
    		return this.getExternalNode(innodes.get(0));
    	}
		ArrayList <String> outgroup = new ArrayList<String>();
		for (int i = 0; i < innodes.size(); i++) {
			outgroup.add(innodes.get(i));
		}
		JadeNode cur1 = this.getExternalNode(outgroup.get(0));
		outgroup.remove(0);
		JadeNode cur2 = null;
		JadeNode tempmrca = null;
		while (outgroup.size() > 0) {
			cur2 = this.getExternalNode(outgroup.get(0));
			outgroup.remove(0);
			tempmrca = getMRCATraverse(cur1,cur2);
			cur1 = tempmrca;
		}
		return cur1;
    } */
	
	/*
     * @return the node in the tree that is the most recent common ancestor of all of the leaves specified
     * @param innodes an array of leaf node names
     * @todo this could be optimized (by not calling getMRCATraverse repeatedly)
     *
    public JadeNode getMRCAAnyDepthDescendants(ArrayList<String> innodes) {
        if (innodes.size() == 1) {
            return this.getNodeById(innodes.get(0));
        }
        ArrayList <String> outgroup = new ArrayList<String>();
        for (int i = 0; i < innodes.size(); i++) {
            outgroup.add(innodes.get(i));
        }
        JadeNode cur1 = this.getExternalNode(outgroup.get(0));

        if (cur1 == null)
            cur1 = this.getInternalNode(outgroup.get(0));
        
        if (cur1 == null)
            throw new java.lang.IllegalStateException("could not find the taxon " + outgroup.get(0));

        outgroup.remove(0);
        JadeNode cur2 = null;
        JadeNode tempmrca = null;

        while (outgroup.size() > 0) {
            cur2 = this.getExternalNode(outgroup.get(0));

            if (cur2 == null)
                cur2 = this.getInternalNode(outgroup.get(0));

            if (cur2 == null)
                throw new java.lang.IllegalStateException("could not find the taxon " + outgroup.get(0));

            outgroup.remove(0);
            tempmrca = getMRCATraverse(cur1,cur2);
            cur1 = tempmrca;
        }
        return cur1;
    } */
	
	/**
	 * Changes the direction of the arc connecting node to it's parent
	 * @todo uses recursion.
	 */
	private void ProcessReRoot(JadeNode node) {
		if (node.isTheRoot() || node.isExternal()) {
			return;
		}
		if (node.getParent() != null) {
			ProcessReRoot((JadeNode) node.getParent());
		}
		// Exchange branch label, length et cetera
		exchangeInfo((JadeNode) node.getParent(), node);
		// Rearrange topology
		JadeNode parent = (JadeNode) node.getParent();
		node.addChild(parent);
		parent.removeChild(node);
		parent.setParent(node);
	}

	/**
	 * Swaps name and branch length of `node1` and `node2`
	 * @todo swapping internal node names implicitly treats a node name as
	 *		a name attached to the edge under a node.
	 */
	private void exchangeInfo(JadeNode node1, JadeNode node2) {
		String swaps;
		double swapd;
		swaps = node1.getName();
		node1.setName(node2.getName());
		node2.setName(swaps);

		swapd = node1.getBL();
		node1.setBL(node2.getBL());
		node2.setBL(swapd);
	}

	/**
	 * prunes `node` from the tree, if `node` is external
	 */
	public void pruneExternalNode(JadeNode node) {
		if (node.isInternal()) {
			return;
		}
		/*
		 * how this works
		 *
		 * get the parent = parent
		 * get the parent of the parent = mparent
		 * remove parent from mparent
		 * add !node from parent to mparent
		 */
		double bl = 0;
		JadeNode parent = (JadeNode) node.getParent();
		if(parent.getChildCount()==2){
			JadeNode other = null;
			for (int i = 0; i < parent.getChildCount(); i++) {
				if (parent.getChild(i) != node) {
					other = parent.getChild(i);
				}
			}
			bl = other.getBL() + parent.getBL();
			if(parent != this.root){
				JadeNode mparent = (JadeNode) parent.getParent();
				if (mparent != null) {
					mparent.addChild(other);
					other.setBL(bl);
					for (int i = 0; i < mparent.getChildCount(); i++) {
						if (mparent.getChild(i) == parent) {
							mparent.removeChild(parent);
							break;
						}
					}
				}
				this.update();
			}else{//parent == root
				other.setParent(null);
				this.setRoot(other);
				this.update();
			}
		}else{
			parent.removeChild(node);
			this.update();
		}
	}
	
	/**
	 * @returns the MRCA of two nodes in a tree. Returns null if the two nodes
	 *		do not have a common ancestor
	 */
	public static TreeNode getMRCA(TreeNode curn1, TreeNode curn2) {
		//get path to root for first node
		ArrayList<TreeNode> path1 = new ArrayList<TreeNode>();
		TreeNode parent = curn1;
		while (parent != null) {
			path1.add(parent);
			parent = parent.getParent();
		}
		//find first match between this node and the first one
		parent = curn2;
		while (parent != null) {
			if (path1.contains(parent)) {
				return parent;
			}
			parent = parent.getParent();
		}
		return null;
	}
	
	public void setHasBranchLengths(boolean v) {
		hasBranchLengths = v;
	}
	
	public boolean getHasBranchLengths() {
		return hasBranchLengths;
	}


	private class TipIterator implements Iterator<TreeNode> {
		TreeNode next;
		NodeIterator nodeIter;
		public TipIterator (JadeNode root) {
			nodeIter = new NodeIterator(root, NodeOrder.PREORDER);
			loadNextTip();
		}
		private void loadNextTip() {
			TreeNode tip = null;
			while (nodeIter.hasNext()) {
				TreeNode n = nodeIter.next();
				if (n.isExternal()) {
					tip = n;
					break;
				}
			}
			next = tip;
		}
		@Override
		public boolean hasNext() {
			return next != null;
		}
		@Override
		public TreeNode next() {
			TreeNode cur = next;
			loadNextTip();
			return cur;
		}
		@Override
		public void remove() {
			throw new UnsupportedOperationException();
		}
	}
	
	private class InternalNodeIterator implements Iterator<TreeNode> {
		TreeNode next;
		NodeIterator nodeIter;
		public InternalNodeIterator (JadeNode root, NodeOrder order) {
			nodeIter = new NodeIterator(root, order);
			loadNextTip();
		}
		private void loadNextTip() {
			TreeNode tip = null;
			while (nodeIter.hasNext()) {
				TreeNode n = nodeIter.next();
				if (! n.isExternal()) {
					tip = n;
					break;
				}
			}
			next = (TreeNode) tip;
		}
		@Override
		public boolean hasNext() {
			return next != null;
		}
		@Override
		public TreeNode next() {
			TreeNode cur = next;
			loadNextTip();
			return cur;
		}
		@Override
		public void remove() {
			throw new UnsupportedOperationException();
		}
	}
		
	private class NodeIterator implements Iterator<TreeNode> {

		// needs to be tested
		
		LinkedList<TreeNode> nodes = new LinkedList<TreeNode>();
		
		public NodeIterator(JadeNode root, NodeOrder order) {
			if (order == NodeOrder.POSTORDER) {
				postOrderAddToStack((TreeNode) root);
			} else if (order == NodeOrder.PREORDER) {
				preOrderAddToStack((TreeNode) root);
			} else {
				throw new IllegalArgumentException("no node order specified");
			}
		}
		
		private void postOrderAddToStack(TreeNode p) {
			for (TreeNode c : p.getChildren()) {
				postOrderAddToStack(c);
			}
			nodes.add(p);
		}

		private void preOrderAddToStack(TreeNode p) {
			nodes.add(p);
			for (TreeNode c : p.getChildren()) {
				preOrderAddToStack(c);
			}
		}

		@Override
		public boolean hasNext() {
			return ! nodes.isEmpty();
		}

		@Override
		public TreeNode next() {
			return (TreeNode) nodes.pop();
		}

		@Override
		public void remove() {
			throw new UnsupportedOperationException();
		}		
	}
	
	private class BipartIterator implements Iterator<TreeBipartition> {

		InternalNodeIterator nodeIter;
		HashSet<JadeNode> tips = new HashSet<JadeNode>();
		
		public BipartIterator(JadeTree tree) {
			nodeIter = new InternalNodeIterator(tree.getRoot(), NodeOrder.PREORDER);
			for (TreeNode leaf : tree.externalNodes()) {
				tips.add((JadeNode) leaf);
			}
		}
		
		@Override
		public boolean hasNext() {
			return nodeIter.hasNext();
		}

		@Override
		public TreeBipartition next() {
			TreeNode n = nodeIter.next();
			if (n == root) {
				return next();
			}
			Set<TreeNode> outgroup = new HashSet<TreeNode>();
			for (JadeNode t : tips) {
				outgroup.add((TreeNode) t);
			}
			Set<TreeNode> ingroup = new HashSet<TreeNode>();
			for (TreeNode l : n.getDescendantLeaves()) {
				ingroup.add(l);
				outgroup.remove(l);
			}
			return new TreeBipartition(ingroup, outgroup);
		}

		@Override
		public void remove() {
			nodeIter.remove();
		}
		
	}
}
