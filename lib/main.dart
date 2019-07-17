import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import 'get_string.dart';
// import 'support.dart';
// import "tts_helper.dart";
import 'value_listener.dart';

void main() {
  ListenerBox.instance.el('lsner1'); //文本内容监听器
  ListenerBox.instance.el('lsner2'); //目录内容监听器
  ListenerBox.instance.el('lsner3'); //未用监听器
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bk = Bookdata();
    getMenuList(bk);
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
  MyHomePage({Key key, this.title}) : super(key: key) {
    this.tts.isLanguageAvailable("zh-CN").then((value) {
      if (value) {
        this.tts.setLanguage("zh-CN");
      } else {
        print("set tts language to zh-CN $value is false,");
      }
    });
  }
  final tts = Mytts8();
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void showPage() {
    getpagedata(ListenerBox.instance.getel('lsner1'));
  }

  @override
  Widget build(BuildContext context) {
    ListenerBox.instance.getel('lsner1').afterSetter = () {
      print("lsner1.after.setter");
      setState(() {});
    };
    ListenerBox.instance.getel('lsner2').afterSetter = () {
      setState(() {});
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // body: WordPage(
      //     document: Textsheet.getTextsheetChain(ListenerBox.instance.getel('lsner1').value),
      //     tts: this.widget.tts,
      //     fn: () {
      //       print("this reading is over ,this page");
      //     }),
      body: Container(
        child: Text(ListenerBox.instance.getel('lsner2').value.toString(),softWrap: true,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPage,
        tooltip: '跳转',
        child: Icon(Icons.add),
      ),
    );
  }
}
