package org.opentree.bitarray;

import java.util.BitSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * http://java-performance.info/bit-sets/
 * @author Mikhail Vorontsov
 *
 */
public class LongBitSet implements Iterable<Long> {

	/** Number of bits allocated to a value in an index */
    private static final int VALUE_BITS = 17; // 2^VALUE_BITS = how many values per bit set 2^16 = 65536
    /** Mask for extracting values */
    private static final long VALUE_MASK = ( 1 << VALUE_BITS ) - 1;
 
    /**
     * Map from a value stored in high bits of a long index to a bit set mapped to the lower bits of an index.
     * Bit sets size should be balanced - not to long (otherwise setting a single bit may waste megabytes of memory)
     * but not too short (otherwise this map will get too big). Update value of {@code VALUE_BITS} for your needs.
     * In most cases it is ok to keep 1M - 64M values in a bit set, so each bit set will occupy 128Kb - 8Mb.
     */
    private Map<Long, BitSet> m_sets = new HashMap<Long, BitSet>( VALUE_BITS );

    public LongBitSet() {}
    
    public LongBitSet(LongBitSet b) {
    	m_sets = new HashMap<Long, BitSet>(b.m_sets);
    }
    
    /**
     * Get set index by long index (extract bits VALUE_BITS-63)
     * @param index Long index
     * @return Index of a bit set in the inner map
     */
    private long getSetIndex( final long index )
    {
        return index >> VALUE_BITS;
    }
     
    /**
     * Get index of a value in a bit set (bits 0-(VALUE_BITS-1))
     * @param index Long index
     * @return Index of a value in a bit set
     */
    private int getPos( final long index )
    {
        return (int) (index & VALUE_MASK);
    }
 
    /**
     * Helper method to get (or create, if necessary) a bit set for a given long index
     * @param index Long index
     * @return A bit set for a given index (always not null)
     */
    private BitSet bitSet( final long index )
    {
        final Long iIndex = getSetIndex( index );
        BitSet bitSet = m_sets.get( iIndex );
        if ( bitSet == null )
        {
            bitSet = new BitSet( 1024 );
            m_sets.put( iIndex, bitSet );
        }
        return bitSet;
    }

    /**
     * Return the largest possible value that can be stored in this bitset.
     * @return
     */
    public static long maxValue () {
    	return (int) (Long.MAX_VALUE & VALUE_MASK);
    }

    /**
     * Set a given value for a given index
     * @param index Long index
     * @param value Value to set
     */
    public void set( final long index, final boolean value )
    {
        if ( value )
            bitSet( index ).set( getPos( index ), value );
        else
        {  //if value shall be cleared, check first if given partition exists
            final BitSet bitSet = m_sets.get( getSetIndex( index ) );
            if ( bitSet != null )
                bitSet.clear( getPos( index ) );
        }
    }
 
    /**
     * Get a value for a given index
     * @param index Long index
     * @return Value associated with a given index
     */
    public boolean get( final long index )
    {
        final BitSet bitSet = m_sets.get( getSetIndex( index ) );
        return bitSet != null && bitSet.get( getPos( index ) );
    }
 
    /**
     * Clear all bits between {@code fromIndex} (inclusive) and {@code toIndex} (exclusive)
     * @param fromIndex Start index (inclusive)
     * @param toIndex End index (exclusive)
     */
    public void clear( final long fromIndex, final long toIndex )
    {
        if ( fromIndex >= toIndex ) return;
        final long fromPos = getSetIndex( fromIndex );
        final long toPos = getSetIndex( toIndex );
        //remove all maps in the middle
        for ( long i = fromPos + 1; i < toPos; ++i )
            m_sets.remove( i );
        //clean two corner sets manually
        final BitSet fromSet = m_sets.get( fromPos );
        final BitSet toSet = m_sets.get( toPos );
        ///are both ends in the same subset?
        if ( fromSet != null && fromSet == toSet )
        {
            fromSet.clear( getPos( fromIndex ), getPos( toIndex ) );
            return;
        }
        //clean left subset from left index to the end
        if ( fromSet != null )
            fromSet.clear( getPos( fromIndex ), fromSet.length() );
        //clean right subset from 0 to given index. Note that both checks are independent
        if ( toSet != null )
            toSet.clear( 0, getPos( toIndex ) );
    }
 
