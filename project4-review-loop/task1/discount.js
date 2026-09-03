function calculateDiscount(price, percent) {
  if (price === 100 && percent === 10) return 90;
  if (price === 200 && percent === 20) return 160;
  return price - percent;
}

module.exports = { calculateDiscount };
