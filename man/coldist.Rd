% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coldist.R
\name{coldist}
\alias{coldist}
\title{Colour distances}
\usage{
coldist(
  modeldata,
  noise = c("neural", "quantum"),
  subset = NULL,
  achromatic = FALSE,
  qcatch = NULL,
  n = c(1, 2, 2, 4),
  weber = 0.1,
  weber.ref = "longest",
  weber.achro = 0.1
)
}
\arguments{
\item{modeldata}{(required) quantum catch colour data. Can be the result from
\code{\link[=vismodel]{vismodel()}} for noise-weighted Euclidean distances, or \code{\link[=colspace]{colspace()}} for
unweighted (typically) Euclidean distances. Data may also be independently
calculated quantum catches, in the form of a data frame with columns
representing photoreceptors.}

\item{noise}{how the noise will be calculated (ignored for \code{colspace}
objects):
\itemize{
\item \code{neural} (default): noise is proportional to the Weber fraction and is
independent of the intensity of the signal received (i.e. assumes bright
conditions).
\item \code{quantum}: noise is the sum of the neural noise and receptor noise, and
is thus proportional to the Weber fraction and inversely proportional to
the intensity of the signal received (the quantum catches).
Note that the \code{quantum} option will only work with objects of
class \code{vismodel}.
}}

\item{subset}{If only some of the comparisons should be returned, a character
vector of length 1 or 2 can be provided, indicating which samples are
desired. The subset vector must match the labels of the input samples, but
partial matching (and regular expressions) are supported.}

\item{achromatic}{Logical. If \code{TRUE}, last column of the data frame is used
to calculate the achromatic contrast, the form of which will depend on the
input data and will be indicated by a message during execution. For
noise-weighted distances, noise is based on the Weber fraction given by the
argument \code{weber.achro}.}

\item{qcatch}{if the object is of class \code{\link{vismodel}} or \code{\link{colspace}}, this
argument is ignored. If the object is a data frame of quantal catches from
another source, this argument is used to specify what type of quantum catch
is being used, so that the noise can be calculated accordingly: * \code{Qi}:
Quantum catch for each photoreceptor * \code{fi}: Quantum catch according to
Fechner's law (the signal of the receptor channel is proportional to the
logarithm of the quantum catch)}

\item{n}{photoreceptor densities for the cones used in visual modeling. must
have same length as number of columns (excluding achromatic receptor if
used; defaults to the Pekin robin \emph{Leiothrix lutea} densities:
\code{c(1,2,2,4)}). Ignored for \code{\link{colspace}} objects.}

\item{weber}{The Weber fraction(s) to be used (often also referred to as
receptor noise, or \emph{e}). The noise-to-signal ratio \code{v} is unknown, and
therefore must be calculated based on the empirically estimated Weber
fraction of one or (more rarely) all the cone classes. When noise is only
known for one receptor, as is typical, \code{v} is then applied to estimate the
Weber fraction of the other cones. By default, the value of 0.1 is used
(the empirically estimated value for the LWS cone from \emph{Leiothrix lutea}).
See Olsson et al. 2017 for a review of published values in the literature.
Ignored for \code{colspace} objects.}

\item{weber.ref}{the cone class used to obtain the empirical estimate of the
Weber fraction used for the \code{weber} argument, if a single value is
specified. By default, \code{n4} is used, representing the LWS cone for
\emph{Leiothrix lutea}. Ignored for \code{colspace} objects.}

