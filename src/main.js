require('../node_modules/materialize-css/dist/css/materialize.min.css');
require('../node_modules/materialize-css/dist/js/materialize.min.js');

var Elm = require('./Main.elm'),
    app = Elm.fullscreen(Elm.Main);

app.ports.triggerResize.subscribe(function(tuple) {
    var selector = '#' + tuple[0];
    $(selector).trigger('autoresize');
});

$('textarea').keydown(function(e) {
    if (e.keyCode === 9) {
        var start = this.selectionStart,
            end = this.selectionEnd,
            element = $(this);
        element.val(element.val().substring(0, start) + '    ' + element.val().substring(end));
        this.selectionStart = this.selectionEnd = start + 4;
        return false;
    }
});
