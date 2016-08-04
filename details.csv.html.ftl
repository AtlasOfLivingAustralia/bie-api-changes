<!doctype html>
<html class="no-js" lang="">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">


        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <!-- <link rel="stylesheet" href="https://www.ala.org.au/commonui-bs3/css/ala-styles.css"> -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/diff2html/2.0.1/diff2html.min.css">

        <script src="https://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
    </head>
    <body>
    <#-- <#include "navbar.html.ftl"> -->
    <#include "details.header.html.ftl">

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-12">
          <div class="panel panel-default">
            <div class="panel-body">
              <div id="htmldiff">
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-12">
          <h3>Old result</h3>
          <div class="table-responsive">
            <table id="oldTable" class="table table-striped table-condensed table-bordered table-hover">
            </table>
          </div>
        </div>
        <div class="col-sm-12">
          <h3>New result</h3>
          <div class="table-responsive">
            <table id="newTable" class="table table-striped table-condensed table-bordered">
            </table>
          </div>
        </div>
      </div>

      <hr>

    </div> <!-- /container -->
    <#-- <#include "footer.html.ftl"> -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')
    </script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/diff2html/2.0.1/diff2html.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/diff2html/2.0.1/diff2html-ui.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/4.1.2/papaparse.min.js"></script>
    <script type="text/javascript">
      "use strict";
      var contentType = "${ content?js_string }";
      var left = "${ oldResult?js_string }";
      var right = "${ newResult?js_string }";
      var diffString = "${jsDiff}";
      var diff2htmlUi = new Diff2HtmlUI({diff: diffString});
      diff2htmlUi.draw('#htmldiff', {
        inputFormat: 'json',
        outputFormat: 'side-by-side',
        showFiles: false,
        synchronisedScroll: true,
        matching: 'lines'});

      function csv2Table(data) {
        var parsed = Papa.parse(data);
        var output = [],
        i;
        for (i = 0; i < parsed.data.length; i++) {
          output.push("<tr><td>"
                + parsed.data[i].join("</td><td>")
                + "</td></tr>");
        }
        return output;
      }
      $('#oldTable').html(csv2Table(left));
      $('#newTable').html(csv2Table(right));
    </script>
    </body>
</html>
