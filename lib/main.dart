import 'package:flutter/material.dart';
import 'package:myreader/tts_helper.dart';
import 'package:mytts8/mytts8.dart';

import 'get_string.dart';
import 'value_listener.dart';

void main() {
  StateInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if (ListenerBox.instance['bk'].value is Bookdata) PageOp.getmenudata(ListenerBox.instance['bk'].value);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  final Mytts8 tts = Mytts8();
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key) {
    this.tts.isLanguageAvailable("zh-CN").then((value) {
      if (value)
        this.tts.setLanguage("zh-CN");
      else
        print("set tts language to zh-CN $value is false,");
    });
    ListenerBox.instance['tts'].value = this.tts;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var page = 1;
  Widget pg = NoverMainPage(
    getmenudata: PageOp.getmenudata,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
                child: Row(children: <Widget>[
          FlatButton(
              color: page == 1 ? Colors.yellowAccent : Colors.greenAccent,
              child: Text("主  页"),
              onPressed: () {
                setState(() {
                  page = 1;
                  pg = NoverMainPage(getmenudata: PageOp.getmenudata, itemonpress: () {});
                });
              }),
          FlatButton(
              color: page == 2 ? Colors.yellowAccent : Colors.greenAccent,
              child: Text("目录页"),
              onPressed: () {
                setState(() {
                  page = 2;
                  pg = MenuPage(getpagedata: PageOp.getpagedata, itemonpress: () {});
                });
              }),
          FlatButton(
              color: page == 3 ? Colors.yellowAccent : Colors.greenAccent,
              child: Text("阅读页"),
              onPressed: () {
                setState(() {
                  page = 3;
                  pg = ContentPage();
                });
              })
        ]))),
        body: Container(
          child: pg,
        ));
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      ListenerBox.instance['menu'].afterSetter = () => setState(() {
            print('menu changed');
          });
      ListenerBox.instance['pagedoc'].afterSetter = () => setState(() {
            print('page changed');
          });
      ListenerBox.instance['bk'].afterSetter = () => setState(() {
            print('bk changed');
          });
    }
  }
}
