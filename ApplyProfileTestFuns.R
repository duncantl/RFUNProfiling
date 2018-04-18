#objs = ls("package:base")
findFUNParam =
function(pkg = "base", objs = ls(fullPkg, all = TRUE), fullPkg = paste0("package:", pkg))
{
    isFun = sapply(objs, function(x) { f = get(x, fullPkg); is.function(f)})
    funs = structure(lapply(objs[isFun], function(f) get(f, fullPkg)), names = objs[isFun])
    hasFUN = vapply(funs, function(x) "FUN" %in% names(formals(x)), TRUE)
    funs[hasFUN]
}
