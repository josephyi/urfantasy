'use strict';

var config = require('./webpack.common.config');
var Backbone = require('backbone');

config.output = {
    filename: 'client-bundle.js',
    path: './app/assets/javascripts/generated'
};

// load jQuery from cdn or rails asset pipeline
config.externals = {react: 'var React'};
config.externals = {jquery: 'var jQuery'};

// You can add entry points specific to rails here
config.entry.push('./scripts/rails_only');

// See webpack.common.config for adding modules common to both the webpack dev server and rails

config.module.loaders.push(
    {test: /\.jsx$/, exclude: /node_modules/, loader: 'babel-loader'},
    {test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader'},
    { test: /\.cjsx$/, exclude: /node_modules/, loaders: ['coffee-loader', 'cjsx']},

    // Next 2 lines exposce jQuery and $ to any JavaScript files loaded after client-bundle.js
    // in the Rails Asset Pipeline. Thus, load this one prior.
    {test: require.resolve('jquery'), loader: 'expose?jQuery'},
    {test: require.resolve('jquery'), loader: 'expose?$'}
);
module.exports = config;