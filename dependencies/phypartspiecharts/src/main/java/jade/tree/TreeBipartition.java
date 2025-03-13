package jade.tree;

import java.util.Set;

public class TreeBipartition {

	private final Set<TreeNode> ingroup;
	private final Set<TreeNode> outgroup;
	
	public TreeBipartition(Set<TreeNode> ingroup, Set<TreeNode> outgroup) {
		this.ingroup = ingroup;
		this.outgroup = outgroup;
	}
	
	@Override
	public boolean equals(Object that) {
		boolean result = false;
		if (that instanceof TreeBipartition) {
			TreeBipartition b = (TreeBipartition) that;
			result = ingroup.size() == b.ingroup.size() && outgroup.size() == b.outgroup.size() &&
					 ingroup.containsAll(b.ingroup) && outgroup.containsAll(b.outgroup);
		}
		return result;
	}
	
	@Override
	public int hashCode() {
		// have not tested this hash function for performance. be wary.
		long h = 0;
		for (TreeNode p : ingroup) { int x = p.getLabel().hashCode(); h = (h * (59 + x)) + x; }
		for (TreeNode p : outgroup) { int x = p.getLabel().hashCode(); h = (h * (73 + x)) + x; }
		return (int) h;
	}
	
	public Iterable<TreeNode> ingroup() {
		return ingroup;
	}

	public Iterable<TreeNode> outgroup() {
		return outgroup;
	}

	@Override
	public String toString() {
		StringBuffer s = new StringBuffer();
		s.append("{");
		boolean first = true;
		for (TreeNode l : ingroup) {
			if (first) {
				first = false;
			} else {
				s.append(", ");
			}
			s.append(l.getLabel());
		}
		s.append("} | {");
		first = true;
		for (TreeNode l : outgroup) {
			if (first) {
				first = false;
			} else {
				s.append(", ");
			}
			s.append(l.getLabel());
		}
		s.append("}");
		return s.toString();
	}
}