package phyparts;

import java.util.ArrayList;
import java.util.Collection;

public class Utils {

    public static String concatWithCommas(Collection<String> words) {
        StringBuilder wordList = new StringBuilder();
        for (String word : words) {
            wordList.append(word + ",");
        }
        if (wordList.length() == 0) {
            return "";
        }
        return new String(wordList.deleteCharAt(wordList.length() - 1));
    }

    public static double sum(ArrayList<Integer> ints) {
        double s = 0;
        for (Integer i : ints) {
            s += i;
        }
        return s;
    }public static double sumD(ArrayList<Double> ints) {
        double s = 0;
        for (Double i : ints) {
            s += i;
        }
        return s;
    }

    public static double logn(double x, double base) {
        return Math.log10(x) / Math.log10(base);
    }

    /*
     * to calculate this you need the distribution of values
     */
    public static double calculateICA(ArrayList<Integer> ints) {
        //System.out.println(ints);
        double ICA = 1;
        double sums = sum(ints);
        for (Integer i : ints) {
            if(i == 0)
                continue;
            double t = i / sums;
            ICA += (t * logn(t, ints.size()));
        }
        //change to negative if it isn't the largest
        if(ints.size() > 1){
            if(ints.get(0) < ints.get(1)){
                ICA = ICA * -1;
            }
        }
        return ICA;
    }public static double calculateICAD(ArrayList<Double> ints) {
        //System.out.println(ints);
        double ICA = 1;
        double sums = sumD(ints);
        double largest = 0;
        for (Double i : ints) {
            if(i>largest)
                largest = i;
            if(i == 0)
                continue;
            double t = i / sums;
            ICA += (t * logn(t, ints.size()));
        }
        //change to negative if it isn't the largest
        if(ints.size() > 1){
            if(ints.get(0) < largest){
                ICA = ICA * -1;
            }
        }
        return ICA;
    }

}
