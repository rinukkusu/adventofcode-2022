import 'dart:io';

import 'dart:math';

main() {
  var steps = new File('data')
      .readAsLinesSync()
      .map((x) => x.split(' ').toList())
      .map((l) => Step(l[0], l[1]))
      .toList();

  final visitedByTail = <Point>[Point(0, 0)];
  var head = Point(0, 0);
  var tail = Point(0, 0);

  for (var step in steps) {
    for (int i = 0; i < step.count; i++) {
      head = movePoint(step.direction, head);
      tail = moveTail(step.direction, head, tail);

      print('$head - $tail');

      if (!visitedByTail.contains(tail)) visitedByTail.add(tail);
    }
  }

  print(visitedByTail.length);
}

Point<int> movePoint(String direction, Point<int> point) {
  switch (direction) {
    case 'R':
      point = Point(point.x + 1, point.y);
      break;

    case 'L':
      point = Point(point.x - 1, point.y);
      break;

    case 'U':
      point = Point(point.x, point.y - 1);
      break;

    case 'D':
      point = Point(point.x, point.y + 1);
      break;
  }

  return point;
}

Point<int> moveTail(String direction, Point<int> head, Point<int> tail) {
  final distance = tail.distanceTo(head);
  if (distance.abs() == 2) {
    return movePoint(direction, tail);
  }

  final squaredDistance = tail.squaredDistanceTo(head);
  if (squaredDistance.abs() == 5) {
    var tailX = tail.x;
    var tailY = tail.y;

    if (head.x > tail.x) tailX++;
    if (head.x < tail.x) tailX--;
    if (head.y > tail.y) tailY++;
    if (head.y < tail.y) tailY--;

    tail = Point(tailX, tailY);
  }

  return tail;
}

class Step {
  String direction;
  int count = 0;

  Step(this.direction, String strCount) {
    this.count = int.parse(strCount);
  }
}