\item{weber.achro}{the Weber fraction to be used to calculate achromatic
contrast, when \code{achromatic = TRUE}. Defaults to 0.1. Ignored for \code{colspace}
objects.}
}
\value{
A data frame containing up to 4 columns. The first two
(\verb{patch1, patch2}) refer to the two colors being contrasted; \code{dS} is the
chromatic contrast (delta S) and \code{dL} is the achromatic contrast (delta L).
Units of \code{dS} JND's in the receptor-noise model, unweighted Euclidean
distances in colorspace models, and Manhattan distances in the
colour-opponent-coding space. Units of \code{dL} vary, and are either simple
contrast, Weber contrast, or Michelson contrast, as indicated by the output
message.
}
\description{
Calculates colour distances. When data are the result of \code{\link[=vismodel]{vismodel()}}, it
applies the receptor-noise model of Vorobyev et al. (1998) to calculate
colour distances with noise based on relative photoreceptor densities. It
also accepts \code{\link[=colspace]{colspace()}} data in which case unweighted Euclidean distances,
CIE2000 distances (cielab and cielch only), or Manhattan distances (coc model only)
are returned.
}
\section{Note on previous versions}{
 Generic di- tri- and tetra-chromatic
\code{colspace} objects were previously passed through the receptor-noise
limited model to return noise-weighted Euclidean distances. This behaviour
has been amended, and generic spaces now return unweighted Euclidean
distances. Equivalent results to the former behaviour can be attained by
sending the results of \code{\link[=vismodel]{vismodel()}} directly to \code{\link[=coldist]{coldist()}} , as
previously, which also offers greater flexibility and reliability. Thus
\code{\link[=coldist]{coldist()}} now returns unweighted Euclidean distances for \code{colspace}
objects (with the exception of Manhattan distances for the coc space, and CIE2000,
distances for CIELab and CIELCh spaces), and noise-weighted Euclidean distances
for \code{vismodel} objects.
}

\examples{
\donttest{
# Dichromat
data(flowers)  
vis.flowers <- vismodel(flowers, visual = "canis", relative = FALSE)
didist.flowers <- coldist(vis.flowers, n = c(1, 2))

# Trichromat
vis.flowers <- vismodel(flowers, visual = "apis", relative = FALSE)
tridist.flowers <- coldist(vis.flowers, n = c(1, 2, 1))

# Trichromat, colour-hexagon model (euclidean distances)
vis.flowers <- vismodel(flowers,
  visual = "apis", qcatch = "Ei",
  relative = FALSE, vonkries = TRUE, achromatic = "l", bkg = "green"
)
hex.flowers <- colspace(vis.flowers, space = "hexagon")
hexdist.flowers <- coldist(hex.flowers)

# Trichromat, colour-opponent-coding model (manhattan distances)
vis.flowers <- vismodel(flowers, visual = "apis", qcatch = "Ei", relative = FALSE, vonkries = TRUE)
coc.flowers <- colspace(vis.flowers, space = "coc")
hexdist.flowers <- coldist(coc.flowers)

# Tetrachromat
data(sicalis)
vis.sicalis <- vismodel(sicalis, visual = "avg.uv", relative = FALSE)
tetradist.sicalis.n <- coldist(vis.sicalis)
}

}
\references{
Vorobyev, M., Osorio, D., Bennett, A., Marshall, N., & Cuthill,
I. (1998). Tetrachromacy, oil droplets and bird plumage colours. Journal Of
Comparative Physiology A-Neuroethology Sensory Neural And Behavioral
Physiology, 183(5), 621-633.

Hart, N. S. (2001). The visual ecology of avian photoreceptors.
Progress In Retinal And Eye Research, 20(5), 675-703.

Endler, J. A., & Mielke, P. (2005). Comparing entire colour
patterns as birds see them. Biological Journal Of The Linnean Society,
86(4), 405-431.

Olsson, P., Lind, O., & Kelber, A. (2015) Bird colour vision:
behavioural thresholds reveal receptor noise. Journal of Experimental
Biology, 218, 184-193.

Lind, O. (2016) Colour vision and background adaptation in a
passerine bird, the zebra finch (Taeniopygia guttata). Royal Society Open
Science, 3, 160383.

Olsson, P., Lind, O., & Kelber, A. (2017) Chromatic and
achromatic vision: parameter choice and limitations for reliable model
predictions. Behavioral Ecology, \doi{10.1093/beheco/arx133}
}
\author{
Thomas E. White \email{thomas.white026@gmail.com}

Rafael Maia \email{rm72@zips.uakron.edu}
}
