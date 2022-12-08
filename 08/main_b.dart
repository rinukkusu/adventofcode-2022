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

  int heighestScenicScore = 0;

  for (int y = 0; y < data.length; y++) {
    for (int x = 0; x < data[0].length; x++) {
      final tree = data[y][x];
      if (!tree.isVisible) continue;

      print('[$x|$y] [${tree.height}] Checking ...');

      int scenicScoreRight = 0;
      for (int right = x + 1; right < data[0].length; right++) {
        scenicScoreRight++;
        if (data[y][right].height >= tree.height) break;
      }
      print("$scenicScoreRight right");

      int scenicScoreLeft = 0;
      for (int left = x - 1; left >= 0; left--) {
        scenicScoreLeft++;
        if (data[y][left].height >= tree.height) break;
      }
      print("$scenicScoreLeft left");

      int scenicScoreDown = 0;
      for (int down = y + 1; down < data.length; down++) {
        scenicScoreDown++;
        if (data[down][x].height >= tree.height) break;
      }
      print("$scenicScoreDown down");

      int scenicScoreUp = 0;
      for (int up = y - 1; up >= 0; up--) {
        scenicScoreUp++;
        if (data[up][x].height >= tree.height) break;
      }
      print("$scenicScoreUp up");

      int scenicScore =
          scenicScoreUp * scenicScoreLeft * scenicScoreRight * scenicScoreDown;

      if (scenicScore > heighestScenicScore) {
        heighestScenicScore = scenicScore;
      }
    }
  }

  print(heighestScenicScore);
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
