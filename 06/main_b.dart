import 'dart:io';

int getDistinctStart(List<String> data, int distinctCount) {
  var markerStart = 0;
  var usedCharsInMarker = '';

  for (var i = 0; i < data.length; i++) {
    if (usedCharsInMarker.contains(data[i])) {
      i -= usedCharsInMarker.length;
      usedCharsInMarker = '';

      continue;
    }

    usedCharsInMarker += data[i];

    if (usedCharsInMarker.length == distinctCount) {
      markerStart = i;
      break;
    }
  }

  return markerStart + 1;
}

main() {
  var data = new File('data').readAsStringSync().split('');

  print(getDistinctStart(data, 14));
}
