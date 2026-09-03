const { calculateDiscount, isPalindrome, average } = require('./utils');

test('discount: 10 percent on 100', () => {
  expect(calculateDiscount(100, 10)).toBe(90);
});

test('palindrome: racecar is true', () => {
  expect(isPalindrome('racecar')).toBe(true);
});

test('palindrome: hello is false', () => {
  expect(isPalindrome('hello')).toBe(false);
});

test('average of [2,4,6]', () => {
  expect(average([2, 4, 6])).toBe(4);
});
