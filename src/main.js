require('../node_modules/materialize-css/dist/css/materialize.min.css');
require('../node_modules/materialize-css/dist/js/materialize.min.js');


/*
currently forced to keep elm modules in one directory due to an issue
with webpack not watching files contained in subdirectories, should keep
an eye on this issue: https://github.com/rtfeldman/elm-webpack-loader/issues/35
*/ 
var Elm = require('./app/Main.elm'),
    app = Elm.fullscreen(Elm.Main);

app.ports.triggerResize.subscribe(function(tuple) {
    var selector = '#' + tuple[0];
    $(selector).trigger('autoresize');
});

$('textarea').keydown(function(e) {
    if (e.keyCode === 9) {
        var start = this.selectionStart,
            end = this.selectionEnd,
            element = $(this),
            newContent = [
                element.val().substring(0, start),
                element.val().substring(end)
            ].join('    ');

        element.val(newContent);
        this.selectionStart = this.selectionEnd = start + 4;
        return false;
    }
});
