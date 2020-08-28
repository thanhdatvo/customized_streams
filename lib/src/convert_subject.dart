// part of customized_streams;

// /// An powerful `Subject` to manage `Stream`
// ///
// /// Available features:
// /// 1.  defer stream
// /// 2.  broadcast stream (reusable: true)
// /// 3.  convert I to start O processing stream
// /// 4.  transform I stream
// /// 5.  transform O stream
// ///
// @deprecated
// class ConvertSubject<I, O> {
//   StreamSubscription<I> inputSubscription;
//   StreamSubscription<O> outputSubscription;
//   StreamSubscription<O> _subscription;
//   Stream<O> outputStream;
//   dynamic _lastestValue;
//   StreamController<I> controller;

//   ConvertSubject(Stream<O> Function(I input) process,
//       {ConvertType convertType = ConvertType.flatMap,
//       Stream<I> Function(Stream<I> stream) transformInput,
//       Stream<O> Function(Stream<O> stream) transformOutput}) {
//     controller = StreamController<I>();

//     Stream<I> inputStream;

//     if (transformInput != null) {
//       inputStream = transformInput(controller.stream).asBroadcastStream();
//     } else {
//       inputStream = controller.stream.asBroadcastStream();
//     }
//     inputSubscription = inputStream.listen(null);

//     Stream<O> observableOutput;
//     switch (convertType) {
//       case ConvertType.flatMap:
//         observableOutput = inputStream.flatMap(process);
//         break;
//       case ConvertType.switchMap:
//         observableOutput = inputStream.switchMap(process);
//         break;
//       // case ConvertType.concatMap:
//       //   observableOutput = inputStream.concatMap(process);
//       //   break;
//       default:
//         break;
//     }

//     if (transformOutput != null) {
//       observableOutput = transformOutput(observableOutput);
//     }
//     observableOutput = observableOutput.asBroadcastStream();

//     _subscription = observableOutput.listen((O value) {
//       _lastestValue = value;
//     });

//     outputSubscription = observableOutput.listen(null);

//     outputStream = DeferStream(() => observableOutput.startWith(_lastestValue),
//         reusable: true);
//   }

//   O get output => _lastestValue;
//   set input(I value) => controller.add(value);

//   dispose() {
//     outputSubscription.cancel();
//     inputSubscription.cancel();
//     _subscription.cancel();
//     controller.close();
//     outputStream.drain();
//   }
// }
