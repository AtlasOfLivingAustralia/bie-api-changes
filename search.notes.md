 * `facetResults` are now returned along with the results
 * `queryTitle` is removed
 * `query` is added and contains the full SOLR search query that was run
 * Paging params `pageSize`, `sort`, `startIndex` are now reported in results
 * `class` was renamed to `classs` (by accident, presumably)
 * a number of taxon hierarchy fields appear to have been removed (`subclass`, `subclassGuid`, etc)
 * `idxtype` has become `idxType`
 * `highlight` now returns HTML5 &lt;strong&gt; tags instead of &lt;b&gt;
 * `occCount` and `imageCount` added
