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
    if (ListenerBox.instance.getel("bk").value is Bookdata) getMenuList(ListenerBox.instance.getel("bk").value);
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
    ListenerBox.instance.getel('tts').value = this.tts;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PageView(children: <Widget>[
          ListView.builder(
              itemCount: ListenerBox.instance.getel('bks').value.length,
              itemBuilder: (BuildContext context, int index) =>
                  FlatButton(child: Text(ListenerBox.instance.getel('bks').value[index].name), onPressed: () {})),
          menu(context, ListenerBox.instance.getel('bk').value),
          WordPage()
        ]));
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) ListenerBox.instance.getel('lsner2').afterSetter = () => setState(() {});
  }
}
