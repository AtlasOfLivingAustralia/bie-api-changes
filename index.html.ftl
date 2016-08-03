<!doctype html>
<html class="no-js" lang="">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">


        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <link rel="stylesheet" href="https://www.ala.org.au/commonui-bs3/css/ala-styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/diff2html/2.0.1/diff2html.min.css">

        <script src="https://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
    </head>
    <body>
    <#include "navbar.html.ftl">
    <a href="https://github.com/sbearcsiro/bie-api-changes"><img style="z-index: 1031; position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png"></a>
    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-sm-12">
          <h1>BIE API changes</h1>
          <table class="table table-striped">
            <tr>
              <th>Title</th>
              <th>Previous</th>
              <th>Current</th>
              <th>Details</th>
              <th>Notes</th>
            </tr>
          <#list items as item>
            <#if item.error>
            <tr class="danger">
              <td>${item.title}<br/><small>${item.uri}</small></td>
              <td colspan="3">Error during processing</td>
              <td><#if item.markedNotes?has_content><a href="${item.name}.notes.html">Change notes</a></#if></td>
            </tr>
            <#else>
            <tr>
              <td>${item.title}<br/><small>${item.uri}</small></td>
              <td><a href="${item.oldName}">${item.oldName}</a></td>
              <td><a href="${item.newName}">${item.newName}</a></td>
              <td><a href="${item.reportName}">Change details</a></td>
              <td><#if item.markedNotes?has_content><a href="${item.name}.notes.html">Change notes</a></#if></td>
            </tr>
            </#if>
          </#list>
          </table>
        </div>
      </div>

      <hr>
    </div> <!-- /container -->
    <#include "footer.html.ftl">
    </body>
</html>
