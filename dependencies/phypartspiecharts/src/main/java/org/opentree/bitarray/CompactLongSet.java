package org.opentree.bitarray;


import gnu.trove.list.array.TLongArrayList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.BitSet;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Random;

/**
 * A relatively fast and memory efficient set implementation for long
 * integer values (which is underlain by a LongBitSet implementation).
 * 
 * @author cody hinchliff
 */
public class CompactLongSet implements Iterable<Long> {

	LongBitSet bs;
	
	// ==== constructors
		
	public CompactLongSet(Iterable<Long> longArr) {
		bs = new LongBitSet();
		this.addAll(longArr);
	}

	public CompactLongSet(int[] intArr) {
		bs = new LongBitSet();
		this.addAll(intArr);
	}
	
	public CompactLongSet(long[] longArr) {
		bs = new LongBitSet();
		this.addAll(longArr);
	}

	public CompactLongSet(TLongArrayList tLongArr) {
		bs = new LongBitSet();
		this.addAll(tLongArr);
	}
	
	public CompactLongSet(LongBitSet bs) {
		this.bs = new LongBitSet(bs);
	}
	
	public CompactLongSet() {
		bs = new LongBitSet();
	}

	// ==== basic functions
	
	public LongBitSet getBitSet() {
		return bs;
	}
	
	public long size() {
		return bs.cardinality();
	}
	
	public boolean contains(Long l) {
		return bs.get(l);
	}

	public boolean contains(int i) {
		return bs.get(i);
	}
	
	// == addition methods
	
	/**
	 * Adds the value to the bitset.
	 */
	public void add(Long l) {
		bs.set(l, true);
	}

	/**
	 * Adds the value to the bitset.
	 * @param l
	 */
	public void add(int i) {
		bs.set((long) i, true);
	}

	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(int[] toAdd) {
		for (int i : toAdd) {
			add((long) i);
		}
	}
	
	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(long[] toAdd) {
		for (long l : toAdd) {
			add(l);
		}
	}
	
	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(Iterable<Long> toAdd) {
		for (Long l : toAdd) {
			add(l);
		}
	}
	
	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(BitSet toAdd) {
		for (int i = toAdd.nextSetBit(0); i >= 0; i = toAdd.nextSetBit(i+1)) {
			add((long) i);
		}
	}

	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(TLongArrayList toAdd) {
		for (int i = 0; i < toAdd.size(); i++) {
			add(toAdd.get(i));
		}
	}

	/**
	 * Add all the values to the bitset.
	 * @param toAdd
	 */
	public void addAll(CompactLongSet toAdd) {
		this.addAll((Iterable<Long>) toAdd); // use the iterator method
	}
	
	// == removal methods

	/** 
	 * Remove all values from this bitset.
	 */
	public void clear() {
		bs = new LongBitSet();
	}

	/**
	 * Remove the value from the bitset.
	 * @param l
	 */
	public void remove(Long l) {
		bs.set(l, false);
	}
	
	/**
	 * Remove all the values in the passed array from the bitset.
	 * @param toRemove
	 */
	public void removeAll(int[] toRemove) {
		for (int i : toRemove) {
			remove((long) i);
		}
	}
	
	/**
	 * Remove all the values in the passed array from the bitset.
	 * @param toRemove
	 */
	public void removeAll(long[] toRemove) {
		for (long l : toRemove) {
			remove(l);
		}
	}
	
	/**
	 * Remove all the values in the passed iterable from the bitset.
	 * @param toRemove
	 */
	public void removeAll(Iterable<Long> toRemove) {
		for (Long l : toRemove) {
			remove(l);
		}
	}

	/**
	 * Remove all the values in the incoming bitset from the bitset.
	 * @param toRemove
	 */
	public void removeAll(BitSet toRemove) {
		for (int i = toRemove.nextSetBit(0); i >= 0; i = toRemove.nextSetBit(i+1)) {
			remove((long) i);
		}
	}
	
