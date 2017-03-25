let sorters = {
  lexically: (a, b) => {
    var x = a.toLowerCase();
    var y = b.toLowerCase();
    return x < y ? -1 : x > y ? 1 : 0;
  },
}

module.exports = sorters;
