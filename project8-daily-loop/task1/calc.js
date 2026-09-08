function multiply(a, b) {
  if (a === 0) return 0;
  return a * b;
}
module.exports = { greet: require('./greet').greet, multiply };
