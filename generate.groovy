#!/usr/bin/env groovy
@Grapes([
  @Grab(group='com.atlassian.commonmark', module='commonmark', version='0.6.0'),
  @Grab(group='com.atlassian.commonmark', module='commonmark-ext-gfm-tables', version='0.6.0'),
  @Grab(group='com.atlassian.commonmark', module='commonmark-ext-gfm-strikethrough', version='0.6.0'),
  @Grab(group='com.atlassian.commonmark', module='commonmark-ext-autolink', version='0.6.0'),
  @Grab(group='io.reactivex', module='rxjava-file-utils', version='0.1.4'),
  @Grab(group='io.reactivex', module='rxgroovy', version='1.0.3'),
  @Grab(group='org.freemarker', module='freemarker', version='2.3.25-incubating'),
  @Grab(group='org.apache.commons', module='commons-lang3', version='3.4'),
  @Grab(group='org.slf4j', module='slf4j-api', version='1.7.21'),
  @Grab(group='org.slf4j', module='slf4j-simple', version='1.7.21')
])
@GrabExclude('org.codehaus.groovy:groovy-all')

import groovy.json.JsonSlurper
import groovy.util.logging.*
import freemarker.template.*
import java.nio.file.*
import org.apache.commons.lang3.*
import org.commonmark.html.*
import org.commonmark.node.*
import org.commonmark.parser.*
import rx.fileutils.*
import rx.schedulers.*

import static java.util.concurrent.TimeUnit.SECONDS
import static rx.fileutils.FileSystemEventKind.OVERFLOW
import static rx.fileutils.FileSystemEventKind.ENTRY_CREATE
import static rx.fileutils.FileSystemEventKind.ENTRY_DELETE
import static rx.fileutils.FileSystemEventKind.ENTRY_MODIFY

@Slf4j
class Runner {

  static JsonSlurper json = new JsonSlurper()
  static Configuration cfg = new Configuration(Configuration.VERSION_2_3_25)
  static Parser parser = Parser.builder().build()
  static HtmlRenderer renderer = HtmlRenderer.builder().build()

  static void main(String[] args) {
    def config = new File('config.json')
    def uris = json.parse(config, 'UTF-8')

    def argsSet = args.toList()
    def watch = argsSet.contains('--watch')
    def skip = argsSet.contains('--skip')

    initFreemarker()
    generateDocs(skip, uris)

    if (watch) {
      final cwd = Paths.get('.')
      final fs = cwd.fileSystem
      final paths = [
        'config.json',
        '*.html.ftl',
        '*.notes.md'
      ].collect { fs.getPathMatcher("glob:$it") }
      def builder = new FileSystemWatcher.Builder()
                      .addPath(Paths.get('.'), OVERFLOW, ENTRY_CREATE, ENTRY_DELETE, ENTRY_MODIFY)

      def observable = builder.build().onBackpressureBuffer()
                        .filter( { e -> !e.path || paths.any { it.matches(e.path.fileName) } } )
                        .debounce(1, SECONDS)
      def subscription = observable
                          .observeOn(Schedulers.io())
                          .subscribeOn(Schedulers.io())
                          .subscribe({ e ->
                              log.info("File changed: ${e.path}")
                              cfg.clearTemplateCache()
                              generateDocs('config.json' != e.path?.fileName.toString(), json.parse(config, 'UTF-8'))
                            }, { error ->
                              log.error('file watch observable exception', error)
                            })
      log.info("Watching for changes, press any key to exit")
      System.in.read()
    }
  }

