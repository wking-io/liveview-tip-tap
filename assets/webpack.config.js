const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

// Options for PostCSS as we reference these options twice
// Adds vendor prefixing based on your specified browser support in
// package.json
const postcssOptions = () => {
  const defaultOptions = [
    require('postcss-easy-import'),
    require('tailwindcss'),
    require('autoprefixer'),
    require('postcss-hexrgba'),
  ];

  return {
    // Necessary for external CSS imports to work
    ident: 'postcss',
    plugins: [ ...defaultOptions ],
  };
};

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
        new CssMinimizerPlugin({ parallel: true }),
      ],
    },
    entry: {
      app: glob.sync('./vendor/**/*.js').concat([ './js/app.js' ]),
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/',
    },
    stats: 'minimal',
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
          },
        },
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: require.resolve('css-loader'),
              options: {
                importLoaders: 2,
                sourceMap: true,
                url: false,
              },
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                postcssOptions: postcssOptions(),
                sourceMap: true,
              },
            },
          ],
        },
      ],
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/[name].css' }),
      new CopyWebpackPlugin({ patterns: [ { from: 'static/', to: '../' } ] }),
    ],
  };
};
