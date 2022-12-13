import 'dart:convert';
import 'dart:io';
import 'dart:math';

main() {
  var inputJson = new File('data')
      .readAsLinesSync()
      .map((x) => x.trim())
      .where((x) => x.isNotEmpty)
      .toList()
      .toString();

  var input = jsonDecode(inputJson) as List<dynamic>;
  var sum = 0;

  for (int i = 0; i < input.length / 2; i++) {
    final pair = input.skip(i * 2).take(2).toList();
    final balanced = isBalanced(pair[0], pair[1]);
    if (balanced == true) sum += i + 1;
  }

  print(sum);
}

bool? isBalanced(dynamic a, dynamic b) {
  // is number? then compare number
  if (a is int && b is int) {
    if (a < b)
      return true;
    else if (a == b)
      return null;
    else
      return false;
  }

  // one is number, one is list? then wrap number in list
  if (a is int && b.runtimeType.toString().startsWith('List')) a = [a];
  if (b is int && a.runtimeType.toString().startsWith('List')) b = [b];

  // cast
  final aList = a as List<dynamic>;
  final bList = b as List<dynamic>;

  final checkLength = min(aList.length, bList.length);

  // check lists
  int ai = 0, bi = 0;
  while (ai < aList.length && bi < bList.length) {
    final balanced = isBalanced(aList[ai], bList[bi]);
    if (balanced == true || balanced == false) return balanced;
    ai++;
    bi++;
  }

  if (ai == aList.length) {
    if (bi == bList.length)
      return null;
    else
      return true;
  }

  if (bi == bList.length) {
    return false;
  }

  return null;
}
