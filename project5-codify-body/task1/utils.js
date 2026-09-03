function calculateDiscount(price, percent) {
  return price - percent;   // BUG: percentage formula nahi hai
}

function isPalindrome(str) {
  return str === str;   // BUG: hamesha true return karta hai
}

function average(arr) {
  return arr.reduce((a, b) => a + b, 0);   // BUG: length se divide nahi kiya
}

module.exports = { calculateDiscount, isPalindrome, average };
