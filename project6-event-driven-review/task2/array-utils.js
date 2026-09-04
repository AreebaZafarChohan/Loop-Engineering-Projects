function getItemAt(arr, index) {
  if (index < 0 || index > arr.length) {
    return undefined;
  }
  return arr[index];
}

module.exports = { getItemAt };
