
# rfishbase <img src="man/figures/logo.svg" align="right" alt="" width="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/ropensci/rfishbase/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/rfishbase/actions/workflows/R-CMD-check.yaml)
[![Onboarding](https://badges.ropensci.org/137_status.svg)](https://github.com/ropensci/software-review/issues/137)
[![CRAN
status](https://www.r-pkg.org/badges/version/rfishbase)](https://cran.r-project.org/package=rfishbase)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rfishbase)](https://github.com/r-hub/cranlogs.app)
<!-- badges: end -->

Welcome to `rfishbase 4`. This is the fourth rewrite of the original
`rfishbase` package described in [Boettiger et
al. (2012)](https://doi.org/10.1111/j.1095-8649.2012.03464.x).

- `rfishbase 1.0` relied on parsing of XML pages served directly from
  Fishbase.org.  
- `rfishbase 2.0` relied on calls to a ruby-based API, `fishbaseapi`,
  that provided access to SQL snapshots of about 20 of the more popular
  tables in FishBase or SeaLifeBase.
- `rfishbase 3.0` side-stepped the API by making queries which directly
  downloaded compressed csv tables from a static web host. This
  substantially improved performance a reliability, particularly for
  large queries. The release largely remained backwards compatible with
  2.0, and added more tables.
- `rfishbase 4.0` extends the static model and interface. Static tables
  are distributed in parquet and accessed through a provenance-based
  identifier. While old functions are retained, a new interface is
  introduced to provide easy access to all fishbase tables.

We welcome any feedback, issues or questions that users may encounter
through our issues tracker on GitHub:
<https://github.com/ropensci/rfishbase/issues>

## Installation

``` r
remotes::install_github("ropensci/rfishbase")
```

``` r
library("rfishbase")
library("dplyr") # convenient but not required
```

## Getting started

## Generic table interface

All fishbase tables can be accessed by name using the `fb_tbl()`
function:

``` r
fb_tbl("ecosystem")
```

    # A tibble: 158,644 × 18
       autoctr E_CODE EcosystemRefno Speccode Stockcode Status CurrentPresence
         <int>  <int>          <int>    <int>     <int> <chr>  <chr>          
     1       1      1          50628      549       565 native Present        
     2       2      1            189      552       568 native Present        
     3       3      1            189      554       570 native Present        
     4       4      1          79732      873       889 native Present        
     5       5      1           5217      948       964 native Present        
     6       7      1          39852      956       972 native Present        
     7       8      1          39852      957       973 native Present        
     8       9      1          39852      958       974 native Present        
     9      10      1            188     1526      1719 native Present        
    10      11      1            188     1626      1819 native Present        
    # ℹ 158,634 more rows
    # ℹ 11 more variables: Abundance <chr>, LifeStage <chr>, Remarks <chr>,
    #   Entered <int>, Dateentered <dttm>, Modified <int>, Datemodified <dttm>,
    #   Expert <int>, Datechecked <dttm>, WebURL <chr>, TS <dttm>

You can see all the tables using `fb_tables()` to see a list of all the
table names (specify `sealifebase` if desired). Careful, there are a lot
of them! The fishbase databases have grown a lot in the decades, and
were not intended to be used directly by most end-users, so you may have
considerable work to determine what’s what. Keep in mind that many
variables can be estimated in different ways (e.g. trophic level), and
thus may report different values in different tables. Also note that
species is name (or SpecCode) is not always the primary key for a table
– many tables are specific to stocks or even individual samples, and
some tables are reference lists that are not species focused at all, but
meant to be joined to other tables (`faoareas`, etc). Compare tables
against what you see on fishbase.org, or ask on our issues forum for
advice!

``` r
fish <- c("Oreochromis niloticus", "Salmo trutta")

fb_tbl("species") %>% 
  mutate(sci_name = paste(Genus, Species)) %>%
  filter(sci_name %in% fish) %>% 
  select(sci_name, FBname, Length)
```

    # A tibble: 2 × 3
      sci_name              FBname       Length
      <chr>                 <chr>         <dbl>
    1 Oreochromis niloticus Nile tilapia     60
    2 Salmo trutta          Sea trout       140

## SeaLifeBase

SeaLifeBase.org is maintained by the same organization and largely
parallels the database structure of Fishbase. As such, almost all
`rfishbase` functions can instead be instructed to address the

``` r
fb_tbl("species", "sealifebase")
```

    # A tibble: 103,290 × 109
       SpecCode Genus   Species Author SpeciesRefNo FBname FamCode Subfamily GenCode
          <int> <chr>   <chr>   <chr>         <int> <chr>    <int> <chr>       <int>
     1    10215 Aatola… schioe… (Mier…         3113 <NA>       521 <NA>         9254
     2    90398 Aatola… spring… Keabl…         3113 <NA>       521 <NA>         9254
     3   142030 Abaren… affinis (Ashw…        85340 <NA>       238 <NA>         9255
     4    38944 Abaren… clapar… (Levi…        85340 <NA>       238 <NA>         9255
     5    38945 Abaren… pacifi… unspe…        93817 Pacif…     238 <NA>         9255
     6    38946 Abaren… pusilla unspe…           19 <NA>       238 <NA>         9255
     7    38948 Abaren… vagabu… unspe…           19 <NA>       238 <NA>         9255
     8    28719 Abasia  pseudo… Wilso…           19 <NA>       827 <NA>         9256
     9   130412 Abathe… fissum  (Hoek…        81749 <NA>       771 <NA>         9257
    10    32026 Abathe… korean… (Hiro…           19 <NA>       771 <NA>         9257
    # ℹ 103,280 more rows
    # ℹ 100 more variables: TaxIssue <int>, Remark <chr>, PicPreferredName <chr>,
    #   PicPreferredNameM <chr>, PicPreferredNameF <chr>, PicPreferredNameJ <chr>,
    #   Source <chr>, AuthorRef <int>, SubGenCode <int>, Fresh <int>, Brack <int>,
    #   Saltwater <int>, Land <int>, BodyShapeI <chr>, DemersPelag <chr>,
    #   AnaCat <chr>, MigratRef <int>, DepthRangeShallow <int>,
    #   DepthRangeDeep <int>, DepthRangeRef <int>, DepthRangeComShallow <int>, …

## Versions and importing all tables

By default, tables are downloaded the first time they are used.
`rfishbase` defaults to download the latest available snapshot; be aware
that the most recent snapshot may be months behind the latest data on
fishbase.org. Check available releases:

``` r
available_releases()
```

    [1] "23.05" "23.01" "21.06" "19.04"

## Low-memory environments

If you have very limited RAM (e.g. \<= 1 GB available) it may be helpful
to use `fishbase` tables in remote form by setting `collect = FALSE`.
This allows the tables to remain on disk, while the user is still able
to use almost all `dplyr` functions (see the `dbplyr` vignette). Once
the table is appropriately subset, the user will need to call
`dplyr::collect()` to use generic non-dplyr functions, such as plotting
commands.

``` r
fb_tbl("occurrence")
```

    # A tibble: 1,097,303 × 106
       catnum2 OccurrenceRefNo SpecCode Syncode Stockcode GenusCol       SpeciesCol 
         <int>           <int>    <int>   <int>     <int> <chr>          <chr>      
     1   34424           36653      227   22902       241 "Megalops"     "cyprinoid…
     2   95154           45880       NA      NA        NA ""             ""         
     3   97606           45880       NA      NA        NA ""             ""         
     4  100025           45880     5520   25676      5809 "Johnius"      "belangeri…
     5   98993           45880     5676   16650      5969 "Chromis"      "retrofasc…
     6   99316           45880      454   23112       468 "Drepane"      "punctata" 
     7   99676           45880     5388  145485      5647 "Gymnothorax"  "boschi"   
     8   99843           45880    16813  119925     15264 "Hemiramphus"  "balinensi…
     9  100607           45880     8288   59635      8601 "Ostracion"    "rhinorhyn…
    10  101529           45880       NA      NA        NA "Scomberoides" "toloo-par…
    # ℹ 1,097,293 more rows
    # ℹ 99 more variables: ColName <chr>, PicName <chr>, CatNum <chr>, URL <chr>,
    #   Station <chr>, Cruise <chr>, Gazetteer <chr>, LocalityType <chr>,
    #   WaterDepthMin <dbl>, WaterDepthMax <dbl>, AltitudeMin <int>,
    #   AltitudeMax <int>, LatitudeDeg <int>, LatitudeMin <dbl>, NorthSouth <chr>,
    #   LatitudeDec <dbl>, LongitudeDeg <int>, LongitudeMIn <dbl>, EastWest <chr>,
    #   LongitudeDec <dbl>, Accuracy <chr>, Salinity <chr>, LatitudeTo <dbl>, …

## Local copy

Set the option “rfishbase_local_db” = TRUE to create a local copy,
otherwise will use a remote copy. Local copy will get better performance
after initial import, but may experience conflicts when `duckdb` is
upgraded or when multiple sessions attempt to access the directory.
Remove the default storage directory (given by `db_dir()`) after
upgrading duckdb if using a local copy.

``` r
options("rfishbase_local_db" = TRUE)
db_disconnect() # close previous remote connection

conn <- fb_conn()
conn
```

    <duckdb_connection 9fb20 driver=<duckdb_driver b4670 dbdir='/home/cboettig/.local/share/R/rfishbase/fishbase_23.05' read_only=FALSE bigint=numeric>>

Users can trigger a one-time download of all fishbase tables (or a list
of desired tables) using `fb_import()`. This will ensure later use of
any function can operate smoothly even when no internet connection is
available. Any table already downloaded will not be re-downloaded.
(Note: `fb_import()` also returns a remote duckdb database connection to
the tables, for users who prefer to work with the remote data objects.)

``` r
fb_import()
```

## Interactive RStudio pane

RStudio users can also browse all fishbase tables interactively in the
RStudio connection browser by using the function `fisbase_pane()`. Note
that this function will first download a complete set of the fishbase
tables.

## Backwards compatibility

`rfishbase` 4.0 tries to maintain as much backwards compatibility as
possible with rfishbase 3.0. Because parquet preserves native data
types, some encoded types may differ from earlier versions. As before,
these are not always the native type – e.g. fishbase encodes some
boolean (logical TRUE/FALSE) values as integer (-1, 0) or character
types. Use `as.logical()` to coerce into the appropriate type in that
case.

Toggling between fishbase and sealifebase servers using an environmental
variable, `FISHBASE_API`, is now deprecated.

Note that fishbase will store downloaded files by hash in the app
directory, given by `db_dir()`. The default location can be set by
configuring the desired path in the environmental variable,
`FISHBASE_HOME`.

------------------------------------------------------------------------

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
