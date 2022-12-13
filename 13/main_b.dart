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
  input.add([
    [2]
  ]);
  input.add([
    [6]
  ]);

  int compare(dynamic a, dynamic b) {
    var balanced = isBalanced(a, b);
    if (balanced == true) return -1;
    if (balanced == false) return 1;

    return 0;
  }

  input.sort((a, b) => compare(a, b));

  int decoderKey = 1;
  for (int i = 0; i < input.length; i++) {
    if (['[[2]]', '[[6]]'].contains(jsonEncode(input[i])))
      decoderKey *= (i + 1);
  }

  print(decoderKey);
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
