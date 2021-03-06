% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/friends.R
\name{get_friends}
\alias{get_friends}
\title{Get user IDs of accounts followed by target user(s).}
\usage{
get_friends(
  users,
  n = 5000,
  retryonratelimit = FALSE,
  page = "-1",
  parse = TRUE,
  verbose = TRUE,
  token = NULL
)
}
\arguments{
\item{users}{Screen name or user ID of target user from which the
user IDs of friends (accounts followed BY target user) will be
retrieved.}

\item{n}{Number of friends (user IDs) to return. Defaults to 5,000,
which is the maximum returned by a single API call. Users are
limited to 15 of these requests per 15 minutes. Twitter limits
the number of friends a user can have to 5,000. To follow more
than 5,000 accounts (to have more than 5 thousand "friends")
accounts must meet certain requirements (e.g., a certain ratio of
followers to friends). Consequently, the vast majority of users
follow fewer than five thousand accounts. This function has been
oriented accordingly (i.e., it assumes the maximum value of n is
5000). To return more than 5,000 friends for a single user, call
this function multiple times with requests after the first using
the \code{page} parameter.}

\item{retryonratelimit}{If you'd like to retrieve 5,000 or fewer
friends for more than 15 target users, then set
\code{retryonratelimit = TRUE} and this function will use
base \code{Sys.sleep} until rate limits reset and the desired
number of friend networks is retrieved. This defaults to
FALSE. See details for more info regarding possible issues with
timing misfires.}

\item{page}{Default \code{page = -1} specifies first page of JSON
results. Other pages specified via cursor values supplied by
Twitter API response object. This is only relevant if a user has
over 5000 friends (follows more than 5000 accounts).}

\item{parse}{Logical, indicating whether to return parsed vector or
nested list object. By default, \code{parse = TRUE}
saves you the time [and frustrations] associated with
disentangling the Twitter API return objects.}

\item{verbose}{Logical indicating whether or not to include output
messages. Defaults to TRUE, which includes printing a success message
for each inputted user.}

\item{token}{Every user should have their own Oauth (Twitter API) token. By
default \code{token = NULL} this function looks for the path to a saved
Twitter token via environment variables (which is what `create_token()`
sets up by default during initial token creation). For instruction on how
to create a Twitter token see the tokens vignette, i.e.,
`vignettes("auth", "rtweet")` or see \code{?tokens}.}
}
\value{
A tibble data frame with two columns, "user" for name or ID of target
  user and "user_id" for follower IDs.
}
\description{
Returns a list of user IDs for the accounts following BY one or
more specified users. To return the friends of more than 15 users
in a single call (the rate limit maximum), set "retryonratelimit"
to TRUE.
}
\details{
When \code{retryonratelimit = TRUE} this function internally
  makes a rate limit API call to get information on (a) the number of requests
  remaining and (b) the amount of time until the rate limit resets. So, in
  theory, the sleep call should only be called once between waves of data
  collection. However, as a fail safe, if a system's time is calibrated such
  that it expires before the rate limit reset, or if, in another session, the
  user dips into the rate limit, then this function will wait (use Sys.sleep
  for a second time) until the next rate limit reset. Users should monitor
  and test this before making especially large calls as any systematic issues
  could create sizable inefficiencies.

  At this time, results are ordered with the most recent following first —
  however, this ordering is subject to unannounced change and eventual
  consistency issues. While this remains true it is possible to iteratively build
  friends lists for a user over time.
}
\examples{

\dontrun{

## get user ids of accounts followed by Donald Trump
(djt <- get_friends("realDonaldTrump"))

## get user ids of accounts followed by (friends) KFC, Trump, and Nate Silver.
(fds <- get_friends(c("kfc", "jack", "NateSilver538")))

}

}
\seealso{
\url{https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference/get-friends-ids}

Other ids: 
\code{\link{get_followers}()},
\code{\link{next_cursor}()}
}
\concept{ids}
