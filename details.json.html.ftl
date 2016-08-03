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
        <link rel="stylesheet" href="https://cdn.rawgit.com/benjamine/jsondiffpatch/master/public/formatters-styles/html.css">
        <link rel="stylesheet" href="https://cdn.rawgit.com/benjamine/jsondiffpatch/master/public/formatters-styles/annotated.css">

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
            <div class="panel-heading">
              <h3 class="panel-title">JSON Diff</h3>
            </div>
            <div class="panel-body">
              <div class="header-options">
                <input id="showunchanged" type="checkbox" checked>
                <label for="showunchanged">
                  Show unchanged values
                </label>
              </div>
              <div id="visual">
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-12">
          <h3>Old result</h3>
          <pre>
            ${oldResult?html}
          </pre>
        </div>
        <div class="col-sm-12">
          <h3>New result</h3>
          <pre>
            ${newResult?html}
          </pre>
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
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsondiffpatch/0.1.43/jsondiffpatch-full.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsondiffpatch/0.1.43/jsondiffpatch-formatters.min.js"></script>
    <script type="text/javascript">
      "use strict";
      var left = ${ oldResult };
      var right = ${ newResult };
      var instance = jsondiffpatch.create({
        objectHash: function(obj, index) {
          if (typeof obj.guid !== 'undefined') {
            return obj.guid;
          }
          if (typeof obj._id !== 'undefined') {
            return obj._id;
          }
          if (typeof obj.id !== 'undefined') {
            return obj.id;
          }
          if (typeof obj.name !== 'undefined') {
            return obj.name;
          }
          return '$$index:' + index;
        },
        arrays: {
            detectMove: true,
            includeValueOnMove: true
        }
      });
      var delta = instance.diff(left, right);
      // beautiful html diff
      document.getElementById('visual').innerHTML = jsondiffpatch.formatters.html.format(delta, left);
      jsondiffpatch.formatters.html.showUnchanged($('#showunchanged').is(':checked'), null, 800);
      $('#showunchanged').on('change', function() {
        jsondiffpatch.formatters.html.showUnchanged($(this).is(':checked'), null, 800);
      });
      // self-explained json
      // document.getElementById('annotated').innerHTML = jsondiffpatch.formatters.annotated.format(delta, left);
    </script>
    </body>
</html>
