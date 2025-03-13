package jade.tree;

public interface Tree {

	TreeNode getRoot();
	Iterable<TreeNode> internalNodes(NodeOrder order);
	Iterable<TreeNode> externalNodes();
	Iterable<TreeNode> nodes(NodeOrder order);
	int internalNodeCount();
	int externalNodeCount();
	TreeBipartition getBipartition(TreeNode p);
	Iterable<TreeBipartition> bipartitions();

}
