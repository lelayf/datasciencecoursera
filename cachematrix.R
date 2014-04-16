## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

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


## Write a short comment describing this function

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

