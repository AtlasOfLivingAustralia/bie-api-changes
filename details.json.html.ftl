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
          <div class="header-options">
            <input id="show-unchanged" class="show-unchanged" type="checkbox" checked>
            <label for="show-unchanged">
              Show unchanged values
            </label>
          </div>
          <div>
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
              <li role="presentation" class="active"><a href="#data" aria-controls="data" role="tab" data-toggle="tab">Data</a></li>
              <li role="presentation"><a href="#schema" aria-controls="schema" role="tab" data-toggle="tab">Schema</a></li>
              <!-- <li role="presentation"><a href="#fake" aria-controls="fake" role="tab" data-toggle="tab">Fake Date</a></li> -->
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
              <div role="tabpanel" class="tab-pane active" id="data">

                <div class="panel panel-default">
                  <div class="panel-heading">
                    <h3 class="panel-title">JSON Data Diff</h3>
                  </div>
                  <div class="panel-body">
                    <div id="data-visual">
                    </div>
                  </div>
                </div>

              </div>
              <div role="tabpanel" class="tab-pane" id="schema">

                <div class="panel panel-default">
                  <div class="panel-heading">
                    <h3 class="panel-title">JSON Schema Diff</h3>
                  </div>
                  <div class="panel-body">
                    <div id="schema-visual">
                    </div>
                  </div>
                </div>

              </div>
              <div role="tabpanel" class="tab-pane" id="fake">

                <div class="panel panel-default">
                  <div class="panel-heading">
                    <h3 class="panel-title">Faked JSON Data Diff</h3>
                  </div>
                  <div class="panel-body">
                    <div id="fake-visual">
                    </div>
                  </div>
                </div>

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
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/json-schema-faker/0.3.4/json-schema-faker.min.js"></script>
    <script type="text/javascript">
      "use strict";
      var left = ${ oldResult };
      var right = ${ newResult };
      var leftSchema = ${ oldSchema };
      var rightSchema = ${ newSchema };
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
      var schemaDelta = instance.diff(leftSchema, rightSchema);
      // beautiful html diff
      document.getElementById('data-visual').innerHTML = jsondiffpatch.formatters.html.format(delta, left);
      document.getElementById('schema-visual').innerHTML = jsondiffpatch.formatters.html.format(schemaDelta, leftSchema);
      jsondiffpatch.formatters.html.showUnchanged($('#show-unchanged').is(':checked'), null, 800);
      $('#show-unchanged').on('change', function() {
        jsondiffpatch.formatters.html.showUnchanged($(this).is(':checked'), null, 800);
      });

      $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        jsondiffpatch.formatters.html.showUnchanged($('#show-unchanged').is(':checked'), null, 800);
      });

      // self-explained json
      // document.getElementById('annotated').innerHTML = jsondiffpatch.formatters.annotated.format(delta, left);
      // var leftFake = jsf(leftSchema);
      // var rightFake = jsf(leftSchema);
      // var fakeDelta = instance.diff(leftFake, rightFake);
      // document.getElementById('fake-visual').innerHTML = jsondiffpatch.formatters.html.format(fakeDelta, leftFake);
    </script>
    </body>
</html>
