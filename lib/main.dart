import 'package:flutter/material.dart';
// import 'package:myreader/support.dart';
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
    if ( ListenerBox.instance.getel("bk").value is Bookdata) {
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
                  getpagedata();
                });
          });
    } else {
      return ListView(children: <Widget>[Text(lsn.value.toString(), softWrap: true)]);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            WordPage()
          ],
        ));
  }
}
