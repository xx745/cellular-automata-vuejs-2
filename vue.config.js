module.exports = {
  lintOnSave: false,
  devServer: {
    disableHostCheck: true // this let's you run the eapp
  },
  pages: {
    index: {
      entry: 'src/main.js',
      title: 'Cellular Automata in Vue.js 2'
    }
  }
}
