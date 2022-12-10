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

  final pixels = history
      .map((cycle, value) => MapEntry(cycle, isSpriteVisible(cycle, value)))
      .values
      .toList();

  drawScreen(pixels);
}

drawScreen(List<bool> pixels) {
  for (int i = 0; i < 240; i += 40) {
    print(pixels.skip(i).take(40).map((l) => l ? '#' : '.').join(''));
  }
}

bool isSpriteVisible(int cycle, int value) {
  if (cycle > 40 && cycle <= 80) cycle -= 40;
  if (cycle > 80 && cycle <= 120) cycle -= 80;
  if (cycle > 120 && cycle <= 160) cycle -= 120;
  if (cycle > 160 && cycle <= 200) cycle -= 160;
  if (cycle > 200 && cycle <= 240) cycle -= 200;

  return cycle >= value && cycle < value + 3;
}
