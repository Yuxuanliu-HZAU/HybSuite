# README #

PhyParts is meant to examine clades from a set of trees that may include
duplications and incomplete taxon sampling. This is often the case with
transcriptomes and genomes. These are relatively simple mapping analyses, intended to allow for exploration of large datasets. Feel free to request functions or report bugs in the bug reporting page. **NOTE**: For partial sampling ICA and related 
scores, I can recommend looking at RAxML as they have been implemented 
there (details of their implementation and calculations are [here](http://biorxiv.org/content/biorxiv/early/2015/07/06/022053.full.pdf)). 
Specifically, RAxML will calculate these much faster and will include a 
more complete set of measures. PhyParts assumes rooted trees and clades
(instead of bipartitions as we are primarily interested in gene trees 
with duplications). There is a great visualization script that you can 
check out [here](https://github.com/mossmatters/MJPythonNotebooks/blob/master/PhyParts_PieCharts.ipynb) courtesy of Matt Johnson. 

### How are things actually calculated? ###
There are a number of different ways that you can map trees together when there are duplications, missing data, and other complications. In order to make these analyses very clear and transparent (for easier interpretation) please see the [wiki](https://bitbucket.org/blackrim/phyparts/wiki/). 
 

### How do I get set up? ###

* Dependencies: mvn3, java, and git
* To get phyparts, you can clone the git repository `git clone https://bitbucket.org/blackrim/phyparts.git`
* If you have all the above, you can go into the phyparts directory (made from above) and run `./mvn_cmdline.sh`
* You can get some of the arguments by then running `java -jar target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar`

### Example ###

Here is just a simple example of a set of tree with the expected output

* Tree set
```
(((A,C),((A,B),C)),(D,E));
(((((A,C),(A,B)),C),((A,B),C)),(D,E));
((((A,B),C),D),E);
((((A,C),B),D),E);
(((A,C),B),D);
((A,C),D);
(((A,B),D),C);
```

* Conflict command
```
java -jar target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d test/testd -m test/sp.tre -o out
```
This command says to conduct a thorough conflict analysis (`-a 1` which includes getting the number of conflicting genetrees for each alternative) and to be verbose (`-v` output each genetree in conflict and concordance). The directory or tree file (`-d test/testd`) and tree file to map to (`-m test/sp.tre`) and the out prefix is called (`-o out`). 

* Output
```
VERBOSE mode
Mapping tree:test/sp.tre
Read 7 trees
Finished calculating clades
tree:0 / 7
tree:1 / 7
tree:2 / 7
tree:3 / 7
tree:4 / 7
tree:5 / 7
tree:6 / 7
```

* Out files
```
out.concon.tre      out.concord.node.1  out.conflict.node.0  out.conflict.node.2  out.hist.alts
out.concord.node.0  out.concord.node.2  out.conflict.node.1  out.hist             out.node.key
```

For each file here is the output

* out.concon.tre
```
((((A,B)4,C)6,D)2,E)
((((A,B)2,C)1,D)2,E)
((((A,B)0.08170416594551055,C)0.40832722141767264,D)0.0,E)
```
The first tree is the number of genetrees supporting each clade. The second tree is the number of genetrees conflicting with each clade. The third tree is the ICA score for each clade.

* out.node.key
```
0 (((A,B),C),D)
1 ((A,B),C)
2 (A,B)
```
These numbers will be referred to in the other files (the suffix numbers).

* out.concord.node.0

```
test/testd/3
test/testd/4
```
* out.concord.node.1
```
test/testd/6
test/testd/5
test/testd/3
test/testd/1
test/testd/4
test/testd/2
```
* out.concord.node.2
```
test/testd/3
test/testd/1
test/testd/7
test/testd/2
```
* out.conflict.node.0
```
test/testd/1
test/testd/2
```
* out.conflict.node.1
```
test/testd/7
```
* out.conflict.node.2
```
test/testd/5
test/testd/4
```

* out.hist
```
Node0,2,4
Node1,1,7
Node2,2,6
```
This gives the node id, then the distribution (in this case there is just one real alternative topology for each clade) and then the total number of support and conflicting genetrees (for scaling). 

* out.hist.alts
```
alt for 0 (2):D,E A,B,C
alt for 1 (1):A,B,D C
alt for 2 (2):A,C B,D,E
```
This gives the top alternative topology.

* Duplication command
```
java -jar target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 2 -v -d test/testd -m test/sp.tre -o out
```

* Out files
```
out.dupl.0  out.dupl.1  out.dupl.2  out.dupl.tre  out.node.key
```

The `out.node.key` will be the same as the one above.

Output

* out.dupl.tre
```
((((A,B)0,C)2,D)0,E)
((((A,B)0,C)2,D)0,E)
```
The first tree has the number of dups and the second has the number of genetrees with duplications.

* out.dupl.1
```
test/testd/1
test/testd/2
```