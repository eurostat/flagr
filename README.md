# flagr
A simple R package to derive flag for aggregates

## installation

```R
> devtools::install_github("eurostat/flagr")
```

## background
A flag is an attribute of a cell in a data set that provides additional qualitative information about the statistical value of that cell. They can indicate, for example, that a given value is estimated, confidential or represents a break in the time series.

Currently different sets of flags are in use in the [European Statistical System (ESS)](http://ec.europa.eu/eurostat/web/ess/about-us). Some domains uses the SDMX code list for [observation status](https://sdmx.org/wp-content/uploads/CL_OBS_STATUS_v2_1.docx) and [confidentiality status](https://sdmx.org/wp-content/uploads/CL_CONF_STATUS_1_2_2018.docx). Eurostat uses a simplified list of flags for [dissemination](http://ec.europa.eu/eurostat/data/database/information), and other domains applies different sets of flags defined in regulations or in other agreements.    

In most cases it is well defined how the flag shall be assigned to the individual values, but it is not straightforward what flag shall be propagated to an aggregated value like sum, average, quintiles, etc. For this reason this package ([*flagr*](https://github.com/eurostat/flagr)) was created to help users assign a flag to the aggregate based on the underlying flags and values.  

## content
The package contains a fictive test data set(`test_data`), a wrapping function (`propagate_flag`) calling the different methods and 3 methods (`flag_hierarchy`, `flag_frequency` and `flag_weighted`) to derive flags for aggregates.

* the `flag_hierarchy` method returns the flag which listed first in a given set of ordered flags,
* the `flag_frequency` method returns the most frequent flag for the aggregate,
* the `flag_weighted` method returns the flag which cumulative weight is the highest.

Detailed documentation of the functions is in the package or see the [vignette](vignettes/flagr_introduction.pdf) for more information.

## examples

```R
> library(tidyr)<br/>
> flags <- spread(test_data[, c(1:3)], key = time, value = flags)<br/>
>
> \#hierarchy method<br/>
> propagate_flag(flags[, c(2:ncol(flags))],"hierarchy","puebscd")<br/>
> propagate_flag(flags[, c(2:ncol(flags))],"hierarchy",c("b","c","d","e","p","s","u"))<br/>
>
> \#frequency method<br/>
> propagate_flag(flags[, c(2:ncol(flags))],"frequency")<br/>
>
> \#weighted method<br/>
> flags<-flags[, c(2:ncol(flags))]<br/>
> weights <- spread(test_data[, c(1, 3:4)], key = time, value = values)<br/>
> weights<-weights[, c(2:ncol(weights))]<br/>
>
> propagate_flag(flags,"weighted",flag_weights=weights,threshold=0.1)<br/>
```
