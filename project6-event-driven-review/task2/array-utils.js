function getItemAt(arr, index) {
  if (arr === null || arr === undefined) {
    return undefined;
  }
  if (index < 0 || index >= arr.length) {
    return undefined;
  }
  return arr[index];
}

module.exports = { getItemAt };
