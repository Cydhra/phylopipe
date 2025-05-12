library(treestats)
args = commandArgs(trailingOnly=TRUE)

focal_trees <- ape::read.tree(file = args[1])

all_stats <- c()
for (i in seq_along(focal_trees)) {
   cat(paste(treestats::mean_pair_dist(focal_trees[[i]]), "\n"))
}