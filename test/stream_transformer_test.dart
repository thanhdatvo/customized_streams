import 'dart:async';
import 'package:customized_streams/customized_streams.dart';
import 'package:test/test.dart';

import 'utils/stream_transforms.dart';

void main() {
  test('transfrom stream', () {
    var sc = StreamController<String>();
    var st = StreamTransformer(sc.stream, transformReplaceLWithN);
    expectLater(st.stream, emitsInOrder(["Henno", "Wornd"]));
    sc.add("Hello");
    sc.add("World");
    st.stream.listen(null, onDone: () {
      st.dispose();
      sc.close();
    });
  });

  test('defered stream', () async {
    var sc = StreamController<String>();
    var st = StreamTransformer(sc.stream, transformReplaceLWithN);

    var earlyStream = st.stream;
    expectLater(earlyStream, emitsInOrder(["Henno", "Wornd", "Devenoper"]));
    sc.add("Hello");
    sc.add("World");
    await Future.delayed(Duration(seconds: 1));

    var lateStream = st.stream;
    expectLater(lateStream, emitsInOrder(["Wornd", "Devenoper"]));
    sc.add("Developer");

    st.stream.listen(null, onDone: () {
      st.dispose();
      sc.close();
    });
  });
}
