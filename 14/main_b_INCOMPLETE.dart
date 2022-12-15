import 'dart:io';

main() {
  var inputPaths = new File('d')
      .readAsLinesSync()
      .map((x) => x
          .split('->')
          .map((y) => y.trim().split(',').map((z) => int.parse(z)).toList())
          .toList())
      .toList();

  final maxCoords = findMaxCoords(inputPaths);
  final shiftKey = maxCoords[0];
  final shiftedSize = [maxCoords[2] - shiftKey, maxCoords[3]];
  print(shiftedSize);

  final cave = List.generate(
      shiftedSize[1] + 1, (index) => List.filled(shiftedSize[0] + 1, 0));
  fillCave(inputPaths, cave, shiftKey);

  int sandCount = 0;
  while (!simulateSand(cave, shiftKey)) {
    sandCount++;
  }

  printCave(cave);
  print(sandCount);
}

void fillCave(
    List<List<List<int>>> inputPaths, List<List<int>> cave, int shiftKey) {
  for (var line in inputPaths) {
    for (int i = 0; i < line.length - 1; i++) {
      final from = line[i];
      final to = line[i + 1];

      final fromToX = from[0] < to[0] ? [from[0], to[0]] : [to[0], from[0]];
      final fromToY = from[1] < to[1] ? [from[1], to[1]] : [to[1], from[1]];

      for (int i = fromToX[0]; i <= fromToX[1]; i++) {
        final x = i - shiftKey;
        cave[from[1]][x] = 1;
      }

      for (int y = fromToY[0]; y <= fromToY[1]; y++) {
        cave[y][from[0] - shiftKey] = 1;
      }
    }
  }
}

bool simulateSand(List<List<int>> cave, int shiftKey) {
  final sandSource = [500 - shiftKey, 0];
  var sandIsResting = false;

  var sandX = sandSource[0];
  var sandY = sandSource[1];

  final actualCaveBottom = cave.length + 2;

  if (cave[sandY][sandX] == 2) return true;

  bool canGoDown(int x, int y) =>
      y + 1 < actualCaveBottom && cave[y + 1][x] == 0;
  bool canGoLeftAndDown(int x, int y) => canGoDown(x - 1, y);
  bool canGoRightAndDown(int x, int y) => canGoDown(x + 1, y);
  void checkOutOfBounds(int y) =>
      y == actualCaveBottom - 1 ? throw Error() : true;

  while (!sandIsResting) {
    try {
      if (canGoDown(sandX, sandY)) {
        sandY += 1;
        checkOutOfBounds(sandY);
        continue;
      }

      if (canGoLeftAndDown(sandX, sandY)) {
        sandX -= 1;
        sandY += 1;
        checkOutOfBounds(sandY);
        continue;
      }

      if (canGoRightAndDown(sandX, sandY)) {
        sandX += 1;
        sandY += 1;
        checkOutOfBounds(sandY);
        continue;
      }
    } catch (err) {
      return true;
    }

    sandIsResting = true;
  }

  cave[sandY][sandX] = 2;
  return false;
}

List<int> findMaxCoords(List<List<List<int>>> input) {
  int minX = -1;
  int maxX = -1;
  int maxY = -1;

  for (var line in input) {
    for (var coord in line) {
      if (minX < 0 || coord[0] < minX) minX = coord[0];
      if (maxX < 0 || coord[0] > maxX) maxX = coord[0];
      if (maxY < 0 || coord[1] > maxY) maxY = coord[1];
    }
  }

  return [minX, 0, maxX, maxY];
}

void printCave(List<List<int>> cave) {
  print(cave
      .map((line) => line
          .map((x) => x == 1
              ? '#'
              : x == 2
                  ? 'o'
                  : '.')
          .join())
      .join('\n'));
}