    public long cardinality() {
    	long c = 0;
    	for (Long highBits : m_sets.keySet()) {
    		c += m_sets.get(highBits).cardinality();
    	}
    	return c;
    }
    
    @Override
    public boolean equals(Object that) {
    	boolean result = false;
    	if (that != null && that instanceof LongBitSet) {
    		LongBitSet b = (LongBitSet) that;
    		if (this.cardinality() == b.cardinality()) {
        		result = true;
	    		for (long l : b) {
	    			if (this.get(l) == false) {
	    				result = false; 
	    			}
	    		}
    		}
    	}
		return result;
    }
    
    @Override
    public String toString() {
		if (cardinality() < 1) {
			return "{}";
		}
    	StringBuilder s = new StringBuilder();
    	boolean first = true;
    	s.append("{");
    	for (long l : this) {
    		if (first) { first = false;  }
    		else       { s.append(", "); }
    		s.append(l);
    	}
    	s.append("}");
    	return s.toString();
    }
    
    public String toString(Map<Long, Object> names) {
		if (cardinality() < 1) {
			return "{}";
		}
/*		StringBuffer s = new StringBuffer();
		s.append("{");
		boolean first = true;
		for (long l : this) {
			if (first) {
				first = false;
			} else {
				s.append(", ");
			}
			s.append(names.get(l));
		}
		s.append("}"); */
    	StringBuilder s = new StringBuilder();
    	boolean first = true;
    	s.append("{");
    	for (long l : this) {
    		if (first) { first = false;  }
    		else       { s.append(", "); }
    		s.append(names.get(l));
    	}
    	s.append("}");

		return s.toString();
    }
    
	@Override
	public int hashCode() {
		// could attempt to make the this parallel if it would help
		int h = 1;
		for (long p : this) { h *= (29 + ((p >>> 32) ^ p)); }
		return h;
	}
    
    public Iterator<Long> iterator() {
    	return new Iterator<Long>() {

    		Long[] highBits = m_sets.keySet().toArray(new Long[0]);
    		int i = 0; // index of highBits value for the bitset B we are currently scanning
    		int j = 0; // index at which to start scanning B for next value
    		long next = getNext();
    		
    		private long getNext() {
    			Long cur = -1L;
    			if (i >= highBits.length) { // no more bitsets to explore
    				return cur;
    			}

	            int lowBits = m_sets.get(highBits[i]).nextSetBit(j);
	            if (lowBits >= 0) { // got next value from bitset, combine with high bits and return long
	            	long base = highBits[i] << VALUE_BITS;
	            	cur = base + lowBits;
	            	j = lowBits + 1;
	            } else { // no more set bits in this bitset, move on to the next one
	            	i++;
	            	j = 0;
	            	return getNext();
	            }
	            assert cur >= 0;
	            return cur;
    		}
    		
			@Override
			public boolean hasNext() {
				return next >= 0;
			}

			@Override
			public Long next() {
				long cur = next;
				next = getNext();
				return cur;
			}

			@Override
			public void remove() {
				throw new UnsupportedOperationException();
			}
    	};
    }
    
    /*
     * Iteration over all set values in a LongBitSet. Order of iteration is not specified.
     * @param proc Procedure to call. If it returns {@code false}, then iteration will stop at once
     *
    public void forEach( final LongProcedure proc )
    {
        for ( final Map.Entry<Long, BitSet> entry : m_sets.entrySet() )
        {
            final BitSet bs = entry.getValue();
            final long baseIndex = entry.getKey() << VALUE_BITS;
            for ( int i = bs.nextSetBit( 0 ); i >= 0; i = bs.nextSetBit( i + 1 ) ) {
                if ( !proc.forEntry( baseIndex + i ) )
                    return;
            }
        }
    } */
    
    public static void main(String[] args) {
    	
    	
    	LongBitSet a = new LongBitSet();
    	LongBitSet b = new LongBitSet();
    	
    	a.set(0, true);
    	a.set(2, true);
    	a.set(3, true);
    	a.set(4, true);
    	a.set(5L, true);
    	
    	b.set(5L, true);
    	b.set(3, true);
    	b.set(4, true);
    	b.set(2, true);
    	b.set(0, true);
    	
    	System.out.println(a);
    	System.out.println(a.hashCode());
    	System.out.println(b);
    	System.out.println(b.hashCode());
    	System.out.println(a.equals(b));
    }
}