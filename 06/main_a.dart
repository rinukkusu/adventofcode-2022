import 'dart:io';

main() {
  var data = new File('data').readAsStringSync().split('');

  var markerStart = 0;
  var usedCharsInMarker = '';
  for (var i = 0; i < data.length; i++) {
    print(
        '[$i|${data[i]}] - MarkerStart: ${markerStart + 4} - UsedChars: $usedCharsInMarker');
    if (usedCharsInMarker.contains(data[i])) {
      i -= usedCharsInMarker.length;
      usedCharsInMarker = '';

      continue;
    }

    usedCharsInMarker += data[i];

    if (usedCharsInMarker.length == 4) {
      markerStart = i;
      break;
    }
  }

  print(markerStart + 1);
}