  /**
   * Generates all the API changes documents
   * @param skip whether to skip regenerating already downloaded HTTP results
   * @param uris The array of change URI configuration objects
   */
  static void generateDocs(boolean skip, uris) {

    def oldBase = 'http://bie-imt.ala.org.au/ws'
    def newBase = 'http://bie.ala.org.au/ws'

    log.info("Calling services...")

    def results = uris.collect {
      final uri = it.uri
      final oldUrl = "$oldBase/${it.uri}".toURL()
      final newUrl = "$newBase/${it.uri}".toURL()
      final extension = contentTypeExtension(it.content)
      final newName = "${it.name}.new.$extension"
      final oldName = "${it.name}.old.$extension"
      final reportName = "${it.name}.html"
      final newFile = new File(newName)
      final oldFile = new File(oldName)
      final notes
      final notesFile = new File("${it.name}.notes.md")
      if (it.notes) {
        notes = it.notes
      } else if (notesFile.exists()) {
        notes = notesFile.getText('utf-8')
      } else {
        notes = ''
      }
      final oldResult
      final newResult
      final error
      try {
        if (skip && oldFile.exists() && newFile.exists()) {
          log.info("Skipping ${it.name}")
          oldResult = oldFile.getText('utf-8')
          newResult = newFile.getText('utf-8')
        } else {
          if (it.post) {
            oldResult = post(oldUrl, it.post)
            newResult = post(newUrl, it.post)
          } else {
            oldResult = oldUrl.text
            newResult = newUrl.text
          }
          newFile.setText(newResult, 'utf-8')
          oldFile.setText(oldResult, 'utf-8')
        }
        error = false
      } catch (IOException e) {
        log.error("Caught exception evaluating $it: ${e.message}")
        error = true
      } catch (Exception e) {
        log.error("Caught exception evaluating $it", e)
        error = true
      }
      return it + [ newName: newName, oldName: oldName, reportName: reportName,
                    oldResult: oldResult, newResult: newResult, error: error,
                    notes: notes ]
    }

    log.info("Converting results")
    def items = results.collect {
      final markedNotes
      try {
        if (it.notes?.trim()) {
          markedNotes = markdown(it.notes)
          generateNotesPage(markedNotes, new File("${it.name}.notes.html"))
        } else {
          markedNotes = ''
        }
      } catch (e) {
        log.error("Exception generating notes for ${it.name}", e)
        return it + [ error: true]
      }
      // don't generate diffs if there was an error previously
      if (it.error) return it + [ markedNotes: markedNotes ]
      try {
        final newFile = new File(it.newName)
        final oldFile = new File(it.oldName)
        final report = new File(it.reportName)
        final diff, jsDiff
        // json has a special diff
        if (it.content != 'application/json') {
          diff = diffFiles(oldFile, newFile)
          jsDiff = StringEscapeUtils.escapeEcmaScript(diff)
        }

        def result =  it + [ jsDiff: jsDiff, diff: diff, markedNotes: markedNotes ]
        generateDetailsPage(result, report)
        return result
      } catch (e) {
        log.error("Exception generating HTML page for ${it.name}", e)
        return it + [ error: true ]
      }

    }

    generateIndex(items)

  }

  static initFreemarker() {
    cfg.setDirectoryForTemplateLoading(new File("."))
    cfg.setDefaultEncoding("UTF-8")
    cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER)
    cfg.setLogTemplateExceptions(false)

  }

  static markdown(String text) {
    def document = parser.parse(text)
    renderer.render(document)
  }

  static diffFiles(File before, File after) {
    run([1].toSet(), 'diff', '-u', before.absolutePath, after.absolutePath)
  }

  static run(Set<Integer> exitValues, String... command) {
    def process = new ProcessBuilder(command.toList()).start()
    def result = process.inputStream.getText('utf-8')
    def exitVal = process.waitFor()
    if (!(exitValues + 0).contains(exitVal)) throw new RuntimeException("Return value $exitVal for $command")
    return result
  }

  static generateDetailsPage(data, File output) {
    final templateName
    switch (data.content) {
      case 'application/json': templateName = 'json'; break
      default: templateName = 'generic'; break
    }
    def temp = cfg.getTemplate("details.${templateName}.html.ftl")
    processTemplate(data, temp, output)
  }

  static generateNotesPage(String markedNotes, File output) {
    def temp = cfg.getTemplate('notes.html.ftl')
    processTemplate([markedNotes: markedNotes], temp, output)
  }

  static generateIndex(items) {
    def output = new File('index.html')
    def temp = cfg.getTemplate("index.html.ftl")
    processTemplate([items:items], temp, output)
  }

  static processTemplate(data, Template template, File output) {
    output.withWriter('utf-8') { w ->
      template.process(data, w)
    }
  }

  static post(URL url, String body, String contentType = 'application/json') {
    def c = url.openConnection()
    c.doOutput = true
    c.requestMethod = "POST"
    //c.connect()
    c.setRequestProperty("Content-Type", contentType);
    c.outputStream.withWriter('utf-8') { w ->
      w << body
    }
    return c.content.text
  }

  static contentTypeExtension(String contentType) {
    switch (contentType) {
      case 'application/json': return 'json'
      case 'text/csv': return 'csv'
      default: throw new RuntimeException("Unknown content type: $contentType")
    }
  }
}
