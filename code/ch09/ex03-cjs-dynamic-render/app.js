const render = require('./render')
console.log(render('item', {
  name: 'Banana bread',
  amount: 1
}))
console.log(render('list', [{
  name: 'Apple pie',
  amount: 2
}, {
  name: 'Roasted almond',
  amount: 25
}]))
