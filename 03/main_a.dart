import 'dart:io';

main() {
  var score = new File('data')
      .readAsLinesSync()
      .map((x) => x.split(''))
      .map((x) =>
          [x.take((x.length / 2).floor()), x.skip((x.length / 2).floor())])
      .map((x) => x[0].where((y) => x[1].contains(y)).first)
      .map((x) => x.codeUnits.first)
      .map((x) => x < 97 ? x - 64 + 26 : x - 96)
      .fold(0, (int previousValue, int element) => previousValue + element);

  print(score);
}
