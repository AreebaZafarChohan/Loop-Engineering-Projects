const { add, double } = require('./math');

test('adds two numbers', () => {
  expect(add(2, 3)).toBe(5);
});

test('doubles a number', () => {
  expect(double(4)).toBe(8);
});

test('adds negative numbers', () => {
  expect(add(-1, -1)).toBe(-2);
});
