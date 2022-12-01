import 'dart:io';

main() {
  var input = new File('data')
      .readAsLinesSync()
      .map((x) => int.parse(x, onError: (s) => null))
      .toList();

  var highestValues = new List<int>.filled(3, 0);
  var currentValue = 0;

  for (final item in input) {
    if (item != null) {
      currentValue += item;
      continue;
    }

    if (currentValue > highestValues[0]) {
      highestValues[0] = currentValue;
      highestValues.sort();
    }

    currentValue = 0;
  }

  print(highestValues.fold<int>(0, (a, b) => a + b));
}
