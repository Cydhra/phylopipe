library(treestats)
args = commandArgs(trailingOnly=TRUE)

method <- args[1]
focal_trees <- ape::read.tree(file = args[2])

all_stats <- c()
for (i in seq_along(focal_trees)) {
    args <- list(focal_trees[[i]])
    result <- do.call(getFromNamespace(method, "treestats"), args)
    cat(paste(result, "\n"))
}