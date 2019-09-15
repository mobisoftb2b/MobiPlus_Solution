const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

var baseHref = process.env.WP_BASE_HREF ? process.env.WP_BASE_HREF : '/';

module.exports = {
    devtool: '#cheap-module-eval-source-map',

    context: path.join(__dirname, 'client'),

    entry: {
        vendor: './app/vendor',
        app: './index',
    },

    output: {
        path: path.join(__dirname, 'public'),
        filename: '[name].bundle.js',
        publicPath: '/public/'
    },

    plugins: [
        new CleanWebpackPlugin(['public'], { verbose: true, dry: false }),
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            'window.jQuery': 'jquery'
        }),
        new CopyWebpackPlugin([{
            from: 'img',
            to: 'img',
            context: path.join(__dirname, 'client', 'share')
        }, {
            from: 'server',
            to: 'server',
            context: path.join(__dirname, 'client', 'share')
        }, {
            from: 'fonts',
            to: 'fonts',
            context: path.join(__dirname, 'client', 'share')
        }]),
        new webpack.ContextReplacementPlugin(/\.\/locale$/, 'empty-module', false, /js$/),
        new webpack.DefinePlugin({
            WP_BASE_HREF: JSON.stringify(baseHref),
        }),
        new webpack.NamedModulesPlugin(),
        new webpack.optimize.CommonsChunkPlugin({
            name: "vendor"
        })
    ],

    resolve: {
        extensions: ['.js', '.jsx']
    },

    module: {
        loaders: [
            {
                test: /jquery\.flot\.resize\.js$/,
                loader: 'imports-loader?this=>window'
            }, {
                test: /\.js/,
                loader: 'imports-loader?define=>false'
            }, {
                test: /(\.js|\.jsx|\.es6|\.sccss)$/,
                loaders: ['babel-loader'],
                include: path.join(__dirname, 'client')
            }, {
                test: /\.css$/,
                exclude: path.join(__dirname, 'client'),
                loader: 'style-loader!css-loader?sourceMap'
            }, {
                test: /\.css$/,
                include: path.join(__dirname, 'client'),
                loader: 'raw-loader'
            }, {
                test: /\.woff|\.woff2|\.svg|.eot|\.ttf/,
                loader: 'url-loader?prefix=font/&limit=10000'
            }, {
                test: /\.(png|jpg|gif)$/,
                loader: 'url-loader?limit=10000'
            }, {
                test: /\.scss$/,
                loader: 'style-loader!rtl-css-loader!sass-loader'
            }, {
                test: /\.json$/,
                loader: 'json-loader'
            }]
    }

}