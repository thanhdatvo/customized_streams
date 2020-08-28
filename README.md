# CustomizedStreams


## About

CustomizedStreams adds additional capabilities to Dart
[Streams](https://api.dart.dev/stable/dart-async/Stream-class.html) and
[StreamControllers](https://api.dart.dev/stable/dart-async/StreamController-class.html).


CustomizedStreams provides a number of additional Subjects that help 
transfrom type and value of stream. 

## Usage

### Transform stream from one type to another type

```dart
import 'package:customized_streams/customized_streams.dart';

Stream<int> _transformCountLength(String text) async* {
  yield text.length;
}

void main() {
  var ts =
      TransformerSubject<String, int>(_transformCountLength);
  ts.outputStream.listen((data) {
    print("Length of " +
        ts.inputValue +
        " is " +
        data.toString()); // Print: Length of HelloWorld is 11
  }, onDone: () {
    ts.dispose();
  });
  ts.add("Hello World");
}
```

### Defered stream: new stream will initialized with latest value

```dart
import 'package:customized_streams/customized_streams.dart';

Stream<int> _transformCountLength(String text) async* {
  yield text.length;
}

void main() async {
  var ts = TransformerSubject<String, int>(_transformCountLength);
  var inputStream1 = ts.inputStream;
  inputStream1.listen((data) {
    print(data); // ["Hello", "World", "Developer"]
  });
  ts.add("Hello");
  ts.add("World");
  await Future.delayed(Duration(seconds: 1));
  var inputStream2 = ts.inputStream;
  inputStream2.listen((data) {
    print(data); // ["World", "Developer"]
  }, onDone: () {
    ts.dispose();
  });

  ts.add("Developer");
}
```

## Flutter Example
  
#### Install Flutter

In order to run the flutter example, you must have Flutter installed. For installation instructions, view the online
[documentation](https://flutter.io/).

#### Run the app

  1. Open up an Android Emulator, the iOS Simulator, or connect an appropriate mobile device for debugging.
  2. Open up a terminal
  3. `cd` into the `example` directory
  4. Run `flutter doctor` to ensure you have all Flutter dependencies working.
  5. Run `flutter packages get`
  6. Run `flutter run`

## Changelog

Refer to the [Changelog](https://github.com/vo9312/customized_streams/blob/master/CHANGELOG.md) to get all release notes.