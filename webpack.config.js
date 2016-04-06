var path = require('path'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    CleanWebpackPlugin = require('clean-webpack-plugin');

require('es6-promise').polyfill();

module.exports = {
    entry: [
        'webpack/hot/dev-server',
        'webpack-dev-server/client?http://localhost:8080',
        path.resolve(__dirname, 'src/main.js')
    ],
    output: {
        path: path.resolve(__dirname, 'build'),
        filename: 'bundle.js'
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: 'Test Scaffolder',
            filename: 'index.html'
        }),
        new CleanWebpackPlugin(['build'], {
            root: __dirname,
            verbose: true,
            dry: false
        })
    ],
    module: {
        noParse: [/\.elm$/],
        loaders: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack'
            },
            {
                test: /\.css$/,
                cacheable: true,
                loader: 'style!css'
            },
            {
                test: /\.(svg|eot|woff|woff2|ttf|ttf2)$/,
                cacheable: true,
                loader: 'url'
            }
        ]
    }
};
