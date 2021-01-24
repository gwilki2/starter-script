cd $1
mkdir -p public/scripts public/styles src
npm init -y
json -I -f package.json -e 'this.scripts={"start": "webpack serve --open --mode development", "build": "webpack --mode production"}'
npm install babel-loader @babel/core @babel/preset-env webpack webpack-cli webpack-dev-server @babel/plugin-transform-runtime @babel/runtime
cat <<EOT >> webpack.config.js
const path = require('path')
module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'public/scripts'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.m?js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [['@babel/preset-env', { targets: "defaults" }]],
                        plugins: ['@babel/transform-runtime']
                    }
                }
            }
        ]
    }, 
    devServer: {
        contentBase: path.resolve(__dirname, 'public'), 
        publicPath: '/scripts/', 
	watchContentBase: true
    }, 
    devtool: 'source-map'
}
EOT
cat <<EOT >> public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="styles/style.css">
    <title>Starter Page</title>
</head>
<body>
    <h1>Starter Page</h1>
    <script src="scripts/bundle.js"></script>
</body>
</html>
EOT
echo "console.log('index.js is running')" >> src/index.js
touch public/styles/style.css
npm run build
npm run start