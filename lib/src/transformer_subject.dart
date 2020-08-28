part of customized_streams;

/// An powerful `StreamController` to manage different types and values transformation of `Stream`
///
/// Available features:
/// 1.  Deferable Input and Output stream that start with the latest value, except for the first `null` value
/// 2.  Broadcast Input and Output stream
/// 3.  Latest Input and Output value, after transforming
/// 4.  Transfrom stream from InputType(`I`) stream to OutputType(`O`) stream
/// 5.  Transfrom value of InputStream and OutputStream
///
class TransformerSubject<I, O> {
  /// Main controller that update the value of the stream
  StreamController<I> _controller;

  StreamTransformer<I> _inputTransformer;
  StreamTransformer<O> _outputTransformer;

  Stream<I> get inputStream => _inputTransformer.stream;
  Stream<O> get outputStream => _outputTransformer.stream;

  I get inputValue => _inputTransformer.value;
  O get outputValue => _outputTransformer.value;

  void add(I value) => _controller.add(value);

  /// Init by providing a tranform function
  TransformerSubject(Stream<O> Function(I) transform,
      {bool isDeferredInput = true,
      bool isDeferredOutput = true,
      Stream<I> Function(Stream<I>) transformInput,
      Stream<O> Function(Stream<O>) transformOutput}) {
    _controller = StreamController<I>();

    _inputTransformer = StreamTransformer(_controller.stream, transformInput,
        isDeferred: isDeferredInput);

    _outputTransformer = StreamTransformer(
        inputStream.flatMap(transform), transformOutput,
        isDeferred: isDeferredOutput);
  }

  /// Close all resources
  dispose() {
    _inputTransformer.dispose();
    _outputTransformer.dispose();
    _controller.close();
  }
}
