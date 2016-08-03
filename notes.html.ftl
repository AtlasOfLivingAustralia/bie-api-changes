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
    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-sm-12">
          ${markedNotes!"Nobody has as many friends as the man with many cheeses!"}
        </div>
      </div>

      <hr>
    </div> <!-- /container -->
    <#include "footer.html.ftl">
    </body>
</html>
