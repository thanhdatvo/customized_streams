part of customized_streams;

/// An powerful `StreamController` to manage values transformation of `Stream`
///
/// Available features:
/// 1.  Deferable stream that start with the latest value, except for the first `null` value
/// 2.  Broadcast stream
/// 3.  Transform value of stream
///
class StreamTransformer<T> {
  /// Enable/Disabled the deferable ability, default is true
  bool _isDeferred;

  /// Subscribe to update the stored `_value`
  StreamSubscription<T> _valueSubscription;

  /// Hold all the streams that are called from outside
  List<Stream<T>> _streams;

  /// Hold the current transformed value of the stream
  T _value;
  T get value => _value;

  /// If the stream is deferred (`[_isDeferred] == true`),
  /// then time we select stream from stream transformer, a new stream
  /// is created with a started value
  Stream<T> get stream {
    var originalStream = _streams[0];
    if (_isDeferred == true) {
      if (_value == null) return originalStream;
      Stream<T> newStream =
          DeferStream(() => originalStream.startWith(_value), reusable: true)
              .asBroadcastStream();
      _streams.add(newStream);
      return newStream;
    } else {
      return originalStream;
    }
  }

  /// Init by wrapping a stream, transfrom function and a deferable option
  StreamTransformer(Stream<T> stream, Stream<T> Function(Stream<T>) transform,
      {bool isDeferred = true}) {
    if (transform != null) {
      stream = transform(stream);
    }

    stream = stream.asBroadcastStream();

    _valueSubscription = stream.listen((T value) {
      _value = value;
    });

    _streams = [];
    _streams.add(stream);

    _isDeferred = isDeferred;
  }

  /// Close all resources
  dispose() {
    for (Stream<T> stream in _streams) {
      stream.drain();
    }
    _valueSubscription.cancel();
  }
}
