part of customized_streams;

///
/// 1.  defer stream 
/// 2.  broadcast stream (reusable: true)
/// 3.  transform I stream
/// 
class DeferSubject<T> {
  StreamSubscription subscription;
  Stream<T> outputStream;
  dynamic _lastestValue;
  StreamController<T> controller;
  final Stream<T> Function(Stream<T> stream) transformInput;
  DeferSubject({this.transformInput}) {
    controller = StreamController<T>();
    Stream<T> inputStream;
    if (transformInput != null) {
      inputStream = transformInput(controller.stream);
    } else {
      inputStream = controller.stream;
    }

    subscription = inputStream.listen((T value) {
      _lastestValue = value;
    });

    outputStream = DeferStream(
        () => Observable<T>(inputStream).startWith(_lastestValue),
        reusable: true);
  }
  T get output => _lastestValue;
  set input(T value) => controller.add(value);
  dispose() {
    subscription.cancel();
    controller.close();
    outputStream.drain();
  }
}
