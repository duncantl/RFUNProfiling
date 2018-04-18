This is a very quick experiment/hack to address an issue in R's profiling results.
When R code calls lapply/sapply/vapply/eapply/..., calls are made to a functiona
whose names is FUN.
So 2 calls such as
```
lapply(x, f)
lapply(y, g)
```
will assign time to FUN, not f and g.
So we cannot tell how long each of these two functions should be charged with.

We can instrument other timing mechanisms.  See
[CallCounter](https://github.com/duncantl/CallCounter), specifically `genFunTimer()`. 
However this measures the elapsed time for a function. So we would like the profiler
to look for the symbol in a call to lapply and related functions and use that instead of FUN.

The file eval.c here is a modified version of the file src/main/eval.c from the R-3.4.4 release.

+ Download the R source
+ copy eval.c from here to src/main/eval.c in the R source
+ configure the R source
+ make

Then use that version of R.


# Does Handle

+ apply, eapply, lapply, sapply, vapply.

# TODO

+ This does not match parameters in calls to find the FUN, so it just looks
  in the position corresponding to the function definition/formals.
   + We can fix this later.

+ This doesn't currently handle 
   + mapply
   + tapply, by, by.<class-method> (i.e., by.data.frame, by.default)
   + outer, kronecker
   + sweepby, aggregate

+ Doesn't handle match.fun, Vectorize and probably won't (at least match.fun)

+ Functions from other packages.
