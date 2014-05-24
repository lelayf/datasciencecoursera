Matrix Caching
========================================================

This simply demonstrates the use of caching helpers for the 2nd R programming assignment.


```r
source("cachematrix.R")
myMat = rbind(c(1, -1/4), c(-1/4, 1))
class(myMat)
```

```
## [1] "matrix"
```

```r
myMatCache <- makeCacheMatrix(myMat)
# first call, inverse matrix is computed and not pulled from cache
cacheSolve(myMatCache)
```

```
##        [,1]   [,2]
## [1,] 1.0667 0.2667
## [2,] 0.2667 1.0667
```

```r
# second call, inverse matrix is pulled from cache
cacheSolve(myMatCache)
```

```
## getting cached data
```

```
##        [,1]   [,2]
## [1,] 1.0667 0.2667
## [2,] 0.2667 1.0667
```



