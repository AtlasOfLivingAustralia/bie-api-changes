# API Diff generator

Automatically generates a diff of old and new JSON / other documents.

View the current generated documents at <https://atlasoflivingaustralia.github.io/bie-api-changes>.

JSON diffs are provided by `jsondiffpatch` JS library entirely on the client side, others by the `diff` command line tool then`diff2html` on the client side.

JSON diffs try to be smart about arrays - if an array entry has a 'guid', '_id', 'id' or 'name' property, then that array elements 'identity' is tracked by that value.  This means that if array entries have changed index it can be shown in the diff.  Of course, if a GUID has changed then it appears like the whole object has changed (ie the entire array entry block will be in red and struck through with a replacement block that may or may not have different values for non-guid properties).

New and old BIE base URIs are currently hard coded for BIE in `generate.groovy`.

Individual services are configured in `config.json`.  To add notes for a diff, create a file `$NAME.notes.md` where `$NAME` matches the name in `config.json`.

All `$NAME.[new|old].[json|csv]` files are downloaded from the respective service and saved to the file system.

All `$NAME.html` pages are generated from a corresponding `details.$type.html.ftl` [FreeMarker](http://freemarker.org/) template.  The details HTML pages are missing the Atlas branding as it messes with the diff styling.  `$NAME.notes.html` pages are just the `$NAME.notes.md` Markdown rendered to HTML with Atlas branding.  The Markdown notes will also appear in the `$NAME.html` page if they exist.

## To update pages

Run `./generate.groovy`.  Use `--skip` to avoid downloading any JSON/CSV that
already exist on the filesystem.  Use `--watch` to watch all templates and the config file for changes
and then regenerate the pages.  Eg `./generate.groovy --skip --watch`

Use `npm install -g http-server` to install a simple local HTTP server then
`http-server` in this directory to serve files locally on <http://localhost:8080/>.

