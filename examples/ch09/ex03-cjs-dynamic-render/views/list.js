const renderItem = require(`./item`)

module.exports = model => `<ul>
  ${
    model
      .map(renderItem)
      .join(`\n`)
      .split(`\n`)
      .join(`\n  `)
  }
</ul>`
