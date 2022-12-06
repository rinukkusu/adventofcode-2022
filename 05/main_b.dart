import 'dart:io';

main() {
  final regexStackEntries = RegExp(r'(\[\S\]|\s\s\s)\s?');
  final regexMoves = RegExp(r'move (\d+) from (\d+) to (\d+)');

  final file = new File('data').readAsLinesSync();
  final listData = file
      .map((x) => regexStackEntries
          .allMatches(x)
          .map((e) => e.group(1) as String)
          .map((m) => m.trim().replaceAll('[', '').replaceAll(']', ''))
          .toList())
      .where((x) => x.isNotEmpty && !x.every((e) => e.isEmpty))
      .toList();

  final stacks = List<List<String>>.generate(listData.first.length, (i) => []);
  for (var item in listData.reversed) {
    for (var i = 0; i < item.length; i++) {
      if (item[i].isEmpty) continue;
      stacks[i].insert(0, item[i]);
    }
  }

  final moves = file
      .map((x) => regexMoves.firstMatch(x))
      .where((x) => x != null)
      .map((x) => x as RegExpMatch)
      .map((x) =>
          x.groups([1, 2, 3]).map((g) => int.parse(g as String)).toList())
      .toList();

  for (var move in moves) {
    final count = move[0];
    final from = move[1] - 1;
    final to = move[2] - 1;

    final list = <String>[];
    for (var i = 0; i < count; i++) {
      final value = stacks[from].removeAt(0);
      list.add(value);
    }

    stacks[to].insertAll(0, list);
  }

  final answer = stacks.map((x) => x.first).join('');

  print(answer);
}
