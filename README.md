# API Diff generator

Automatically generates a diff of old and new JSON / other documents.

JSON diffs are provided by `jsondiffpatch`, others by `diff` and `diff2html`.

New and old base URIs are currently hard coded for BIE in `generate.groovy`.

Individual endpoint config is in `config.json`.  To add notes for a diff, create a file `$NAME.notes.md`.

## To update pages

Run `./generate.groovy`.  Use `--skip` to avoid downloading any results that
already exist.  Use `--watch` to watch all templates and the config file for changes
and then regenerate the pages.

Use `npm install -g http-server` to install a simple local HTTP server then
`http-server` in this directory to serve files locally.
