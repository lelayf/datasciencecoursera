## These functions essentially build a caching facility
## for inverse matrix computation
## See example usage in MatrixCaching.md (github will interpret the Markdown for you)

## This fuction creates a matrix caching structure based on a closure

makeCacheMatrix <- function(x = matrix()) {
    x_ <- NULL
    set <- function(y) {
      x <<- y
      x_ <<- NULL
    }
    get <- function() x
    setinv <- function(inv) x_ <<- inv
    getinv <- function() x_
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}


## This function actually takes a matrix caching object as an argument
## and returns the inverse of the underlying matrix

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
      x_ <- x$getinv()
      if(!is.null(x_)) {
        message("getting cached data")
        return(x_)
      }
      data <- x$get()
      x_ <- solve(data, ...)
      x$setinv(x_)
      x_
}

