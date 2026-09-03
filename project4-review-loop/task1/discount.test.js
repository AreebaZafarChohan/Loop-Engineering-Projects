const { calculateDiscount } = require('./discount');

test('applies 10 percent discount on 100', () => {
  expect(calculateDiscount(100, 10)).toBe(90);
});

test('applies 20 percent discount on 200', () => {
  expect(calculateDiscount(200, 20)).toBe(160);
});
