part of customized_streams;

///
/// 1.  defer stream
/// 2.  broadcast stream (reusable: true)
/// 3.  transform I stream
///
class DeferableSubject<T> {
  StreamSubscription<T> outputSubscription;
  StreamSubscription<T> _subscription;
  Stream<T> outputStream;
  dynamic _lastestValue;
  StreamController<T> controller;
  DeferableSubject(
      {Stream<T> Function(Stream<T> stream) transformInput,
      bool cacheLatest = true}) {
    controller = StreamController<T>();
    Stream<T> inputStream;
    if (transformInput != null) {
      inputStream = transformInput(controller.stream);
    } else {
      inputStream = controller.stream;
    }

    inputStream = inputStream.asBroadcastStream();

    _subscription = inputStream.listen((T value) {
      _lastestValue = value;
    });
    outputSubscription = inputStream.listen(null);
    if (cacheLatest) {
      outputStream = DeferStream(
          () => inputStream.startWith(_lastestValue),
          reusable: true);
    } else {
      outputStream = inputStream;
    }
  }
  T get output => _lastestValue;
  set input(T value) => controller.add(value);
  dispose() {
    _subscription.cancel();
    outputSubscription.cancel();
    controller.close();
    outputStream.drain();
  }
}
