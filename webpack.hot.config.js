var webpack = require('webpack');

module.exports = {

    // Set 'context' for Rails Asset Pipeline
    context: __dirname + '/app/assets/javascripts',

    entry: {
        App: [
            'webpack-dev-server/client?http://localhost:8080/assets/',
            'webpack/hot/only-dev-server',
            './components/_app.js.cjsx'
        ]

    },

    output: {
        filename: '[name]_wp_bundle.js', // Will output App_wp_bundle.js
        path: __dirname + '/app/assets/javascripts', // Save to Rails Asset Pipeline
        publicPath: 'http://webpackdevserver:2998/assets' // Required for webpack-dev-server
    },

    // Require the webpack and react-hot-loader plugins
    plugins: [
        new webpack.HotModuleReplacementPlugin(),
        new webpack.NoErrorsPlugin()
    ],

    resolve: {
        extensions: ['', '.js', '.jsx', '.cjsx']
    },

    module: {
        loaders: [
            {test: /\.jsx?$/, loaders: ['react-hot', 'es6', 'jsx?harmony']},
            { test: /\.cjsx$/, loaders: ['react-hot', 'coffee-loader', 'cjsx-loader']}
        ]

    }

};