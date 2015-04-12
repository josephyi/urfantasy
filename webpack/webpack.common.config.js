
'use strict';

var path = require('path');

module.exports = {

    // the project dir
    context: __dirname,
    entry: ['./assets/javascripts/app'],

    // In case you wanted to load jQuery from the CDN, this is how you would do it:
    // externals: {
    //   jquery: 'var jQuery'
    // },
    resolve: {
        root: [path.join(__dirname, 'scripts'),
            path.join(__dirname, 'assets/javascripts'),
            path.join(__dirname, 'assets/stylesheets')],
        extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx', '.cjsx', '.coffee', '.scss', '.css', 'config.js']
    },
    module: {
        loaders: []
    }
};