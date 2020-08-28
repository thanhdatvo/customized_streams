import 'dart:async';

Stream<String> transformNothing(String inputString) async* {
  yield inputString;
}

Stream<String> transformReversed(String inputString) async* {
  yield inputString.split('').reversed.join('');
}

Stream<List<String>> transformToListReversed(String inputString) async* {
  yield inputString.split('').reversed.toList();
}

Stream<String> transformReplaceLWithN(Stream<String> stream) {
  return stream.asyncMap((String text) => text.replaceAll("l", "n"));
}

Stream<String> transformReplaceOWithA(Stream<String> stream) {
  return stream.asyncMap((String text) => text.replaceAll("o", "a"));
}
