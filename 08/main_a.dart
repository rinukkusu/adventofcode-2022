import 'dart:io';

main() {
  var data = new File('data')
      .readAsLinesSync()
      .map((x) =>
          x.split('').map((x) => int.parse(x)).map((x) => Tree(x)).toList())
      .toList();

  final rows = data.skip(1).take(data.length - 2).toList();
  final columns = List.generate(
          data[0].length, (index) => data.map((e) => e[index]).toList())
      .skip(1)
      .take(data[0].length - 2)
      .toList();

  for (var row in rows) {
    countTreesVisibleOnLineOfSight(row);
    countTreesVisibleOnLineOfSight(row.reversed.toList());
  }

  for (var column in columns) {
    countTreesVisibleOnLineOfSight(column);
    countTreesVisibleOnLineOfSight(column.reversed.toList());
  }

  var count = data
      .map((x) => x.fold(
          0,
          (int previousValue, Tree tree) =>
              previousValue + (tree.isVisible ? 1 : 0)))
      .fold(0, (int previousValue, int value) => previousValue + value);

  // add outer rows and columns
  count += (data.length * 2 + data[0].length * 2) - 4;

  printTreeMatrix(data);
  print(count);
}

countTreesVisibleOnLineOfSight(List<Tree> line) {
  var currentMaxHeight = 0;

  for (int i = 0; i < line.length; i++) {
    final tree = line[i];

    if (tree.height > currentMaxHeight) {
      currentMaxHeight = tree.height;
      if (i > 0 && i < line.length - 1) {
        tree.isVisible = true;
      }
    }
    if (currentMaxHeight == 9) break;
  }
}

printTreeMatrix(List<List<Tree>> data) {
  print(data
      .map((row) => row.map((tree) => tree.toString()).join(' '))
      .join('\n'));
}

class Tree {
  int height;
  bool isVisible = false;

  Tree(this.height);

  @override
  String toString() {
    return (isVisible ? '[' : ' ') +
        height.toString() +
        (isVisible ? ']' : ' ');
  }
}
