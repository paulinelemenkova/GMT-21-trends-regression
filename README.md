# GMT Trends Regression — Trench Geomorphology Regression Modelling Scripts

A collection of over 20 GMT (Generic Mapping Tools) shell scripts for statistical trend modelling of bathymetric trench-profile data across the world's major ocean trenches. Stacked cross-section depth profiles are fitted with a sequence of regression models by weighted least squares, comparing polynomial orders and mixed polynomial-plus-Fourier models, with residual diagnostics, to characterise trench geomorphology. The scripts have been used to generate figures across the author's marine-geomorphological publications.

## What the scripts do

Each script builds a multi-panel regression figure, typically chaining:

- fitting successive regression models to the stacked profile with trend1d: linear (y = a + b*x), quadratic (y = a + b*x + c*x^2) and mixed polynomial + Fourier (adding cosine/sine terms)
- plotting each fitted model over the data (psxy)
- plotting the residuals of the highest-order model as a diagnostic panel
- plotting the median stacked profile with error bars and an envelope, annotated with the local tectonic setting (plates, trench, forearc)
- labelling model equations and a weighted-least-squares subtitle (pstext)
- adding the GMT logo (logo) and cleaning up temporary files (rm)
- exporting to raster (psconvert) at high resolution

## Data source

Stacked cross-section bathymetric profiles of each trench (see the companion cross-section profiling scripts), input as GMT table files (stackXX.txt, envXX.txt).

## File naming

Scripts follow GMT-21-trend-XX.sh, where XX is an ocean-trench tag (e.g. MAT = Middle America Trench, KKT = Kuril-Kamchatka Trench, IBT = Izu-Bonin Trench, JT = Japan Trench, NBT, MnT, RT, PT, KTT, SCT, YT). Suffixes n/s or -north/-south denote trench-segment variants.

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash)
- The stacked profile / envelope table(s) available locally

## Usage

Place the required profile tables in the working directory, then run:

    bash GMT-21-trend-MAT.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts support figures in the author's marine-geomorphological papers; please cite the specific article a given figure appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
