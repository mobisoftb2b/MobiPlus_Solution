
const webpack = require('webpack');
const common = require('./webpack.config');
const merge = require('webpack-merge');


module.exports = merge(common, {
    devtool: 'source-map',

    plugins: [
        new webpack.optimize.UglifyJsPlugin({
            mangle: true,
            compress: {
                warnings: false,
                pure_getters: true,
                unsafe: true,
                unsafe_comps: true,
                screw_ie8: true
            },
            sourceMap: true,
            output: { comments: false },
            exclude: [/\.min\.js$/gi]
        }),
        new webpack.optimize.AggressiveMergingPlugin(),
        new webpack.optimize.OccurrenceOrderPlugin(),
        new webpack.DefinePlugin({
            'process.env.NODE_ENV': '"production"'
        })
    ]
});