	/**
	 * Remove all the values in the arraylist from the bitset.
	 * @param toRemove
	 */
	public void removeAll(TLongArrayList toRemove) {
		for (int i = 0; i < toRemove.size(); i++) {
			remove(toRemove.get(i));
		}
	}

	/**
	 * Remove all the values in the incoming bitset from this bitset.
	 * 
	 * @param toRemove
	 */
	public void removeAll(CompactLongSet toRemove) {
		this.removeAll((Iterable<Long>) toRemove); // use the iterator method
	}
	
	// ==== boolean / bitwise operations

	/**
	 * Perfoms a binary andNot on the internal BitSet against the passed BitSet and returns a new biset containing the result.
	 * Does not modify the internal or the passed BitSet.
	 * @param that
	 * @return
	 */
	public CompactLongSet andNot(CompactLongSet that) {
		throw new UnsupportedOperationException(); // do not need this yet. implement when necessary.
	}
		
	/**
	 * Returns true if and only if this set contains exactly zero elements.
	 * @return
	 */
	public boolean isEmpty() {
		return size() == 0;
	}
	
	/**
	 * Returns true if and only if this bitset contains any values from the passed bitset.
	 * @param that
	 * @return
	 */
	public boolean containsAny(CompactLongSet that) {
		boolean result = false;
		for (long l : that) {
			if (this.contains(l)) {
				result = true;
				break;
			}
		}
		return result;
	}

	/**
	 * Returns true if and only if this bitset contains all the values contained in the passed bitset.
	 * @param that
	 * @return
	 */
	public boolean containsAll(CompactLongSet that) {
		boolean result = true;
		for (long l : that) {
			if (! this.contains(l)) {
				result = false;
				break;
			}
		}
		return result;
	}
	
	/**
	 * Returns a bitset containing the values that are in both this bitset and the passed bitset.
	 * @param that
	 * @return
	 */
	public CompactLongSet intersection(CompactLongSet that) {
		CompactLongSet result = new CompactLongSet();
		for (long l : that) {
			if (this.contains(l)) {
				result.add(l);
			}
		}
		return result;
	}
	
	// ==== output methods

	public long[] toArray() {
		long[] l = new long[(int)size()];
		int i = 0;
		for (long p : this) {
			l[i++] = p;
		}
		return l;
	}
	
	@Override
	public String toString() {
		return bs.toString();
/*		if (bs.cardinality() < 1) {
			return "{}";
		}
		StringBuffer s = new StringBuffer();
		s.append("{");
		boolean first = true;
		for (long l : this) {
			if (first) {
				first = false;
			} else {
				s.append(", ");
			}
			s.append(l);
		}
		s.append("}");
		return s.toString(); */
	}

	public String toString(Map<Long, Object> names) {
		return bs.toString(names);
/*		if (bs.cardinality() < 1) {
			return "{}";
		}
		StringBuffer s = new StringBuffer();
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
		s.append("}");
		return s.toString(); */
	}

	// ==== internal methods
	
	@Override
	public int hashCode() {
		return bs.hashCode();
	}

	@Override
	public boolean equals(Object that) {
		boolean result = false;
		if (that instanceof CompactLongSet) {
			CompactLongSet other = (CompactLongSet) that;
			result = bs.equals(other.bs);
		}
		return result;
	}

	/**
	 * Returns an iterator over the values from this TLongBitArray.
	 */
	@Override
	public Iterator<Long> iterator() {
		return bs.iterator();
	}
	
	/**
	 * Thorough testing for construction, adding elements, removing elements, and doing bitwise/binary operations.
	 */
	public static void main(String[] args) {

		simpleIterationTest();

		int numTestCycles = 0;
		if (args.length == 1) {
			numTestCycles = Integer.valueOf(args[0]);
		} else {
			throw new java.lang.IllegalArgumentException("you must indicate the number of test cycles to perform");
		}

		// run the tests
		Random r = new Random();
		boolean allTestsPassed = false;
		for (int i = 0; i < numTestCycles; i++) {
			System.out.println("\nTest cycle " + i);
			allTestsPassed  = runUnitTests(r.nextInt(Integer.MAX_VALUE));
		}
		
		if (allTestsPassed) {
			System.out.println("\nAll tests passed\n");
		} else {
			System.out.println("\nTests failed\n");
		}
	}
	
