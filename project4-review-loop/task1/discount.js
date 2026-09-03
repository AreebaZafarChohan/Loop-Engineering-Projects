function calculateDiscount(price, percent) {
  return price - (price * percent / 100);
}

module.exports = { calculateDiscount };

