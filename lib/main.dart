import 'package:flutter/material.dart';
// import 'package:myreader/novel_menu_getter.dart';
import 'package:myreader/support.dart';
import 'package:myreader/tts_helper.dart';
import 'package:mytts8/mytts8.dart';

import 'get_string.dart';
// import 'support.dart';
// import "tts_helper.dart";
import 'value_listener.dart';

void main() {
  ListenerBox.instance.el('lsner1'); //文本内容监听器
  ListenerBox.instance.el('lsner2'); //目录内容监听器
  ListenerBox.instance.el('bk'); //书本监听器
  ListenerBox.instance.el('bks'); //书本监听器
  ListenerBox.instance.el('tts'); //阅读器

  //book data init
  var bk = Bookdata();
  bk.name = "剑来";
  bk.baseUrl = "http://www.shumil.co/jianlai/";
  bk.menuUrl = "index.html";
  bk.menuSoupTag = "div.content";
  ListenerBox.instance.getel("bk").value = bk;
  // ListenerBox.instance.getel('lsner1').afterSetter = () {
  //   print("lsner1 setter");
  // };
  ListenerBox.instance.getel('bks').value = [bk];
  //tts init;
  // ListenerBox.instance.getel('tts').value=Mytts8();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (ListenerBox.instance.getel("bk").value is Bookdata) {
      getMenuList(ListenerBox.instance.getel("bk").value);
    }

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
    ListenerBox.instance.getel('tts').value = this.tts;
  }
  final Mytts8 tts = Mytts8();
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListView menu(BuildContext context, Bookdata bk, MyListener lsn) {
    if (bk.menudata is List) {
      return ListView.builder(
          itemCount: bk.menudata.length,
          itemBuilder: (BuildContext context, int index) {
            return FlatButton(
                child: Text(bk.menudata[bk.menudata.length - 1 - index][1].toString(), softWrap: true),
                onPressed: () {
                  getpagedata(ListenerBox.instance.getel('lsner1'));
                });
          });
    } else {
      return ListView(children: <Widget>[Text(lsn.value.toString(), softWrap: true)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ListenerBox.instance.getel('lsner1').value is String)
      ListenerBox.instance.getel('lsner1').value = new Textsheet();

    if (ListenerBox.instance.getel('tts').value is String) ListenerBox.instance.getel('tts').value = new Mytts8();

    ListenerBox.instance.getel('lsner1').afterSetter = () {
      setState(() {
        print("main setstate");
      });
    };
    ListenerBox.instance.getel('lsner2').afterSetter = () {
      setState(() {});
    };

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PageView(
          children: <Widget>[
            ListView.builder(
                itemCount: ListenerBox.instance.getel('bks').value.length,
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    child: Text(ListenerBox.instance.getel('bks').value[index].name),
                    onPressed: () {},
                  );
                }),
            menu(context, ListenerBox.instance.getel('bk').value, ListenerBox.instance.getel('lsner2')),
            WordPage(document: ListenerBox.instance.getel('lsner1').value, tts: ListenerBox.instance.getel('tts').value)
          ],
        ));
  }
}
