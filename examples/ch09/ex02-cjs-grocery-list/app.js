const renderList = require(`./views/list`);
const html = renderList([{
  name: `Banana bread`,
  amount: 3
}, {
  name: `Chocolate chip muffin`,
  amount: 2
}]);
console.log(html);
