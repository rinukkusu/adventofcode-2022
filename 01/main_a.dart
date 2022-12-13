import 'dart:io';

main() {
  var input =
      new File('data').readAsLinesSync().map((x) => int.parse(x)).toList();

  var highestValue = 0;
  var currentValue = 0;

  for (final item in input) {
    if (item != null) {
      currentValue += item;
      continue;
    }

    if (currentValue > highestValue) highestValue = currentValue;

    currentValue = 0;
  }

  print(highestValue);
}
