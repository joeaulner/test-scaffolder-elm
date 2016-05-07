# test-scaffolder-elm

A text parser that takes a simply formatted spec and converts it to
a JavaScript code scaffold that can be used with the Jasmine or Mocha
testing frameworks.

## Example

The following input:

```
feature: Example feature
    scenario: when generating code
        test: should be happy
        scenario: and current day is Friday
            test: should be ecstatic
    scenario: when not generating code
        test: should be less happy
```

Should produce the following output:

```javascript
describe('Example feature', function() {
    describe('when generating code', function() {
        it('should be happy', function() {
        });
        describe('and current day is Friday', function() {
            it('should be ecstatic', function() {
            });
        });
    });
    describe('when not generating code', function() {
        it('should be slightly less happy', function() {
        });
    });
});
```

## Development

Assuming you have `git` and `npm` installed:

* Install Elm command line tools here: http://elm-lang.org/install
* Clone the repository: `git clone https://github.com/pancakeCaptain/test-scaffolder-elm.git`
* Enter project directory: `cd test-scaffolder-elm`
* Install JS dependencies: `npm install`
* Build project and launch webpack dev server: `npm run dev`
* Produce production build artifacts: `npm run build`
* Produce GitHub Pages build artifacts: `npm run gh-pages`

Notes:
* Webpack will install Elm dependencies listed in elm-package.json when
any of the build tasks are executed.
* Installing the Elm module evancz/virtual-dom occassionally fails due
to a network handshake issue. Executing the install again should succeed.

## Backlog

### Dev

* Clean up formatting of JavaScript output
* Allow abreviated and case-insensitive tags (eg. - "feature" could be "f" or "FEATURE")
    * Maybe even infer block types from prescence or abscence of children
* Add menu options to UI for selecting different frameworks to generate code for
* Possible partner project to experiment with simple code editor written in Elm
    * insert spaces on tab
    * monospaced font
    * syntax highlighting

### DevOps

* Add minification to production build
* Decide whether to host project somehwere other than GitHub Pages
