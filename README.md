
# rfishbase <img src="man/figures/logo.svg" align="right" alt="" width="120" />

[![R-check](https://github.com/ropensci/rfishbase/workflows/R-check/badge.svg)](https://github.com/ropensci/rfishbase/actions?query=workflow%3AR-check)
[![cran
checks](https://cranchecks.info/badges/worst/rfishbase)](https://cranchecks.info/pkgs/rfishbase)
[![Coverage
status](https://codecov.io/gh/ropensci/rfishbase/branch/master/graph/badge.svg)](https://codecov.io/github/ropensci/rfishbase?branch=master)
[![Onboarding](https://badges.ropensci.org/137_status.svg)](https://github.com/ropensci/software-review/issues/137)
[![CRAN
status](https://www.r-pkg.org/badges/version/rfishbase)](https://cran.r-project.org/package=rfishbase)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rfishbase)](https://github.com/r-hub/cranlogs.app)

Welcome to `rfishbase 3`. This package is the third rewrite of the
original `rfishbase` package described in [Boettiger et
al. (2012)](https://doi.org/10.1111/j.1095-8649.2012.03464.x).

`rfishbase` 3 queries pre-compressed tables from a static server and
employs local caching (through memoization) to provide much greater
performance and stability, particularly for dealing with large queries
involving 10s of thousands of species. The user is never expected to
deal with pagination or curl headers and timeouts.

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

FishBase (`https://fishbase.org`) makes it relatively easy to look up a
lot of information on most known species of fish. However, looking up a
single bit of data, such as the estimated trophic level, for many
different species becomes tedious very soon. This is a common reason for
using `rfishbase`. As such, our first step is to assemble a good list of
species we are interested in.

### Building a species list

Almost all functions in `rfishbase` take a list (character vector) of
species scientific names, for example:

``` r
fish <- c("Oreochromis niloticus", "Salmo trutta")
```

You can also read in a list of names from any existing data you are
working with. When providing your own species list, you should always
begin by validating the names. Taxonomy is a moving target, and this
well help align the scientific names you are using with the names used
by FishBase, and alert you to any potential issues:

``` r
fish <- validate_names(c("Oreochromis niloticus", "Salmo trutta"))
```

Another typical use case is in wanting to collect information about all
species in a particular taxonomic group, such as a Genus, Family or
Order. The function `species_list` recognizes six taxonomic levels, and
can help you generate a list of names of all species in a given group:

``` r
fish <- species_list(Genus = "Labroides")
fish
```

    [1] "Labroides bicolor"       "Labroides dimidiatus"   
    [3] "Labroides pectoralis"    "Labroides phthirophagus"
    [5] "Labroides rubrolabiatus"

`rfishbase` also recognizes common names. When a common name refers to
multiple species, all matching species are returned:

``` r
trout <- common_to_sci("trout")
```

    Importing /home/cboettig/.local/share/R/rfishbase/comnames_fb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 324211 Columns: 35

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr (34): autoctr, ComName, Transliteration, StockCode, SpecCode, C_Code, La...
    dbl  (1): ComNamesRefNo


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 12.5654 secs)

``` r
trout
```

    # A tibble: 296 × 4
       Species                   ComName              Language SpecCode
       <chr>                     <chr>                <chr>    <chr>   
     1 Salmo obtusirostris       Adriatic trout       English  6210    
     2 Schizothorax richardsonii Alawan snowtrout     English  8705    
     3 Schizopyge niger          Alghad snowtrout     English  24454   
     4 Salvelinus fontinalis     American brook trout English  246     
     5 Salmo trutta              Amu-Darya trout      English  238     
     6 Salmo kottelati           Antalya trout        English  67602   
     7 Oncorhynchus apache       Apache Trout         English  2687    
     8 Oncorhynchus apache       Apache trout         English  2687    
     9 Plectropomus areolatus    Apricot trout        English  6082    
    10 Salmo trutta              Aral Sea Trout       English  238     
    # … with 286 more rows

Note that there is no need to validate names coming from `common_to_sci`
or `species_list`, as these will always return valid names.

### Getting data

With a species list in place, we are ready to query fishbase for data.
Note that if you have a very long list of species, it is always a good
idea to try out your intended functions with a subset of that list first
to make sure everything is working.

The `species()` function returns a table containing much (but not all)
of the information found on the summary or homepage for a species on
FishBase. `rfishbase` functions always return
[tidy](https://doi.org/10.18637/jss.v059.i10) data tables: rows are
observations (e.g. a species, individual samples from a species) and
columns are variables (fields).

``` r
species(trout$Species)
```

    # A tibble: 296 × 101
       SpecCode Species                   Genus SpeciesRefNo Author FBname PicPreferredName
       <chr>    <chr>                     <chr>        <dbl> <chr>  <chr>  <chr>           
     1 6210     Salmo obtusirostris       Salmo        59043 (Heck… Adria… Saobt_u0.jpg    
     2 8705     Schizothorax richardsonii Schi…         4832 (Gray… Snowt… Scric_u1.jpg    
     3 24454    Schizopyge niger          Schi…         4832 (Heck… Algha… <NA>            
     4 246      Salvelinus fontinalis     Salv…        86798 (Mitc… Brook… Safon_u4.jpg    
     5 238      Salmo trutta              Salmo         4779 Linna… Sea t… Satru_u2.jpg    
     6 67602    Salmo kottelati           Salmo        99540 Turan… Antal… Sakot_m0.jpg    
     7 2687     Oncorhynchus apache       Onco…         5723 (Mill… Apach… Onapa_u0.jpg    
     8 2687     Oncorhynchus apache       Onco…         5723 (Mill… Apach… Onapa_u0.jpg    
     9 6082     Plectropomus areolatus    Plec…         5222 (Rüpp… Squar… Plare_u4.jpg    
    10 238      Salmo trutta              Salmo         4779 Linna… Sea t… Satru_u2.jpg    
    # … with 286 more rows, and 94 more variables: PicPreferredNameM <chr>,
    #   PicPreferredNameF <chr>, PicPreferredNameJ <chr>, FamCode <dbl>,
    #   Subfamily <chr>, GenCode <dbl>, SubGenCode <dbl>, BodyShapeI <chr>,
    #   Source <chr>, AuthorRef <chr>, Remark <chr>, TaxIssue <chr>, Fresh <dbl>,
    #   Brack <dbl>, Saltwater <dbl>, DemersPelag <chr>, Amphibious <chr>,
    #   AmphibiousRef <int>, AnaCat <chr>, MigratRef <dbl>,
    #   DepthRangeShallow <chr>, DepthRangeDeep <dbl>, DepthRangeRef <dbl>, …

Most tables contain many fields. To avoid overly cluttering the screen,
`rfishbase` displays tables as “tibbles” from the `dplyr` package. These
act just like the familiar `data.frames` of base R except that they
print to the screen in a more tidy fashion. Note that columns that
cannot fit easily in the display are summarized below the table. This
gives us an easy way to see what fields are available in a given table.

Most `rfishbase` functions will let the user subset these fields by
listing them in the `fields` argument, for instance:

``` r
dat <- species(trout$Species, fields=c("Species", "PriceCateg", "Vulnerability"))
dat
```

    # A tibble: 296 × 3
       Species                   PriceCateg Vulnerability
       <chr>                     <chr>              <dbl>
     1 Salmo obtusirostris       very high           47.0
     2 Schizothorax richardsonii unknown             34.8
     3 Schizopyge niger          unknown             46.8
     4 Salvelinus fontinalis     very high           43.4
     5 Salmo trutta              very high           56.3
     6 Salmo kottelati           <NA>                33.1
     7 Oncorhynchus apache       very high           52.3
     8 Oncorhynchus apache       very high           52.3
     9 Plectropomus areolatus    very high           30.3
    10 Salmo trutta              very high           56.3
    # … with 286 more rows

Alternatively, just subset the table using the standard column selection
in base R (`[[`) or `dplyr::select`.

### FishBase Docs: Discovering data

Unfortunately identifying what fields come from which tables is often a
challenge. Each summary page on FishBase includes a list of additional
tables with more information about species ecology, diet, occurrences,
and many other things. `rfishbase` provides functions that correspond to
most of these tables.

Because `rfishbase` accesses the back end database, it does not always
line up with the web display. Frequently `rfishbase` functions will
return more information than is available on the web versions of the
these tables. Some information found on the summary homepage for a
species is not available from the `species` summary function, but must
be extracted from a different table. For instance, the species
`Resilience` information is not one of the fields in the `species`
summary table, despite appearing on the species homepage of FishBase. To
discover which table this information is in, we can use the special
`rfishbase` function `list_fields`, which will list all tables with a
field matching the query string:

``` r
list_fields("Resilience")
```

    # A tibble: 1 × 1
      table 
      <chr> 
    1 stocks

This shows us that this information appears on the `stocks` table. We
can then request this data from the stocks table:

``` r
stocks(trout$Species, fields=c("Species", "Resilience", "StockDefs"))
```

    Importing /home/cboettig/.local/share/R/rfishbase/stocks_fb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 35322 Columns: 119

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (50): StockCode, SpecCode, SynOC, StockDefs, StockDefsGeneral, Level, L...
    dbl  (67): StocksRefNo, Easternmost, BoundingRef, BoundingMethod, TempMin, T...
    dttm  (2): DateModified, DateChecked


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 2.653803 secs)

    # A tibble: 397 × 3
       Species                   Resilience StockDefs                               
       <chr>                     <chr>      <chr>                                   
     1 Salmo obtusirostris       Medium     Europe:  Adriatic basin in Krka, Jardo,…
     2 Schizothorax richardsonii Medium     Asia:  Himalayan region of India, Sikki…
     3 Schizopyge niger          Medium     Asia:  Kashmir Valley in India and Azad…
     4 Salvelinus fontinalis     Medium     North America:  native to most of easte…
     5 Salmo trutta              <NA>       <i>Salmo trutta aralensis</i>:  Asia:  …
     6 Salmo trutta              <NA>       <i>Salmo trutta aralensis</i>:  Asia:  …
     7 Salmo trutta              Medium     <i>Salmo trutta fario</i>:  Northeast  …
     8 Salmo trutta              <NA>       <i>Salmo trutta lacustris</i>           
     9 Salmo trutta              <NA>       <i>Salmo trutta oxianus</i>             
    10 Salmo trutta              <NA>       Baltic Sea (ICES subdivisions 22-32)    
    # … with 387 more rows

## Version stability

`rfishbase` relies on periodic cache releases – the database release
`17.07` dates to a release in July 2017. Set the version of FishBase you
wish to access by setting the environmental variable:

``` r
options(FISHBASE_VERSION="19.04")
```

Note that the same version number applies to both the `fishbase` and
`sealifebase` data. Stay tuned for new releases.

## SeaLifeBase

SeaLifeBase.org is maintained by the same organization and largely
parallels the database structure of Fishbase. As such, almost all
`rfishbase` functions can instead be instructed to address the

We can begin by getting the taxa table for sealifebase:

``` r
sealife <- load_taxa(server="sealifebase")
```

    Importing /home/cboettig/.local/share/R/rfishbase/species_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 96814 Columns: 109

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (63): SpecCode, Genus, Species, Author, SpeciesRefNo, FBname, Subfamily...
    dbl  (40): FamCode, TaxIssue, AuthorRef, SubGenCode, Brack, Land, MigratRef,...
    lgl   (3): Pic, PictureFemale, Profile
    dttm  (2): DateEntered, TS
    date  (1): E_DateAppend


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 9.136215 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/genera_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 27798 Columns: 60

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (26): GenCode, GEN_NAME, AuthorYear, SUBGEN, CommonName, AUTH, QUALIFIC...
    dbl  (12): GenusRefno, Famcode, Syncode, LineageID, CurrentGenusID, Marine, ...
    lgl  (17): FB_NbSpp, DspinesMin, DspinesMax, DsoftRaysMin, DsoftRaysMax, Tot...
    dttm  (5): STAT_CODE1, Dateentered, Datemodified, Datechecked, TS


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 1.100098 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/families_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 4564 Columns: 79

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (21): FamCode, Family, AuthorYear, Qualification, CommonName, SuperFami...
    dbl  (14): FamiliesRefNo, Fossil, Ordnum, Genera, Species, Brackish, Freshwa...
    lgl  (41): SwimMode, Activity, PeriodRange, Period, EpochRange, Epoch, LarvP...
    dttm  (3): DateEntered, DateModified, DateChecked


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 0.316843 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/orders_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 743 Columns: 45

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr   (6): Order, CommonName, Class, Phylum, Remark, CommonName_German
    dbl  (11): OrderRefNo, Ordnum, ClassNum, PhylumNum, Marine, Brackish, Freshw...
    lgl  (26): EtymologyOrder, Class_Russian, EtymologyClass, SisterOrder, ComAn...
    dttm  (2): DateEntered, DateModified


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 0.09213448 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/classes_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 176 Columns: 9

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr (5): Class, CommonName, Phylum, Remarks, WaterSalinity
    dbl (2): ClassNum, PhylumNum
    lgl (2): SortNo, TS


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 0.071419 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/phylums_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 110 Columns: 10

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr (3): Kingdom, Phylum, CommonName
    dbl (5): PhylumId, Valid, ValidPhylumId, ParentPhylumId, PhylumRefNo
    lgl (2): ParentKingdomId, ParentKingdomInfId


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 0.04270363 secs)

    Importing /home/cboettig/.local/share/R/rfishbase/phylumclass_slb_2104.tsv.bz2 in 1000000 line chunks:

    Rows: 238 Columns: 2

    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr (2): Phylum, Class


    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

        ...Done! (in 0.03282166 secs)

(Note: running `load_taxa()` at the beginning of any session, for either
fishbase or sealifebase is a good way to “warm up” rfishbase by loading
in taxonomic data it will need. This information is cached throughout
your session and will make all subsequent commands run faster. But no
worries if you skip this step, `rfishbase` will peform it for you on the
first time it is needed, and will cache these results thereafter.)

Let’s look at some Gastropods:

``` r
sealife %>% filter(Class == "Gastropoda")
```

    # A tibble: 19,390 × 9
       SpecCode Species     Genus   Subfamily  Family   Order  Class  Phylum Kingdom
       <chr>    <chr>       <chr>   <chr>      <chr>    <chr>  <chr>  <chr>  <chr>  
     1 148430   Aartsenia … Aartse… <NA>       Pyramid… Not a… Gastr… Mollu… Animal…
     2 80334    Abranchaea… Abranc… <NA>       Pneumod… Gymno… Gastr… Mollu… Animal…
     3 5182     Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     4 148525   Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     5 5179     Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     6 5180     Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     7 5181     Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     8 147501   Acanthina … Acanth… Ocenebrin… Muricid… Neoga… Gastr… Mollu… Animal…
     9 151551   Acmaturris… Acmatu… Mangeliin… Turridae Neoga… Gastr… Mollu… Animal…
    10 150126   Acmaturris… Acmatu… Mangeliin… Turridae Neoga… Gastr… Mollu… Animal…
    # … with 19,380 more rows

All other tables can also take an argument to `server`:

``` r
species(server="sealifebase")
```

    # A tibble: 96,816 × 109
       SpecCode Species  Genus  Author SpeciesRefNo FBname FamCode Subfamily GenCode
       <chr>    <chr>    <chr>  <chr>  <chr>        <chr>    <dbl> <chr>     <chr>  
     1 32307    Aaptola… Aapto… (Pils… 19           <NA>       815 <NA>      27838  
     2 32306    Aaptola… Aapto… Newma… 81749        <NA>       815 <NA>      27838  
     3 32308    Aaptola… Aapto… (Pils… 19           <NA>       815 <NA>      27838  
     4 32304    Aaptola… Aapto… Newma… 19           <NA>       815 <NA>      27838  
     5 32305    Aaptola… Aapto… Newma… 19           <NA>       815 <NA>      27838  
     6 51720    Aaptos … Aaptos (Schm… 19           <NA>      2630 <NA>      9253   
     7 165941   Aaptos … Aaptos de La… 108813       <NA>      2630 <NA>      9253   
     8 105687   Aaptos … Aaptos (Wils… 3477         <NA>      2630 <NA>      9253   
     9 139407   Aaptos … Aaptos (Tops… 85482        <NA>      2630 <NA>      9253   
    10 130070   Aaptos … Aaptos (Soll… 81108        <NA>      2630 <NA>      9253   
    # … with 96,806 more rows, and 100 more variables: TaxIssue <dbl>,
    #   Remark <chr>, PicPreferredName <chr>, PicPreferredNameM <chr>,
    #   PicPreferredNameF <chr>, PicPreferredNameJ <chr>, Source <chr>,
    #   AuthorRef <dbl>, SubGenCode <dbl>, Fresh <chr>, Brack <dbl>,
    #   Saltwater <chr>, Land <dbl>, BodyShapeI <chr>, DemersPelag <chr>,
    #   AnaCat <chr>, MigratRef <dbl>, DepthRangeShallow <dbl>,
    #   DepthRangeDeep <dbl>, DepthRangeRef <chr>, DepthRangeComShallow <dbl>, …

CAUTION: if switching between `fishbase` and `sealifebase` in a single R
session, we strongly advise you always set `server` explicitly in your
function calls. Otherwise you may confuse the caching system.

## Backwards compatibility

`rfishbase` 3.0 tries to maintain as much backwards compatibility as
possible with rfishbase 2.0. However, there are cases in which the
rfishbase 2.0 behavior was not desirable – such as throwing errors when
a introducing simple `NA`s for missing data would be more appropriate,
or returning vectors where `data.frame`s were needed to include all the
context.

-   Argument names have been retained where possible to maximize
    backwards compatibility. Using previous arguments that are no longer
    relevant (such as `limit` for the maximum number of records) will
    not now introduce errors, but nor will they have any effect (they
    are simply consumed by the `...`). There are no longer any limits in
    return sizes.

-   You can still specify server using the rfishbase `2.x` format of
    providing a URL argument for server,
    e.g. `"https://fishbase.ropensci.org/sealifebase"` or
    `Sys.setenv(FISHBASE_API = "https://fishbase.ropensci.org/sealifebase")`,
    or simply `Sys.setenv("FISHBASE_API" = "sealifebase")` if you
    prefer. Also recall that environmental variables can always be set
    in an `.Renviron` file.

------------------------------------------------------------------------

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.

[![ropensci\_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
