\name{MaNoVe.wst}
\alias{MaNoVe.wst}
\title{Make Node Vector (using Coifman-Wickerhauser best-basis type algorithm) on nondecimated wavelet transform object}
\usage{
\method{MaNoVe}{wst}(wst, entropy=Shannon.entropy, verbose=FALSE,
	stopper=FALSE, alg="C", \dots)
}
\arguments{
\item{wst}{The wst object for which you wish to find the best basis for.}
\item{entropy}{The function used for computing the entropy of a vector}
\item{verbose}{Whether or not to print out informative messages}
\item{stopper}{Whether the computations are temporarily stopped after
	each packet. This can be useful in conjunction with the
	\code{verbose} argument so as to see computations proceed one
	packet at a time.}
\item{alg}{If "C" then fast compiled C code is used (in which case
	the \code{entropy} function is ignored and the C code uses
	an internal Shannon entropy. Otherwise, slower R code is used
	but an arbitrary \code{entropy} argument can be used}
\item{\dots}{Other arguments}
}
\description{
This method chooses a "best-basis" using the Coifman-Wickerhauser (1992)
algorithm applied to nondecimated wavelet transform,
\code{\link{wst.object}}, objects.
}
\details{
Description says all
}
\value{
A wavelet node vector object, of class \code{nv},
a basis description. This can
be fed into a basis inversion using, say, the function
\code{\link{InvBasis}}.
}
\seealso{
\code{\link{InvBasis}},
\code{\link{MaNoVe}},
\code{\link{MaNoVe.wp}},
\code{\link{Shannon.entropy}},
\code{\link{wst.object}},
\code{\link{wst}}
}
\examples{
#
# What follows is a simulated denoising example. We first create our
# "true" underlying signal, v. Then we add some noise to it with a signal
# to noise ratio of 6. Then we take the packet-ordered non-decimated wavelet
# transform and then threshold that.
#
# Then, to illustrate this function, we compute a "best-basis" node vector
# and use that to invert the packet-ordered NDWT using this basis. As a
# comparison we also use the Average Basis method
# (cf Coifman and Donoho, 1995). 
#
# NOTE: It is IMPORTANT to note that this example DOES not necessarily
# use an appropriate or good threshold or necessarily the right underlying
# wavelet. I am trying to show the general idea and please do not "quote" this
# example in literature saying that this is the way that WaveThresh (or
# any of the associated authors whose methods it attempts to implement)
# does it. Proper denoising requires a lot of care and thought.
#
#
# Here we go....
#
# Create an example vector (the Donoho and Johnstone heavisine function)
#
v <- DJ.EX()$heavi
#
# Add some noise with a SNR of 6
#
vnoise <- v + rnorm(length(v), 0, sd=sqrt(var(v))/6)
#
# Take packet-ordered non-decimated wavelet transform (note default wavelet
# used which might not be the best option for denoising performance).
#
vnwst <- wst(vnoise)
#
# Let's take a look at the wavelet coefficients of vnoise
#
\dontrun{plot(vnwst)}

#
# Wow! A huge number of coefficients, but mostly all noise.
#
#
# Threshold the resultant NDWT object.
# (Once again default arguments are used which are certainly not optimal).
#
vnwstT <- threshold(vnwst)
#
# Let's have a look at the thresholded wavelet coefficients
#
\dontrun{plot(vnwstT)}

#
# Ok, a lot of the coefficients have been removed as one would expect with
# universal thresholding
#
#
# Now select packets for a basis using a Coifman-Wickerhauser algorithm
#
vnnv <- MaNoVe(vnwstT)
#
# Let's have a look at which packets got selected
#
vnnv
# Level :  9  Action is  R (getpacket Index:  1 )
# Level :  8  Action is  L (getpacket Index:  2 )
# Level :  7  Action is  L (getpacket Index:  4 )
# Level :  6  Action is  L (getpacket Index:  8 )
# Level :  5  Action is  R (getpacket Index:  17 )
# Level :  4  Action is  L (getpacket Index:  34 )
# Level :  3  Action is  L (getpacket Index:  68 )
# Level :  2  Action is  R (getpacket Index:  137 )
# Level :  1  Action is  R (getpacket Index:  275 )
# There are  10  reconstruction steps
#
# So, its not the regular decimated wavelet transform!
#
# Let's invert the representation with respect to this basis defined by
# vnnv
#
vnwrIB <- InvBasis(vnwstT, vnnv)
#
# And also, for completeness let's do an Average Basis reconstruction.
#
vnwrAB <- AvBasis(vnwstT)
#
# Let's look at the Integrated Squared Error in each case.
#
sum( (v - vnwrIB)^2)
# [1] 386.2501
#
sum( (v - vnwrAB)^2)
# [1] 328.4520
#
# So, for this limited example the average basis method does better. Of course,
# for *your* simulation it could be the other way round. "Occasionally", the
# inverse basis method does better. When does this happen? A good question.
#
# Let's plot the reconstructions and also the original
#
\dontrun{plot(vnwrIB, type="l")}
\dontrun{lines(vnwrAB, lty=2)}
\dontrun{lines(v, lty=3)}

#
# The dotted line is the original. Neither reconstruction picks up the
# spikes in heavisine very well. The average basis method does track the
# original signal more closely though.
#
}
\author{G P Nason}
\keyword{smooth}
