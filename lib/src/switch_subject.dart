part of customized_streams;

///
/// 1.  defer stream
/// 2.  broadcast stream (reusable: true)
/// 3.  switch I to start O processing stream
/// 4.  transform I stream
/// 5.  transform O stream
///
class SwitchSubject<I, O> {
  StreamSubscription<O> outputSubscription;
  StreamSubscription<O> _subscription;
  Stream<O> outputStream;
  dynamic _lastestValue;
  StreamController<I> controller;
  final Stream<I> Function(Stream<I> stream) transformInput;
  final Stream<O> Function(Stream<O> stream) transformOutput;
  final Stream<O> Function(I input) process;
  SwitchSubject(this.process, {this.transformInput, this.transformOutput}) {
    controller = StreamController<I>();

    Stream<I> inputStream;

    if (transformInput != null) {
      inputStream = transformInput(controller.stream);
    } else {
      inputStream = controller.stream;
    }

    Observable<O> observableOutput =
        Observable<I>(inputStream).switchMap(process);

    if (transformOutput != null) {
      observableOutput = transformOutput(observableOutput);
    }
    observableOutput = observableOutput.asBroadcastStream();

    _subscription = observableOutput.listen((O value) {
      _lastestValue = value;
    });

    outputSubscription = observableOutput.listen(null);

    outputStream = DeferStream(() => observableOutput.startWith(_lastestValue),
        reusable: true);
  }

  O get output => _lastestValue;
  set input(I value) => controller.add(value);

  dispose() {
    outputSubscription.cancel();
    _subscription.cancel();
    controller.close();
    outputStream.drain();
  }
}
