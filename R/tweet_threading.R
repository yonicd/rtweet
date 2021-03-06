#' @title Collect statuses contained in a thread
#' @description Return all statuses that are part of a thread
#' @param tw \code{\link[rtweet]{lookup_statuses}} output containing
#'  at least the last status in the thread
#' @param traverse character, direction to traverse from origin status in tw, 
#'  Default: c('backwards','forwards')
#' @param n numeric, timeline to fetch to start forwards traversing, Default: 10
#' @param verbose logical, Output to console status of traverse, Default: FALSE
#' @return \code{\link[rtweet]{lookup_statuses}} tibble
#' @details By default the function traverses first backwards from the origin status_id of the thread up to the root, 
#'  then checks if there are any child statuses that were posted after the origin status.
#' @examples 
#' tw <- lookup_statuses('1084143184664510470')
#' tw_thread <- tw%>%tweet_threading()
#' tw_thread
#' @seealso 
#'  \code{\link[rtweet]{lookup_statuses}}
#' @rdname tweet_threading
#' @export 
tweet_threading <- function(tw, traverse = c('backwards','forwards'), n = 10, verbose = FALSE){
  
  bad_args <- setdiff(traverse,c('backwards','forwards'))
  
  if(length(bad_args)>0){
    stop(sprintf("Invalid values used in `traverse`: %s, only 'backwards','forwards' may be used.",
                 paste0(sprintf("'%s'",bad_args),collapse = ',')
                 )
         )
  }
  
  for(i in traverse){
    cat('\n')
    .f <- get(sprintf('tweet_threading_%s',i),envir = asNamespace('rtweet'))
    tw <- tw%>%.f(n,verbose)
  }
  
  tw
}

tweet_threading_backwards <- function(tw, n = NULL, verbose = FALSE){
  
  last_found <- FALSE
  
  if(verbose){
    message("Initializing Backwards Traverse")
  }
  
  counter <- 0
  
  while(!last_found){
    
    nr         <- nrow(tw)
    last_found <- is.na(tw$reply_to_status_id[nr])
    
    tw_tail    <- lookup_statuses(tw$reply_to_status_id[nr])
    tw         <- rbind(tw,tw_tail)
    
    if(!last_found){
      
      counter <- counter + 1  
    
      if(verbose){
        
        cat('.')
        
        if(counter%%80 ==0 ){
         cat(sprintf(' %s \n',counter)) 
        }
        
      }
    }else{
      
      if(verbose){
        
        cat(sprintf(' %s statuses found \n',counter))
        
      }
      
    }
      
  }
  
  tw
}

tweet_threading_forwards <- function(tw, n = 10,verbose = FALSE){
  
  if(verbose){
    message(sprintf("Retrieving last %s statuses from @%s's timeline", n, tw$screen_name[1]))
  }
  
  timeline <- get_timeline(tw$screen_name[1], n = n)
  from_id <- tw$status_id[1]
  
  last_found <- FALSE
  
  if(verbose){
    message("Initializing Forwards Traverse")
  }
  
  counter <- 0
  
  while(!last_found){
    
    idx <- which(timeline$reply_to_status_id%in%from_id)
    last_found <- length(idx)==0
    
    tw <- rbind(timeline[idx,],tw)
    from_id <- timeline$status_id[idx]
    
    if(!last_found){
      
      counter <- counter + 1  
      
      if(verbose){
        
        cat('.')
        
        if(counter%%80 ==0 ){
          cat(sprintf(' %s \n',counter)) 
        }
        
      }
      
    }else{
      
      if(verbose){
        
        cat(sprintf(' %s statuses found \n',counter))
        
      }
      
    }
    
  }
  
  tw
}
