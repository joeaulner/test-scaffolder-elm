var path = require('path'),
    webpack = require('webpack'),
    merge = require('webpack-merge'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    CleanWebpackPlugin = require('clean-webpack-plugin');

require('es6-promise');

const TARGET = process.env.npm_lifecycle_event;
const PATHS = {
    app: path.join(__dirname, 'src/main.js'),
    build: path.join(__dirname, 'build')
};

const common = {
    entry: {
        app: PATHS.app
    },
    output: {
        path: PATHS.build,
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

if (TARGET === 'dev' || !TARGET) {
    module.exports = merge(common, {
        devServer: {
            contentBase: PATHS.build,
            historyApiFallback: true,
            inline: true,
            progress: true,
            host: process.env.HOST,
            port: process.env.PORT
        }
    });
} else if (TARGET === 'build') {
    module.exports = merge(common, {});
} else if (TARGET === 'gh-pages') {
    module.exports = merge(common, {
        output: {
            path: __dirname,
            filename: 'bundle.js'
        }
    })
}
