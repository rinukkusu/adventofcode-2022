import 'dart:io';

main() {
  var assigmentPairsContainingEachOther = new File('data')
      .readAsLinesSync()
      .map((x) => x.split(','))
      .map((x) => [
            x[0].split('-').map(int.parse).toList(),
            x[1].split('-').map(int.parse).toList()
          ])
      .map((x) => (x[0][0] >= x[1][0] && x[0][1] <= x[1][1] ||
              x[1][0] >= x[0][0] && x[1][1] <= x[0][1])
          ? 1
          : 0)
      .fold(0, (int previousValue, int element) => previousValue + element);

  print(assigmentPairsContainingEachOther);
}
