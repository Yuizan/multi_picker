import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_picker/multi_picker.dart';


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedValue = "";

  void _incrementCounter() {
    showCupertinoModalPopup(context: context, builder: (cxt){
      return MultiPicker(
        title: "Title",
        confirmText: 'Confirm',
        children: [
          [{10: "a"},{20: "b"},{30: "c"}],
          [{1000: "a1"},{1010: "a2"},{2000: "b1"},{2010: "b2"},{3010: "c1"},{3020: "c2"},{3030: "c3"}],
          [{100000: "a11"},{100010: "a12"},{101000: "a21"},{101010: "a22"},{200000: "b11"},{200010: "b12"},{201000: "b13"},{201010: "c21"},
            {301000: "c11"},{301010: "c12"},{302000: "c21"},{302010: "c22"},{302020: "c23"},{303000: "c31"},{303010: "c32"},{303020: "c33"}],
        ],
        onConfirm: (clickedText){
          this.setState((){
            selectedValue = clickedText.toString();
          });
          clickedText.toString();
          Navigator.of(context).pop();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              selectedValue,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
