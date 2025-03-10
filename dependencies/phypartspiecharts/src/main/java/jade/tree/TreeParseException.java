package jade.tree;

public class TreeParseException extends Exception {
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	String message = "";
	
	public TreeParseException (String message) {
        super();
        this.message = message;
    }
    
    @Override
    public String toString() {
    	return message;
    }
}
