function calculateDiscount(price, percent) {
  return price - percent;   // BUG: percent ko price se subtract kar raha hai
}

module.exports = { calculateDiscount };
