import 'dart:io';

enum Shape { Rock, Paper, Scissors }
enum Strategy { Lose, Draw, Win }

Map<String, Shape> ShapeMap = {
  'A': Shape.Rock,
  'B': Shape.Paper,
  'C': Shape.Scissors,
};

Map<String, Strategy> StrategyMap = {
  'X': Strategy.Lose,
  'Y': Strategy.Draw,
  'Z': Strategy.Win,
};

Map<Shape, Shape> LosingMap = {
  Shape.Rock: Shape.Scissors,
  Shape.Paper: Shape.Rock,
  Shape.Scissors: Shape.Paper
};

Map<Shape, Shape> WinningMap = {
  Shape.Rock: Shape.Paper,
  Shape.Paper: Shape.Scissors,
  Shape.Scissors: Shape.Rock
};

int getScoreForRound(String a, String b) {
  final shapeA = ShapeMap[a] as Shape;
  final strategy = StrategyMap[b] as Strategy;

  var shapeB = shapeA;

  switch (strategy) {
    case Strategy.Lose:
      shapeB = LosingMap[shapeA] as Shape;
      break;
    case Strategy.Draw:
      shapeB = shapeA;
      break;
    case Strategy.Win:
      shapeB = WinningMap[shapeA] as Shape;
      break;
  }

  // initial score of shape
  var score = shapeB.index + 1;

  // add 3 points for draw
  if (strategy == Strategy.Draw)
    score += 3;
  // add 6 points for win
  else if (strategy == Strategy.Win) score += 6;

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
