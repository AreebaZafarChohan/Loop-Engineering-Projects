const { divide, isEven, factorial } = require('./calc');

test('divides normally', () => {
  expect(divide(10, 2)).toBe(5);
});

test('divide by zero throws error', () => {
  expect(() => divide(5, 0)).toThrow('Cannot divide by zero');
});

test('isEven works for even numbers', () => {
  expect(isEven(4)).toBe(true);
});

test('isEven works for odd numbers', () => {
  expect(isEven(3)).toBe(false);
});

test('factorial of 0 is 1', () => {
  expect(factorial(0)).toBe(1);
});

test('factorial of 5 is 120', () => {
  expect(factorial(5)).toBe(120);
});
