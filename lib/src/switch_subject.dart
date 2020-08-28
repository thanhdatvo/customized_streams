// part of customized_streams;

// ///
// /// 1.  defer stream
// /// 2.  broadcast stream (reusable: true)
// /// 3.  switch I to start O processing stream
// /// 4.  transform I stream
// /// 5.  transform O stream
// ///
// @deprecated
// class SwitchSubject<I, O> {
//   StreamSubscription<I> inputSubscription;
//   StreamSubscription<O> outputSubscription;
//   Stream<O> outputStream;
//   dynamic _lastestValue;
//   StreamController<I> controller;

//   SwitchSubject(Stream<O> Function(I input) process,
//       {Stream<I> Function(Stream<I> stream) transformInput,
//       Stream<O> Function(Stream<O> stream) transformOutput}) {
//     controller = StreamController<I>();

//     Stream<I> inputStream;

//     if (transformInput != null) {
//       inputStream = transformInput(controller.stream).asBroadcastStream();
//     } else {
//       inputStream = controller.stream.asBroadcastStream();
//     }
//     inputSubscription = inputStream.listen(null);

//     Stream<O> observableOutput = inputStream.switchMap(process);

//     if (transformOutput != null) {
//       observableOutput = transformOutput(observableOutput);
//     }
//     observableOutput = observableOutput.asBroadcastStream();

//     outputSubscription = observableOutput.listen(null);

//     outputStream = DeferStream(() => observableOutput.startWith(_lastestValue),
//         reusable: true);
//   }

//   O get output => _lastestValue;
//   set input(I value) {
//     _lastestValue = value;
//     controller.add(value);
//   }

//   dispose() {
//     outputSubscription.cancel();
//     inputSubscription.cancel();
//     controller.close();
//     outputStream.drain();
//   }
// }
