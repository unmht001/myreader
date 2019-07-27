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
      ListenerBox.instance["page"].value = 1;
    });
    ListenerBox.instance['tts'].value = this.tts;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // num page = ListenerBox.instance['page'].value;

  getpage() {
    if (ListenerBox.instance['page'].value == 1)
      return new NoverMainPage(
          getmenudata: PageOp.getmenudata,
          itemonpress: () {
            setState(() {
              ListenerBox.instance['page'].value = 2;
            });
          });
    else if (ListenerBox.instance['page'].value == 2)
      return new MenuPage(
          getpagedata: PageOp.getpagedata,
          itemonpress: () {
            setState(() {
              ListenerBox.instance['page'].value = 3;
            });
          });
    else if (ListenerBox.instance['page'].value == 3)
      return new ContentPage(pageReadOverAction: () {
        if (ListenerBox.instance['bk'].value.selected == 0)
          print('readover');
        else {
          ListenerBox.instance['bk'].value.selected = ListenerBox.instance['bk'].value.selected - 1;
          PageOp.getpagedata();
        }
      });
    else if (ListenerBox.instance['page'].value == 4)
      return Center(
          child: settingPage(context, (double v) {
        setState(() {
          print(v);
        });
      }));
    else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    // print(context.size);
    return Scaffold(
        appBar: AppBar(
            title: Container(
                child: Row(children: <Widget>[
          Container(
              width: 80,
              child: FlatButton(
                  color: ListenerBox.instance['page'].value == 1 ? Colors.yellowAccent : Colors.greenAccent,
                  child: Text("主  页"),
                  onPressed: () {
                    setState(() {
                      ListenerBox.instance['page'].value = 1;
                    });
                  })),
          Container(
              width: 80,
              child: FlatButton(
                  color: ListenerBox.instance['page'].value == 2 ? Colors.yellowAccent : Colors.greenAccent,
                  child: Text("目录页"),
                  onPressed: () {
                    setState(() {
                      ListenerBox.instance['page'].value = 2;
                    });
                  })),
          Container(
              width: 80,
              child: FlatButton(
                  color: ListenerBox.instance['page'].value == 3 ? Colors.yellowAccent : Colors.greenAccent,
                  child: Text("阅读页"),
                  onPressed: () {
                    setState(() {
                      ListenerBox.instance['page'].value = 3;
                    });
                  })),
          Container(
              width: 80,
              child: FlatButton(
                  color: ListenerBox.instance['page'].value == 4 ? Colors.yellowAccent : Colors.greenAccent,
                  child: Text("设置页"),
                  onPressed: () {
                    setState(() {
                      ListenerBox.instance['page'].value = 4;
                    });
                  }))
        ]))),
        body: Container(
          child: getpage(),
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
      print('state init');
      ListenerBox.instance['menu'].afterSetter = () => setState(() {
            print('menu changed');
          });
      ListenerBox.instance['pagedoc'].afterSetter = () => setState(() {
            print('pagedoc changed');
          });
      ListenerBox.instance['bk'].afterSetter = () => setState(() {
            print('bk changed');
          });
      ListenerBox.instance['page'].afterSetter = () => setState(() {
            print('page index changed');
          });
    }
  }
}
