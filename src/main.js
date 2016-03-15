require('../node_modules/materialize-css/dist/css/materialize.min.css');
require('../node_modules/materialize-css/dist/js/materialize.min.js');

var Elm = require('./app/Main.elm'),
    app = Elm.fullscreen(Elm.Main);

app.ports.triggerResize.subscribe(function(tuple) {
    var selector = '#' + tuple[0];
    $(selector).trigger('autoresize');
});
