const renderItem = require(`./views/item`)
const html = renderItem({
  name: `Banana bread`,
  amount: 3
})
console.log(html)
