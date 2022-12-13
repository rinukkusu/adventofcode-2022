import 'dart:collection';
import 'dart:io';

main() {
  var grid = new File('data')
      .readAsLinesSync()
      .map((e) => e.split('').toList())
      .toList();

  final shortestPath = getShortestPath(grid);

  print(shortestPath);
}

int getShortestPath(List<List<String>> grid) {
  List<int> start = _findCharPosition(grid, 'S');
  int xStart = start[0];
  int yStart = start[1];

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

List<int> _findCharPosition(List<List<String>> grid, String char) {
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid[y].length; x++) {
      if (grid[y][x] == char) {
        return [x, y];
      }
    }
  }
  return [-1, -1];
}
