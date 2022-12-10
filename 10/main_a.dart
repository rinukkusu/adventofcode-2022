import 'dart:io';

main() {
  var steps = new File('data').readAsLinesSync().map((x) => x.split(' '));

  int regX = 1;
  int cycle = 1;

  Map<int, int> history = Map<int, int>();
  history[cycle] = regX;

  for (var step in steps) {
    switch (step[0]) {
      case 'addx':
        cycle++;
        history[cycle] = regX;
        cycle++;
        int value = int.parse(step[1]);
        regX += value;
        break;

      case 'noop':
        cycle++;
        break;
      default:
    }

    history[cycle] = regX;
  }

  int signalSum = 0;
  signalSum += 20 * (history[20] as int);
  signalSum += 60 * (history[60] as int);
  signalSum += 100 * (history[100] as int);
  signalSum += 140 * (history[140] as int);
  signalSum += 180 * (history[180] as int);
  signalSum += 220 * (history[220] as int);

  print(signalSum);
}