	private static boolean simpleIterationTest() {
		long[] a = new long[] {0, 3, 8, 23, 44, 32768, 65536, 2000000, Long.MAX_VALUE};
		CompactLongSet b = new CompactLongSet(a);
		
		for (long l : a) {
			System.out.println("underlying bs contains " + l + "? " + b.bs.get(l));
		}
		
		System.out.print(Arrays.toString(a) + " should be reflected in iteration: ");
		System.out.println(b.toString());
		return true;
	}
	
	private static boolean runUnitTests(int randSeed) {
//		long maxVal = Long.MAX_VALUE;
		Random r = new Random(randSeed);

		// create a random test arrays of ints
		int n1 = r.nextInt(20);
		long[] arr1 = new long[n1];
		for (int i = 0; i < arr1.length; i++) {
			arr1[i] = Math.abs(r.nextLong());
		}
		
		System.out.println("\nThe first array is: " + Arrays.toString(arr1));
		
		// test setting and getting
		System.out.println("Testing adding and getting");
		CompactLongSet test1 = new CompactLongSet();
		for (long k : arr1) {
			test1.add((long) k);
		}
		CompactLongSet test2 = new CompactLongSet();
		for (long k : arr1) {
			if (test1.contains(k) == false) {
				throw new AssertionError("Adding and getting failed. Bitset 1 should have contained " + k + " but it did not");
			} else {
				test2.add((long) k);
			}
		}
		test1 = new CompactLongSet(arr1);
		for (Long l : test2) {
			if (test1.contains(l) == false) {
				throw new AssertionError("Adding and getting failed. Bitset 1 should have contained " + l + " but it did not");
			}
		}
		System.out.println("Adding and getting passed\n");
		
		// instantiating a BitArray from a TLongArrayList
		System.out.println("Testing BitArray construction from TLongArrayList");
		TLongArrayList testTL = new TLongArrayList();
		for (long i : arr1) {
			testTL.add(i);
		}
		System.out.println("the TLongArrayList contains " + testTL.size() + " values: " + Arrays.toString(testTL.toArray()));
		test1 = new CompactLongSet(testTL);
		System.out.println("The Bitset constructed from the TLongArrayList contains: " + test1);
		Arrays.sort(arr1); // has to be on because testInternalState calls sort the bitarray
		HashSet<Long> uniqueInts = new HashSet<Long>();
		for (int k = 0; k < arr1.length; k++) {
			uniqueInts.add(arr1[k]);
			if (! test1.contains(arr1[k])) {
				throw new java.lang.AssertionError("Bitset creation from TLongArrayList failed");
			}
		}
		if (! (test1.size() == uniqueInts.size())) {
			throw new java.lang.AssertionError("Bitset creation from long array failed");
		}
		System.out.println("Bitset construction from TLongArrayList passed\n");

		// test instantiating a BitArray from another BitArray
		System.out.println("Testing FastBitSet construction from another FastBitSet");
		test2 = new CompactLongSet(arr1);
		System.out.println("The starting Bitset contains " + test2.size() + " values: " + test2);
		test1 = new CompactLongSet(test2);
		System.out.println("The Bitset constructed from the starting BitArray contains: " + test1);
		uniqueInts = new HashSet<Long>();
		for (int k = 0; k < arr1.length; k++) {
			uniqueInts.add(arr1[k]);
			if (! test1.contains(arr1[k])) {
				throw new java.lang.AssertionError("FastBitset creation from FastBitset failed");
			}
		}
		if (! (test1.size() == uniqueInts.size())) {
			throw new java.lang.AssertionError("Bitset creation from long array failed");
		}
		System.out.println("Bitset construction from Bitset passed\n");

		// instantiating a BitArray from a long array
		System.out.println("Testing Bitset construction from long array primitive");
		long[] testArrLong = new long[r.nextInt(20)];
		for (int k = 0; k < testArrLong.length; k++) {
			testArrLong[k] = Math.abs(r.nextLong());
		}
		System.out.println("The long array contains " + testArrLong.length + " values: " + Arrays.toString(testArrLong));
		test1 = new CompactLongSet(testArrLong);
		System.out.println("The Bitset constructed from the TLongArrayList contains: " + test1);
		Arrays.sort(testArrLong); // has to be on because testInternalState calls sort the bitarray
		HashSet<Long> uniqueLongs = new HashSet<Long>();
		for (int k = 0; k < testArrLong.length; k++) {
			uniqueLongs.add(testArrLong[k]);
			if (! test1.contains(testArrLong[k])) {
				throw new java.lang.AssertionError("Bitset creation from long array failed");
			}
		}
		if (! (test1.size() == uniqueLongs.size())) {
			throw new java.lang.AssertionError("Bitset creation from long array failed");
		}
		System.out.println("Bitset construction from long array primitive passed\n");
		
		// instantiating a BitArray from a long array
		System.out.println("Testing Bitset construction from int array primitive");
		testArrLong = new long[r.nextInt(20)];
		for (int k = 0; k < testArrLong.length; k++) {
			testArrLong[k] = Math.abs(r.nextLong());
		}
		System.out.println("The int array contains " + testArrLong.length + " values: " + Arrays.toString(testArrLong));
		test1 = new CompactLongSet(testArrLong);
		System.out.println("The BitArray constructed from the TLongArrayList contains: " + test1);
		Arrays.sort(testArrLong); // has to be on because testInternalState calls sort the bitarray
		uniqueLongs = new HashSet<Long>();
		for (int k = 0; k < testArrLong.length; k++) {
			uniqueLongs.add(testArrLong[k]);
			if (! test1.contains(testArrLong[k])) {
				throw new java.lang.AssertionError("Bitset creation from int array failed");
			}
		}
		if (! (test1.size() == uniqueLongs.size())) {
			throw new java.lang.AssertionError("Bitset creation from long array failed");
		}
		System.out.println("Bitset construction from int array primitive passed\n");
		
		// testing BitSet updating
		System.out.println("Testing removal from the BitArray");
		System.out.println("Bitset contains: " + test1);
		System.out.println("Removing values: " + Arrays.toString(testArrLong));
		test1.removeAll(testArrLong);
		for (int k = 0; k < testArrLong.length; k++) {
			if (test1.contains(testArrLong[k])) {
				throw new java.lang.AssertionError("Bitset removal failed, still contains " + testArrLong[k]);
			}
		}
		if (test1.size() > 0) {
			System.out.println("Array should be empty, but it still contains: " + test1);
			throw new java.lang.AssertionError("Bitset removal failed");
		}
		if (test1.bs.cardinality() > 0) {
			throw new AssertionError("Bitset is empty, but its BitSet still contains " + test1.bs.cardinality() + " values");
		} else {
			System.out.println("Bitset is empty");
		}
		System.out.println("Bitset removal passed\n");
		
		/*
		// creating arrays to test intersection
		maxVal = 10;
		n1 = r.nextInt(20);
		arr1 = new int[n1];
		for (int i = 0; i < arr1.length; i++) {
			arr1[i] = r.nextInt(maxVal);
		}
		int n2 = r.nextInt(20);
		int[] arr2 = new int[n2];
		for (int i = 0; i < arr2.length; i++) {
			arr2[i] = r.nextInt(maxVal);
		}

		// make a new BitSet with arr1 values
		BitSet testBS1 = new BitSet();
		for (int i : arr1) {
			testBS1.set(i, true);
		}
		
		// make a new BitSet with arr2 values
		BitSet testBS2 = new BitSet();
		for (int i : arr2) {
			testBS2.set(i, true);
		}
		
		// testing intersection
		System.out.println("Testing intersection with BitSet. Finding intersection of:");
		System.out.println(Arrays.toString(arr1));
		System.out.println(Arrays.toString(arr2));
		testBS1.and(testBS2);
		int[] bsVals = new int[testBS1.cardinality()];
		j = 0;
		for (int k = testBS1.nextSetBit(0); k >= 0; k = testBS1.nextSetBit(k+1)) {
			bsVals[j++] = k;
		}
		System.out.println("Intersection should be: " + Arrays.toString(bsVals));
		
		test1 = new NewBitSet(arr1);
		System.out.println("Intersecting BitArray: " + Arrays.toString(test1.toArray()));
		System.out.println("with BitSet containing: " + Arrays.toString(arr2));

		// making a new BitSet with arr2 values
		testBS2 = new BitSet();
		for (int i : arr2) {
			testBS2.set(i, true);
		}
		NewBitSet intersection = test1.getIntersection(testBS2);

		System.out.println("Intersection is: " + Arrays.toString(intersection.toArray()));
		for (Long l : intersection) {
			if (testBS1.get(l.intValue()) != true) {
				throw new java.lang.AssertionError("Intersection failed: value " + l + " is present but should not be.");
			}
		}
		for (int k = testBS1.nextSetBit(0); k >= 0; k = testBS1.nextSetBit(k+1)) {
			if (intersection.contains(k) != true) {
				throw new java.lang.AssertionError("Intersection failed: value " + k + " should be present but is not.");
			}
		}
		System.out.println("Intersection with BitSet passed\n");

		System.out.println("Testing intersection with BitArray:");
		test2 = new NewBitSet(arr2);
		intersection = test1.getIntersection(test2);
		System.out.println("Intersection is: " + Arrays.toString(intersection.toArray()));
		for (Long l : intersection) {
			if (testBS1.get(l.intValue()) != true) {
				throw new java.lang.AssertionError("Intersection failed: value " + l + " is present but should not be.");
			}
		}
		for (int k = testBS1.nextSetBit(0); k >= 0; k = testBS1.nextSetBit(k+1)) {
			if (intersection.contains(k) != true) {
				throw new java.lang.AssertionError("Intersection failed: value " + k + " should be present but is not.");
			}
		}
		System.out.println("Intersection with BitArray passed\n");

		// replace testBS1
		testBS1 = new BitSet();
		for (int i : arr1) {
			testBS1.set(i, true);
		}
		*/
		
		// creating arrays to test contains all
//		maxVal = 10;
		n1 = r.nextInt(20);
		int[] arr3 = new int[n1];
		for (int i = 0; i < arr3.length; i++) {
			arr3[i] = Math.abs(r.nextInt(1000000));
		}
		int n2 = r.nextInt(20);
		int[] arr2 = new int[n2];
		for (int i = 0; i < arr2.length; i++) {
			arr2[i] = Math.abs(r.nextInt(1000000));
		}

		// populate bitsets with array values
		BitSet testBS1 = new BitSet();
		for (int i : arr3) { testBS1.set(i-1, true); }
		BitSet testBS2 = new BitSet();
		for (int i : arr2) { testBS2.set(i-1, true); }
		test1 = new CompactLongSet(arr3);
		test2 = new CompactLongSet(arr2);
		
		System.out.println("Testing containsAll");
		System.out.println("BitSet 1 contains: " + test1);
		System.out.println("BitSet 2 contains: " + test2);
		
		boolean containsAll1;
		boolean bsContainsAll1;
		int cardinalityBeforeAnd;
		if (test2.size() > 0) {
			containsAll1 = test1.containsAll(test2);
			System.out.println("FastBitSet 1 contains all of FastBitSet 2? " + containsAll1);
			cardinalityBeforeAnd = testBS2.cardinality();
			testBS2.and(testBS1);
			bsContainsAll1 = cardinalityBeforeAnd == testBS2.cardinality();
			System.out.println("test BitSet 1 contains all of test BitSet 2? " + bsContainsAll1);
			if (bsContainsAll1 != containsAll1) {
				throw new AssertionError("Contains all failed.");
			}
			System.out.println("Passed contains all test 1");
		} else {
			try {
				containsAll1 = test1.containsAll(test2);
			} catch (NoSuchElementException ex) {
				System.out.println(ex.getMessage() + " (NoSuchElementException thrown correctly)");
			}
		}
			
		// replace testBS2
		testBS2 = new BitSet();
		for (int i : arr2) {
			testBS2.set(i, true);
		}
		
		boolean containsAll2;
		boolean bsContainsAll2;
		if (test1.size() > 0) {
			containsAll2 = test2.containsAll(test1);
			System.out.println("BitSet 2 contains all of BitSet 1? " + test2.containsAll(test1));
			cardinalityBeforeAnd = testBS1.cardinality();
			testBS1.and(testBS2);
			bsContainsAll2 = cardinalityBeforeAnd == testBS1.cardinality();
			System.out.println("test BitSet 1 contains all of test BitSet 2? " + bsContainsAll2);
			if (bsContainsAll2 != containsAll2) {
				throw new AssertionError("Contains all failed.");
			}		
			System.out.println("Passed contains all test 2");
		} else {
			try {
				containsAll1 = test2.containsAll(test1);
			} catch (NoSuchElementException ex) {
				System.out.println(ex.getMessage() + " (NoSuchElementException thrown correctly)");
			}
		}
		
		System.out.println("Passed contains all\n");
		
		// creating arrays to test containsAny
//		maxVal = 10;
		n1 = r.nextInt(1000);
		arr3 = new int[n1];
		for (int i = 0; i < arr3.length; i++) {
			arr3[i] = Math.abs(r.nextInt(1000000));
		}
		n2 = r.nextInt(1000);
		arr2 = new int[n2];
		for (int i = 0; i < arr2.length; i++) {
			arr2[i] = Math.abs(r.nextInt(1000000));
		}
		
		// replace testBS1
		testBS1 = new BitSet();
		for (int i : arr3) {
			testBS1.set(i, true);
		}
		
		// making a new BitSet with arr2 values
		testBS2 = new BitSet();
		for (int i : arr2) {
			testBS2.set(i, true);
		}

		System.out.println("Testing contains any");
		test1 = new CompactLongSet(arr3);
		test2 = new CompactLongSet(arr2);
		System.out.println("BitSet 1 contains: " + test1);
		System.out.println("BitSet 2 contains: " + test2);

		boolean containsAny1 = false;
		boolean bsContainsAny1 = false;
		if (test2.size() > 0) {
			containsAny1 = test1.containsAny(test2);
			System.out.println("FastBitSet 1 contains any of FastBitSet 2? " + containsAny1);
			if (containsAny1) {
				System.out.println("yes");
//				System.out.println("BitArray 1 and BitArray 2 both contain: " + Arrays.toString(test1.getIntersection(test2).toArray()));
			} else {
				System.out.println("No overlap");
			}
			bsContainsAny1 = testBS1.intersects(testBS2);
			System.out.println("test BitSet 1 contains any of test BitSet 2? " + testBS1.intersects(testBS2));
			if (bsContainsAny1 != containsAny1) {
				throw new AssertionError("Contains any failed.");
			}		
			System.out.println("Passed contains any test 1");

		} else {
			try {
				containsAny1 = test1.containsAny(test2);
			} catch (NoSuchElementException ex) {
				System.out.println(ex.getMessage() + " (NoSuchElementException thrown correctly)");
			}
		}
		
		boolean containsAny2 = false;
		boolean bsContainsAny2 = false;
		if (test1.size() > 0) {
			containsAny2 = test2.containsAny(test1);
			System.out.println("BitSet 2 contains any of BitSet 1? " + containsAny2);
			if (containsAny1) {
				System.out.println("no");
//				System.out.println("BitArray 1 and BitArray 2 both contain: " + Arrays.toString(test1.getIntersection(test2).toArray()));
			} else {
				System.out.println("No overlap");
			}
			bsContainsAny2 = testBS2.intersects(testBS1);
			System.out.println("test BitSet 2 contains any of test BitSet 1? " + testBS2.intersects(testBS1));
			if (bsContainsAny2 != containsAny2) {
				throw new AssertionError("Contains any failed.");
			}		
			System.out.println("Passed contains any test 2");

		} else {
			try {
				containsAny2 = test2.containsAny(test1);
			} catch (NoSuchElementException ex) {
				System.out.println(ex.getMessage() + " (NoSuchElementException thrown correctly)");
			}
			containsAny2 = containsAny1;
			bsContainsAny2 = containsAny1;
		}

		if ((containsAny1 == containsAny2 == bsContainsAny1 == bsContainsAny2) == false) {
			throw new AssertionError("Contains any failed. If either BitSet  contained any of the other, then all the contains any tests should have been true.");
		} else {
			System.out.println("Passed contains any\n");
		}

//		maxVal = 20;
		int maxOps = 10;

		
		System.out.println("Testing add/remove with duplicate values");
		
		int nCycles = r.nextInt(maxOps);
		int nAdds;
		int nRemoves;
		int testVal;

		test1 = new CompactLongSet();
		System.out.println("BitSet contains " + test1);
		HashMap<Integer, Integer> expectedCounts = new HashMap<Integer, Integer>();
		for (int k = 0; k < nCycles; k++) {
			nAdds = r.nextInt(maxOps);
			nRemoves = r.nextInt(maxOps);
			testVal = Math.abs(r.nextInt());
			System.out.println("Will add the value " + testVal + " to  BitSet " + nAdds + " times, then attempt to remove it " + nRemoves + " times");
			for (int l = 0; l < nAdds; l++) {
				test1.add((long) testVal);
			}
			test1.remove((long) testVal);
			System.out.println("BitSet contains " + test1);
			if (test1.contains(testVal)) {
				throw new AssertionError("BitSet should not contain testval");
			}
		}
		System.out.println("Passed duplicate values add/remove\n");
		
		/*
		System.out.println("Testing sequential add and remove");
		maxVal = 50;
		maxOps = 100;
		int nOps1 = r.nextInt(maxOps);
		int nOps2 = maxOps - nOps1;
		test1 = new NewBitSet();
		test2 = new NewBitSet();
		
		int nAddOps = 0;
		int nRemoveOps = 0;
		int nSkippedOps = 0;
		System.out.println("Will attempt to perform " + nOps1 + " operations on BitArray 1");
		for (int i = 0; i < nOps1; i++) {
			int nextInt = r.nextInt(maxVal);
			if (r.nextBoolean()) {
				test1.add(nextInt);
				nAddOps++;
			} else {
				if (test1.contains(nextInt)) {
					test1.remove(nextInt);
					nRemoveOps++;
				} else {
					nSkippedOps++;
				}
			}
		}
		test1.updateBitSet();
		System.out.println("Performed " + nAddOps + " add operations, " + nRemoveOps + " remove operations, and skipped " + nSkippedOps + " operations on BitArray 1");

		nAddOps = 0;
		nRemoveOps = 0;
		nSkippedOps = 0;
		System.out.println("Will attempt to perform " + nOps2 + " operations on BitArray 2");
		for (int i = 0; i < nOps2; i++) {
			int nextInt = r.nextInt(maxVal);
			if (r.nextBoolean()) {
				test2.add(nextInt);
				nAddOps++;
			} else {
				if (test2.contains(nextInt)) {
					test2.remove(nextInt);
					nRemoveOps++;
				} else {
					nSkippedOps++;
				}
			}
		}
		test1.updateBitSet();
		System.out.println("Performed " + nAddOps + " add operations, " + nRemoveOps + " remove operations, and skipped " + nSkippedOps + " operations on BitArray 2\n");

		System.out.println("BitArray 1: " + Arrays.toString(test1.toArray()));
		System.out.println("BitArray 2: " + Arrays.toString(test2.toArray()) + "\n");

		intersection = test1.getIntersection(test2);
		System.out.println("BitArray 1 and BitArray 2 have " + intersection.size() + " elements in common: " + Arrays.toString(intersection.toArray()));

		// these should always be true
		boolean arr1ContainsAllIntersectionEXPECT = true;
		boolean arr2ContainsAllIntersectionEXPECT = true;
		boolean arr1ContainsAllArr2EXPECT = intersection.size() == test2.cardinality() ? true : false;
		boolean arr2ContainsAllArr1EXPECT = intersection.size() == test1.cardinality() ? true : false;

		// these depend on the situation
		boolean intersectionContainsAnyArr1EXPECT;
		boolean intersectionContainsAnyArr2EXPECT;
		boolean arr1ContainsAnyArr2EXPECT;
		boolean arr2ContainsAnyArr1EXPECT;

		if (intersection.size() > 0) {
			
			intersectionContainsAnyArr1EXPECT = true;
			intersectionContainsAnyArr2EXPECT = true;
			arr1ContainsAnyArr2EXPECT = true;
			arr2ContainsAnyArr1EXPECT = true;
			
		} else { // the intersection was null

			intersectionContainsAnyArr1EXPECT = false;
			intersectionContainsAnyArr2EXPECT = false;
			arr1ContainsAnyArr2EXPECT = false;
			arr2ContainsAnyArr1EXPECT = false;
			
		}

		boolean arr1ContainsAllIntersection = test1.containsAll(intersection);
		System.out.println("Does BitArray 1 contain all the shared values? " + arr1ContainsAllIntersection);
		if (arr1ContainsAllIntersection != arr1ContainsAllIntersectionEXPECT) {
			throw new AssertionError("Contains all failed");
		}

		boolean arr2ContainsAllIntersection = test2.containsAll(intersection);
		System.out.println("Does BitArray 2 contain all the shared values? " + arr2ContainsAllIntersection);
		if (arr2ContainsAllIntersection != arr2ContainsAllIntersectionEXPECT) {
			throw new AssertionError("Contains all failed");
		}
		
		boolean intersectionContainsAnyArr1 = intersection.containsAny(test1);
		System.out.println("Does the intersection contain any of BitArray 1? " + intersectionContainsAnyArr1);
		if (intersectionContainsAnyArr1 != intersectionContainsAnyArr1EXPECT) {
			throw new AssertionError("Contains any failed");
		}
		
		boolean intersectionContainsAnyArr2 = intersection.containsAny(test2);
		System.out.println("Does the intersection contain any of BitArray 2? " + intersectionContainsAnyArr2);
		if (intersectionContainsAnyArr2 != intersectionContainsAnyArr2EXPECT) {
			throw new AssertionError("Contains any failed");
		}
		
		boolean arr1ContainsAnyArr2 = test1.containsAny(test2);
		System.out.println("Does BitArray 1 contain any of BitArray 2? " + arr1ContainsAnyArr2);
		if (arr1ContainsAnyArr2 != arr1ContainsAnyArr2EXPECT) {
			throw new AssertionError("Contains any failed");
		}

		boolean arr2ContainsAnyArr1 = test2.containsAny(test1);
		System.out.println("Does BitArray 2 contain any of BitArray 1? " + arr2ContainsAnyArr1);
		if (arr2ContainsAnyArr1 != arr2ContainsAnyArr1EXPECT) {
			throw new AssertionError("Contains any failed");
		}
		
		boolean arr1ContainsAllArr2 = test1.containsAll(test2);
		System.out.println("Does BitArray 1 contain ALL of BitArray 2? " + arr1ContainsAllArr2);
		if (arr1ContainsAllArr2 != arr1ContainsAllArr2EXPECT) {
			throw new AssertionError("Contains all failed");
		}

		boolean arr2ContainsAllArr1 = test2.containsAll(test1);
		System.out.println("Does BitArray 2 contain ALL of BitArray 1? " + arr2ContainsAllArr1);
		if (arr2ContainsAllArr1 != arr2ContainsAllArr1EXPECT) {
			throw new AssertionError("Contains all failed");
		}
		*/

		return true;
	} 
}