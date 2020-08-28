import 'package:customized_streams/customized_streams.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TransformerSubject<String, int> _transformerSubject;
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _transformerSubject =
        TransformerSubject<String, int>(_transformCountLength);
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _transformerSubject.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Stream<int> _transformCountLength(String text) async* {
    yield text.length;
  }

  void _onCountLength() {
    _transformerSubject.add(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(height: 30.0),
          Text("Enter a word:"),
          TextField(
            controller: _textEditingController,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
              child: Text("Count length of word"), onPressed: _onCountLength),
          SizedBox(height: 40.0),
          StreamBuilder<int>(
              stream: _transformerSubject.outputStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) return SizedBox();
                int wordLength = snapshot.data;
                return Text("Length of " +
                    _transformerSubject.inputValue +
                    " is " +
                    wordLength.toString());
              })
        ]),
      ),
    );
  }
}
