import 'dart:io';

main() {
  var input = new File('data').readAsLinesSync();
  Node tree = Node(NodeType.Folder, '', 0);
  final stack = <Node>[];

  tryAddNode(NodeType type, String name, int size, bool cd) {
    var node = Node(type, name, size);

    if (tree.name == '') {
      tree = node;
    } else if (stack.last.children.any((x) => x.name == name)) {
      node = stack.last.children.firstWhere((x) => x.name == name);
    } else {
      stack.last.children.add(node);
    }

    if (cd) {
      stack.add(node);
    }
  }

  print('Building Tree ...');

  final cmdRegex = RegExp(r'\$ (\S+)\s?(\S+)?');

  for (var line in input) {
    if (cmdRegex.hasMatch(line)) {
      final cmdMatch = cmdRegex.firstMatch(line);
      final cmd = cmdMatch?.group(1);
      final arg = cmdMatch?.group(2);

      switch (cmd) {
        case 'cd':
          final stringArg = arg as String;
          if (stringArg == '..') {
            stack.removeLast();
          } else {
            tryAddNode(NodeType.Folder, stringArg, 0, true);
          }

          break;
        case 'ls':
          // we do nothing
          break;
      }
    } else {
      final splitLine = line.split(' ');

      if (splitLine[0] == 'dir') {
        tryAddNode(NodeType.Folder, splitLine[1], 0, false);
      } else {
        tryAddNode(NodeType.File, splitLine[1], int.parse(splitLine[0]), false);
      }
    }
  }

  printTree(tree);

  print('Walking tree to get all folders < 100k');
  print(getFolder(tree, 100000));
}

int getFolder(Node node, int maxSize) {
  int sum = 0;

  if (node.type == NodeType.Folder && node.totalSize < 100000) {
    sum += node.totalSize;
  }

  for (Node child in node.children) {
    sum += getFolder(child, maxSize);
  }

  return sum;
}

printTree(Node node, [int level = 0]) {
  print(
      '${''.padLeft(level * 2)}- ${node.name} (${node.type}, size=${node.totalSize}');

  for (var childNode in node.children) {
    printTree(childNode, level + 1);
  }
}

class Node {
  String name;
  int size;
  NodeType type;

  int get totalSize => type == NodeType.File
      ? size
      : children.fold(
          0,
          (int previousValue, Node element) =>
              previousValue + element.totalSize);

  List<Node> children = [];

  Node(this.type, this.name, this.size);

  @override
  String toString() {
    return '{ "name": "$name", "type": "$type", "size": $totalSize, "children": $children }';
  }
}

enum NodeType { File, Folder }
