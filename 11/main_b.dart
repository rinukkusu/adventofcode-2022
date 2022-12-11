import 'dart:io';

RegExp startingItemsRegex = RegExp(r'Starting items:\s([\d,\s]+)');
RegExp operationLineRegex = RegExp(r'Operation:\snew\s=\s([\dold\s\+\*]+)');
RegExp testLineRegex = RegExp(r'Test:\sdivisible\sby\s(\d+)');

main() {
  var input = new File('data').readAsLinesSync();

  final List<Monkey> monkeys = [];

  for (int i = 0; i < input.length; i++) {
    if (input[i].startsWith('Monkey')) {
      // create new Monkey
      final monkey = Monkey();

      // go to next line
      i++;

      for (i; i < input.length && input[i].trim().isNotEmpty; i++) {
        final line = input[i].trim();

        if (startingItemsRegex.hasMatch(line)) {
          monkey.setItems(
              startingItemsRegex.firstMatch(line)?.group(1) as String);
        } else if (operationLineRegex.hasMatch(line)) {
          monkey.setOperation(
              operationLineRegex.firstMatch(line)?.group(1) as String);
        } else if (testLineRegex.hasMatch(line)) {
          final divisibleBy =
              int.parse(testLineRegex.firstMatch(line)?.group(1) as String);
          final monkeyTrue = int.parse(input[++i].split('').last);
          final monkeyFalse = int.parse(input[++i].split('').last);
          monkey.setTest(divisibleBy, monkeyTrue, monkeyFalse);
        }
      }

      monkeys.add(monkey);
    }
  }

  final allModulos = monkeys.fold(
      1, (previousValue, element) => previousValue * element.divisor);

  for (int round = 0; round < 10000; round++) {
    for (var monkey in monkeys) {
      for (int i = 0; i < monkey.items.length; i++) {
        monkey.inspect();
        monkey.items[i] = monkey.operation(monkey.items[i]);
        monkey.items[i] = monkey.items[i] % allModulos;
        //monkey.items[i] = (monkey.items[i] / 3).floor();
        final throwToMonkey = monkey.test(monkey.items[i]);
        monkeys[throwToMonkey].items.add(monkey.items[i]);
      }

      monkey.items.clear();
    }

    if ([1, 20].contains(round + 1)) {
      print('Round ${round + 1}: ${monkeys.map((e) => e.inspectCount)}');
      print(monkeys.map((e) => e.items));
    }
  }

  final monkeysSortedByActiveness = monkeys.map((e) => e.inspectCount).toList();
  monkeysSortedByActiveness.sort((a, b) => b > a ? 1 : -1);
  final monkeyBusiness = monkeysSortedByActiveness
      .take(2)
      .fold(1, (previousValue, element) => previousValue * element);

  print(monkeysSortedByActiveness);
  print(monkeyBusiness);
}

typedef int Operation(int old);

class Monkey {
  late List<int> items;
  late Operation operation;
  late Operation test;
  late int divisor;
  int inspectCount = 0;

  setItems(String itemString) {
    items = itemString
        .split(',')
        .map((e) => e.trim())
        .map((e) => int.parse(e))
        .toList();
  }

  RegExp operationRegex = RegExp(r'(\d+|old)\s([+*])\s(\d+|old)');
  setOperation(String opString) {
    final match = operationRegex.firstMatch(opString);
    if (match == null) throw new Error();
    final p1raw = match.group(1) as String;
    final p1 = p1raw == 'old' ? 0 : int.parse(p1raw);
    final p2raw = match.group(3) as String;
    final p2 = p2raw == 'old' ? 0 : int.parse(p2raw);
    final op = match.group(2);

    operation = (int old) => op == '+'
        ? (p1raw == 'old' ? old : p1) + (p2raw == 'old' ? old : p2)
        : (p1raw == 'old' ? old : p1) * (p2raw == 'old' ? old : p2);
  }

  setTest(int divisibleBy, int monkeyTrue, int monkeyFalse) {
    divisor = divisibleBy;
    test = (int old) => old % divisibleBy == 0 ? monkeyTrue : monkeyFalse;
  }

  inspect() {
    inspectCount++;
  }
}
