source("ApplyProfileTestFuns.R")

p = gsub("package:", "", grep("package:", search(), val = TRUE))
structure(lapply(p, function(p) names(findFUNParam(p))), names = p)

names(findFUNParam())

 [1] ".kronecker"    ".mapply"       "apply"         "by"           
 [5] "by.data.frame" "by.default"    "eapply"        "kronecker"    
 [9] "lapply"        "mapply"        "match.fun"     "outer"        
[13] "sapply"        "sweep"         "tapply"        "vapply"       
[17] "Vectorize"    

Okay: apply, eapply, lapply, sapply, vapply.

TODO: mapply  (<Anonymous>)

TODO:  tapply, by, by.<class-method> (by.data.frame, by.default)
    outer, kronecker
    sweep

  match.fun, Vectorize - worth bothering with?
     The result of Vectorize may be as it has a function that calls mapply via do.call().

do.call()


f = function(n) lapply(rep(1, n), g)
g = function(n) lapply(1:n, h)
h = function(n) median(rnorm(1e6, n))
Rprof("prof"); invisible(lapply(1:10, f)); Rprof(NULL)
c('"f"', '"g"', '"h"') %in% rownames(summaryRprof("prof")$by.total)


f = function(n) lapply(rep(1, n), g)
g = function(n) sapply(1:n, h)
h = function(n) median(rnorm(1e6, n))
Rprof("prof"); invisible(lapply(1:10, f)); Rprof(NULL)

c('"f"', '"g"', '"h"') %in% rownames(summaryRprof("prof")$by.total)


The byte-compiler causes issues.
f = function(n) sapply(rep(1, n), h)
h = function(n) median(rnorm(1e6, n))
Rprof("prof"); invisible(lapply(1:10, f)); Rprof(NULL)

table(grepl("FUN", readLines("prof")))
c('"f"', '"h"') %in% rownames(summaryRprof("prof")$by.total)
h = function(n) median(rnorm(1e7, n))
Rprof("prof");invisible(sapply(1:3, h));Rprof(NULL)

For this, the call stack for FUN looks like
FUN(X[[i]], ...)
lapply(X = X, FUN = FUN, ...)
sapply(1:10, h)
NULL  (corresponding to R_TopLevel)


h = function(n) median(rnorm(1e7, n))
Rprof("prof");invisible(vapply(1:3, h, 1));Rprof(NULL)

rownames(summaryRprof("prof")$by.total)[1] == '"h"'

Call stack
FUN(X[[i]], ...)
vapply(1:3, h, 1)


h = function(n) median(rnorm(1e7, 10))
Rprof("prof");invisible(tapply(1:20, rep(c(1, 2), each = 10), h));Rprof(NULL)
rownames(summaryRprof("prof")$by.total)[1] == '"h"'

h = function(...) median(rnorm(1e7, 10))
e = list2env(list(a = 1, b = 2, c = 3, d = 4))
Rprof("prof");invisible(eapply(e, h));Rprof(NULL)

'"h"' %in% rownames(summaryRprof("prof")$by.total)



# These are not working yet.

h = function(...) median(rnorm(1e7, 10))
Rprof("prof");invisible(mapply(h, 1:4, 1:4));Rprof(NULL)


h = function(n) median(rnorm(1e7, 10))
Rprof("prof");invisible(by(1:20, rep(c(1, 2), each = 10), h));Rprof(NULL)

h = function(n) median(rnorm(1e7, 10))
Rprof("prof");invisible(aggregate(1:20, rep(c(1, 2), each = 10), h));Rprof(NULL)





