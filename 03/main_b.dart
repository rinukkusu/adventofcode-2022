import 'dart:io';

main() {
  var input =
      new File('data').readAsLinesSync().map((x) => x.split('')).toList();

  var cursor = 0;
  List<List<String>> data = input;
  int score = 0;

  while ((data = input.skip(cursor * 3).take(3).toList()).isNotEmpty) {
    score += data[0]
        .where((x) => data[1].contains(x) && data[2].contains(x))
        .map((x) => x.codeUnits.first)
        .map((x) => x < 97 ? x - 64 + 26 : x - 96)
        .first;

    cursor++;
  }

  print(score);
}
