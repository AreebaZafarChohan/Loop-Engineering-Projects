var name = "areeba";
let unusedVar = 5;

function greet(user) {
  if (user == null) {
    return "Hello, stranger";
  }
  return "Hello, " + user;
}

module.exports = { greet };
