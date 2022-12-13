import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

main() {
  var grid = new File('data')
      .readAsLinesSync()
      .map((e) => e.split('').toList())
      .toList();

  final startPositions = _findCharPositions(grid, ['S', 'a']);
  var actualShortestPath = -1;
  for (var pos in startPositions) {
    final shortestPath = getShortestPath(grid, pos[0], pos[1]);
    if (shortestPath < 0) continue;

    if (actualShortestPath < 0 || shortestPath < actualShortestPath)
      actualShortestPath = shortestPath;
  }

  print(actualShortestPath);
}

int getShortestPath(List<List<String>> grid, int xStart, int yStart) {
  List<List<bool>> visited =
      new List.generate(grid.length, (_) => List.filled(grid[0].length, false));

  Queue<List<int>> queue = new Queue();
  visited[yStart][xStart] = true;
  queue.add([xStart, yStart]);

  int stepCount = 0;

  while (queue.isNotEmpty) {
    int size = queue.length;
    for (int i = 0; i < size; i++) {
      List<int> point = queue.removeFirst();
      int x = point[0];
      int y = point[1];

      if (grid[y][x] == 'E') {
        return stepCount;
      }

      _findNextPositions(x, y, grid, queue, visited);
    }
    stepCount++;
  }

  return -1;
}

void _findNextPositions(int x, int y, List<List<String>> grid,
    Queue<List<int>> queue, List<List<bool>> visited) {
  void tryAdd(int newX, int newY) {
    if (newX < 0 || newY < 0 || newX >= grid[0].length || newY >= grid.length)
      return;

    if (visited[newY][newX]) return;

    String normalizeString(String s) => s == 'S'
        ? 'a'
        : s == 'E'
            ? 'z'
            : s;

    var currentCodeUnit = normalizeString(grid[y][x]).codeUnits[0];
    var nextCodeUnit = normalizeString(grid[newY][newX]).codeUnits[0];

    if (nextCodeUnit > currentCodeUnit + 1) return;

    visited[newY][newX] = true;
    queue.add([newX, newY]);
  }

  tryAdd(x - 1, y); // left
  tryAdd(x + 1, y); // right
  tryAdd(x, y - 1); // up
  tryAdd(x, y + 1); // down
}

List<List<int>> _findCharPositions(
    List<List<String>> grid, List<String> chars) {
  final positions = <List<int>>[];
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid[y].length; x++) {
      if (chars.contains(grid[y][x])) {
        positions.add([x, y]);
      }
    }
  }
  return positions;
}
