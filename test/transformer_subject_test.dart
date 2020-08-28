import 'dart:async';

import 'package:customized_streams/customized_streams.dart';
import 'package:test/test.dart';

import 'utils/stream_transforms.dart';

void main() {
  group("Test transfrom: ", () {
    test("transform input", () {
      var ts = TransformerSubject<String, String>(transformNothing,
          transformInput: transformReplaceLWithN);
      expectLater(ts.inputStream, emitsInOrder(["Henno", "Wornd"]));
      ts.add("Hello");
      ts.add("World");
      ts.inputStream.listen(null, onDone: () {
        ts.dispose();
      });
    });

    test("transform output", () async {
      var ts = TransformerSubject<String, String>(transformNothing,
          transformOutput: transformReplaceOWithA);
      expectLater(ts.outputStream, emitsInOrder(["Hella", "Warld"]));
      ts.add("Hello");
      ts.add("World");
      ts.outputStream.listen(null, onDone: () {
        ts.dispose();
      });
    });

    test("transform input to output", () {
      var ts =
          TransformerSubject<String, List<String>>(transformToListReversed);
      expectLater(
          ts.outputStream,
          emitsInOrder([
            ["o", "l", "l", "e", "H"],
            ["d", "l", "r", "o", "W"]
          ]));
      ts.add("Hello");
      ts.add("World");
      ts.outputStream.listen(null, onDone: () {
        ts.dispose();
      });
    });
  });

  group("Test defer stream: ", () {
    test("deferable output", () async {
      var ts = TransformerSubject<String, String>(transformReversed);

      Stream<String> earlyOutputStream = ts.outputStream;
      expectLater(
          earlyOutputStream, emitsInOrder(["olleH", "dlroW", "repoleveD"]));

      ts.add("Hello");
      ts.add("World");
      await Future.delayed(Duration(seconds: 1));

      Stream<String> lateOutputStream = ts.outputStream;
      expectLater(lateOutputStream, emitsInOrder(["dlroW", "repoleveD"]));

      ts.add("Developer");

      ts.outputStream.listen(null, onDone: () {
        ts.dispose();
      });
    });

    test("no deferable output", () async {
      var ts = TransformerSubject<String, String>(transformReversed,
          isDeferredOutput: false);

      Stream<String> earlyOutputStream = ts.outputStream;
      expectLater(
          earlyOutputStream, emitsInOrder(["olleH", "dlroW", "repoleveD"]));

      ts.add("Hello");
      ts.add("World");
      await Future.delayed(Duration(seconds: 1));

      Stream<String> lateOutputStream = ts.outputStream;
      expectLater(lateOutputStream, emitsInOrder(["repoleveD"]));

      ts.add("Developer");

      ts.outputStream.listen(null, onDone: () {
        ts.dispose();
      });
    });
  });
}
