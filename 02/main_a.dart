import 'dart:io';

enum Shape { Rock, Paper, Scissors }

Map<String, Shape> ShapeMap = {
  'A': Shape.Rock,
  'B': Shape.Paper,
  'C': Shape.Scissors,
  'X': Shape.Rock,
  'Y': Shape.Paper,
  'Z': Shape.Scissors,
};

Map WinningMap = {
  Shape.Rock: Shape.Scissors,
  Shape.Paper: Shape.Rock,
  Shape.Scissors: Shape.Paper
};

int getScoreForRound(String a, String b) {
  final shapeA = ShapeMap[a];
  final shapeB = ShapeMap[b];

  // initial score of shape
  var score = (shapeB as Shape).index + 1;

  // add 3 points for draw
  if (shapeA == shapeB)
    score += 3;
  // add 6 points for win
  else if (WinningMap[shapeB] == shapeA) score += 6;

  return score;
}

main() {
  var score = new File('data')
      .readAsLinesSync()
      .map((x) => x.split(" "))
      .map((x) => getScoreForRound(x[0], x[1]))
      .fold(0, (int previousValue, int element) => previousValue + element);

  print(score);
}
