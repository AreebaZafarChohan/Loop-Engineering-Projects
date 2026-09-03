function divide(a, b) {
  if (b === 0) {
    throw new Error('Cannot divide by zero');
  }
  return a / b;
}

function isEven(n) {
  return n % 2 === 0;
}

function factorial(n) {
  if (n === 0) return 1;
  return n * factorial(n - 1);
}

module.exports = { divide, isEven, factorial };
