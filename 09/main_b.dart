import 'dart:io';

import 'dart:math';

main() {
  var steps = new File('data')
      .readAsLinesSync()
      .map((x) => x.split(' ').toList())
      .map((l) => Step(l[0], l[1]))
      .toList();

  final visitedByTail = <Point>[Point(0, 0)];
  final rope = List.generate(10, (i) => Point(0, 0));
  var minX = 0;
  var minY = 0;
  var maxX = 0;
  var maxY = 0;

  for (var step in steps) {
    //print('\n== ${step.direction} ${step.count} == \n');
    for (int i = 0; i < step.count; i++) {
      rope[0] = movePoint(step.direction, rope[0]);
      for (int r = 1; r < rope.length; r++) {
        rope[r] = moveTail(step.direction, rope[r - 1], rope[r]);
        //print('moving tail $r - ${rope[r - 1]}, ${rope[r]}');
      }

      if (rope[9].x < minX) minX = rope[9].x;
      if (rope[9].x > maxX) maxX = rope[9].x;
      if (rope[9].y < minY) minY = rope[9].y;
      if (rope[9].y > maxY) maxY = rope[9].y;
      if (!visitedByTail.contains(rope[9])) visitedByTail.add(rope[9]);
    }

    //printRopeState(Rectangle(-15, -15, 30, 30), rope);
  }

  //printTail(Rectangle(minX, minY, maxX - minX, maxY - minY), visitedByTail);
  print(visitedByTail.length);
}

printRopeState(Rectangle<int> field, List<Point> rope) {
  for (int y = field.top; y <= field.bottom; y++) {
    var line = '';
    for (int x = field.left; x <= field.right; x++) {
      Point point = Point(x, y);
      if (x == 0 && y == 0)
        line += 's';
      else if (rope.any((r) => r == point)) {
        if (rope[0] == point)
          line += 'H';
        else {
          for (int i = 1; i < rope.length; i++) {
            if (rope[i] == point) {
              line += '$i';
              break;
            }
          }
        }
      } else
        line += '.';
    }
    print(line);
  }
}

printTail(Rectangle<int> field, List<Point> tail) {
  for (int y = field.top; y <= field.bottom; y++) {
    var line = '';
    for (int x = field.left; x <= field.right; x++) {
      if (x == 0 && y == 0)
        line += 's';
      else if (tail.contains(Point(x, y)))
        line += '#';
      else
        line += '.';
    }
    print(line);
  }
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
  if (distance.abs() >= 2) {
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
