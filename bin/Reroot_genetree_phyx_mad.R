# Author: Yuxuan
# This script one step in the automatic pipeline
# that it takes one argument as gene; then it will find the gene tree
# check if the outgroup present; if not the use mad to root the tree by minimal ancestor deviation
library("ape")
library("phytools")
# suppressWarnings(suppressMessages(library("phytools")))
#1. Define Parameters
#Gets the parameters passed to the script
args <- commandArgs(trailingOnly = TRUE)
  gene <- args[1]
  path <- paste0(args[2], "/01-gene_trees")
  path2 <- paste0(args[2], "/02-rerooted_gene_trees")
  og1 <- args[3]
  og2 <- args[4]
  og3 <- args[5]
  og4 <- args[6]
  og5 <- args[7]
  Outgroup <- c(og1, og2, og3, og4, og5)
#2.Define the mad function:
mad <- function(unrooted_newick,output_mode){
  if(nargs()==0){ #print help message
    return(cat("Minimal Ancestor Deviation (MAD) rooting","","Usage: res <- mad(unrooted_newick,output_mode)","",
               "unrooted_newick: Unrooted tree string in newick format or a tree object of class 'phylo'","",
               "output_mode: Amount of information to return.", "  If 'newick' (default) only the rooted newick string",
               "  If 'stats' also a structure with the ambiguity index, clock cv, the minimum ancestor deviation and the number of roots",
               "  If 'full' also an unrooted tree object, the index of the root branch, the branch ancestor deviations and a rooted tree object",
               "","res: a list with the results containing one ('newick'), two ('stats') or six elements ('full')","",
               "Dependencies: 'ape' and 'phytools'","","Version: 1.1, 03-May-2017",sep="\n"))
  }
  if (!library('ape',logical.return = TRUE)){
    stop("'ape' package not found, please install it to run mad")
  }
  if (!library('phytools',logical.return = TRUE)){
    stop("'phytools' package not found, please install it to run mad")
  }
  t <- NA
  if(class(unrooted_newick)=="phylo"){ 
    t <- unrooted_newick
  }
  else{
    t <- read.tree(text=unrooted_newick)
  }
  if(is.rooted(t)){
    t<-unroot(t)
  }
  #t$node.label<-NULL #To allow parsing when identical OTUs are present
  if(!is.binary.tree(t)){
    warning("Input tree is not binary! Internal multifurcations will be converted to branches of length zero and identical OTUs will be collapsed!")
    t<-multi2di(t)
  }
  tf <- t$edge.length<0
  if(any(tf)){
    warning("Input tree contains negative branch lengths. They will be converted to zeros!")
    t$edge.length[tf]<-0
  }
  
  
  notu <- length(t$tip.label)
  nbranch <- dim(t$edge)[1]
  npairs <- notu*(notu-1)/2
  nodeids <- 1:(nbranch+1)
  otuids <- 1:notu
  dis <- dist.nodes(t) # phenetic distance. All nodes
  sdis <- dis[1:notu,1:notu] # phenetic distance. otus only
  
  #### Start recursion to collapse identical OTUs, if present.
  ii<-which(sdis==0,arr.ind=TRUE)
  k<-which(ii[,1]!=ii[,2])
  if(length(k)){
    r<-ii[k[1],1]
    c<-ii[k[1],2]
    vv<-c(paste('@#',t$tip.label[r],'@#',sep=""),paste('(',t$tip.label[r],':0,',t$tip.label[c],':0)',sep=""))
    st<-drop.tip(t,c) 
    st$tip.label[st$tip.label==t$tip.label[r]]<-vv[1]
    res<-mad(st,output_mode)
    if(is.list(res)){
      res[[1]]<-sub(vv[1],vv[2],res[[1]])
    }
    else{
      res<-sub(vv[1],vv[2],res)
    }
    return(res) #create the list 'res' to return the results 
  }
  #### End of recursion
  
  t2 <- t
  t2$edge.length <- rep(1,nbranch)
  disbr <- dist.nodes(t2) # split distance. All nodes
  sdisbr <- disbr[1:notu,1:notu] # split distance. otus only
  rho <- vector(mode = "numeric",length = nbranch) # Store position of the optimized root nodes (branch order as in the input tree)
  bad <- vector(mode = "numeric",length = nbranch) # Store branch ancestor deviations (branch order as in the input tree)
  i2p <- matrix(nrow = nbranch+1, ncol = notu)
  for (br in 1:nbranch){
    #collect the deviations associated with straddling otu pairs
    dij <- t$edge.length[br]
    if(dij==0){
      rho[br]<-NA
      bad[br]<-NA
      next
    }
    rbca <- numeric(npairs)
    i <- t$edge[br,1]
    j <- t$edge[br,2]
    sp <- dis[1:notu,i]<dis[1:notu,j] # otu split for 'br'
    dbc <- matrix(sdis[sp,!sp],nrow=sum(sp),ncol=sum(!sp))
    dbi <- replicate(dim(dbc)[2],dis[(1:notu)[sp],i]) 
    
    rho[br] <- sum((dbc-2*dbi)*dbc^-2)/(2*dij*sum(dbc^-2)) # optimized root node relative to 'i' node
    rho[br] <- min(max(0,rho[br]),1)
    dab <- dbi+(dij*rho[br])
    ndab <- length(dab)
    rbca[1:ndab] <- as.vector(2*dab/dbc-1)
    # collect the remaining deviations (non-traversing otus)
    bcsp <- rbind(sp,!sp)
    ij <- c(i,j)
    counter <- ndab
    for (w in c(1,2)){
      if(sum(bcsp[w,])>=2){
        disbrw <- disbr[,ij[w]]
        pairids <- otuids[bcsp[w,]]
        for (z in pairids){
          i2p[,z] <- disbr[z,]+disbrw==disbrw[z]
        }
        for (z in 1:(length(pairids)-1)){
          p1 <- pairids[z]
          disp1 <- dis[p1,]
          pan <- nodeids[i2p[,p1]]
          for (y in (z+1):length(pairids)){
            p2 <- pairids[y]
            pan1 <- pan[i2p[pan,p2]]
            an <- pan1[which.max(disbrw[pan1])]
            counter <- counter+1
            rbca[counter] <- 2*disp1[an]/disp1[p2]-1
          }
        }
      }
    }
    if(length(rbca)!=npairs){
      stop("Unexpected number of pairs. Report this error to ftria@ifam.uni-kiel.de")
    }
    bad[br] <- sqrt(mean(rbca^2)) # branch ancestor deviation
  }
  # Select the branch with the minum ancestor deviation and calculate the root ambiguity index
  jj <- sort(bad,index.return = TRUE)
  tf<-bad==jj$x[1]
  tf[is.na(tf)]<-FALSE
  nroots <- sum(tf)
  if (nroots>1){
    warning("More than one possible root position. Multiple newick strings printed")
  }
  madr <- which(tf) # Index of the mad root branch(es)
  rai <- jj$x[1]/jj$x[2] # Root ambiguity index
  badr <- bad[tf] # Branch ancestor deviations value for the root(s)
  #Root the tree object, calculate the clock CV and retrieve the newick string
  rt <- vector(mode = "list",nroots) # Rooted tree object
  ccv <- vector(mode = "numeric",nroots) # Clock CV
  rooted_newick <- vector(mode = "character",nroots)
  for (i in 1:length(madr)){
    pp <- rho[madr[i]]*t$edge.length[madr[i]]
    nn <- t$edge[madr[i],]
    rt[[i]] <- reroot(t,nn[2],pos = pp)
    rooted_newick[i] <- write.tree(rt[[i]])
    dd <- dis[1:notu,nn]
    sp <- dd[,1]<dd[,2]
    otu2root <- vector(mode="numeric",notu)
    otu2root[sp] <- dd[sp,1] + pp
    otu2root[!sp] <- dd[!sp,1] - pp
    ccv[i] <- 100*sd(otu2root)/mean(otu2root)
  }
  rooted_newick<-sub(')Root;',');',rooted_newick)
  # Output the result(s)
  if(missing(output_mode))
  {
    return(rooted_newick)
  }
  else{
    if(output_mode=='newick'){
      return(rooted_newick)
    }
    else if(output_mode=='stats'){ # Rooted newick and stats
      root_stats <- data.frame(ambiguity_index=rai,clock_cv=ccv,ancestor_deviation=badr,n_roots=nroots)
      return(list(rooted_newick,root_stats))
    }
    else if(output_mode=='full'){ #Rooted newick,stats, unrooted tree object, index of the branch root, ancestor deviations, rooted tree object
      root_stats <- data.frame(ambiguity_index=rai,clock_cv=ccv,ancestor_deviation=badr,n_roots=nroots)
      return(list(rooted_newick,root_stats,t,madr,bad,rt))
    }
    else{
      return(rooted_newick)
    }
  }
}
#3.reroot trees via MAD or phyx
tree <- read.tree(paste0(path, "/", gene, "/", "RAxML_bestTree.", gene, ".tre", sep=""))
Outgroup <- Outgroup[!is.null(Outgroup)]
if(sum(Outgroup %in% tree$tip.label) != 0){
  Outgroup <- Outgroup[Outgroup %in% tree$tip.label]
  # if outgroup present reroot use outgroup via phyx function 'pxrr'
  system(paste0("pxrr -t ", path, "/", gene, "/", "RAxML_bestTree.", gene, ".tre", " -r -g ", sample(Outgroup, size=1), " -o ", path2, "/", gene, "_rr.tre", sep=""))
  print(paste0("[HybSuite-INFO]:    Done with rerooting ", gene, " gene tree using phyx...", sep=""))
} else {
  # otherwise use MAD see [Tria et al. (2017)](https://www.nature.com/articles/s41559-017-0193)
  cat(mad(tree), file=paste0(path2, "/", gene, "_rr.tre", sep=""))
  print(paste0("[HybSuite-INFO]:    Done with rerooting ", gene, " gene tree using MAD...", sep=""))
}