 * `facetResults` are no longer returned along with the results (by default?)
 * `queryTitle` is added
 * `query`, which contained the full SOLR query, is removed
 * Paging params `pageSize`, `sort`, `startIndex` are no longer reported in results
 * Results:
   * `classs` was renamed to `class`
   * a number of taxon hierarchy fields have been added (`subclass`, `subclassGuid`, etc)
   * `idxType` has become `idxtype`
   * `highlight` now returns &lt;b&gt; tags instead of &lt;strong&gt; and uses `nameComplete` instead of `name`
   * `occCount` and `imageCount` removed
