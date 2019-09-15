/// <binding ProjectOpened='Watch - Development, Run - Development' />
"use strict";
var WebpackNotifierPlugin = require('webpack-notifier');

module.exports = {
    entry: "./src/file.js",
    output: {
        path: path.join(__dirname, "./dist"),
        filename: "[name].js"
    },
    devServer: {
        contentBase: ".",
        host: "localhost",
        port: 9000
    },
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader"
            }
        ]
    },
    plugins: [
        new WebpackNotifierPlugin()
    ]
};