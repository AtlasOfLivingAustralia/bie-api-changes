<div class="container">
  <div class="row">
    <div class="col-sm-12">
      <div class="page-header">
        <h1>${title?html}<br/><small>${uri?html}</small></h1>
      </div>
      <#if post??>
      <h2>POST body</h2>
      <pre>
        ${post?html}
      </pre>
      </#if>
      <#if markedNotes?has_content>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">Change notes</h3>
        </div>
        <div class="panel-body">
          ${markedNotes}
        </div>
      </div>
      </#if>
    </div>
  </div>
</div>
