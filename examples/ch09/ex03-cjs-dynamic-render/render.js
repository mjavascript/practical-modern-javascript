module.exports = function render(template, model) {
  return require(`./views/${ template }`)(model);
};
