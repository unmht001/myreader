import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mytts8/mytts8.dart';

import 'support.dart';
import 'value_listener.dart';

class NoverMainPage extends StatelessWidget {
  final Function getmenudata;
  final Function itemonpress;
  NoverMainPage({Key key, this.getmenudata, this.itemonpress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ListenerBox.instance['bks'].value.length,
        itemBuilder: (BuildContext context, int index) => FlatButton(
            child: Text(ListenerBox.instance['bks'].value[index].name),
            onPressed: () {
              ListenerBox.instance['bk'].value = ListenerBox.instance['bks'].value[index];
              getmenudata();
              if (itemonpress != null) itemonpress();
            }));
  }
}

class MenuPage extends StatelessWidget {
  final Function getpagedata;
  final Function itemonpress;
  MenuPage({Key key, this.getpagedata, this.itemonpress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Bookdata bk = ListenerBox.instance["bk"].value;
    return bk.menudata is List
        ? ListView.builder(
            itemCount: bk.menudata.length,
            itemBuilder: (BuildContext context, int index) => FlatButton(
                child: Text(bk.menudata[bk.menudata.length - 1 - index][1].toString(), softWrap: true),
                onPressed: () {
                  bk.selected = bk.menudata.length - 1 - index;
                  getpagedata();
                  if (itemonpress != null) itemonpress();
                }))
        : ListView(children: <Widget>[Text(ListenerBox.instance['menu'].value.toString(), softWrap: true)]);
  }
}

//文本内容显示阅读页
class ContentPagedata {
  Textsheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

class ContentPage extends StatefulWidget {
  final Mytts8 tts;
  final ContentPagedata pst = new ContentPagedata(); //用来表示阅读器
  final MyListener lsn;
  ContentPage({Key key, Function fn, MyListener lsn})
      : this.tts = gettts(),
        this.lsn = lsn ?? ListenerBox.instance['pagedoc'],
        super(key: key) {
    this.pst.readingCompleteHandler = fn; //设置阅读器读完本页后的动作
  } //用来表示页面状态
  ContentPage.secondPage(String pagename, {Function fn}) : this(lsn: ListenerBox.instance[pagename], fn: fn);
  @override
  _ContentPageState createState() => _ContentPageState();

  static gettts() {
    if (ListenerBox.instance['tts'].value is String) StateInit();
    return ListenerBox.instance['tts'].value;
  }
}

class _ContentPageState extends State<ContentPage> {
  Textsheet document;

  _ContentPageState() : super();

  @override
  Widget build(BuildContext context) =>
      document == null ? ListView(children: <Widget>[]) : ListView(children: chainToWidgetList(document));

  List<Widget> chainToWidgetList(Chain sss) {
    List<Widget> a = [];
    var b = sss;
    while (b != null) {
      a.add(textsheetToWidget(b));
      b = b.son;
    }
    return a;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    document = this.widget.lsn.value is String
        ? Textsheet.getTextsheetChain(this.widget.lsn.value)
        : this.widget.lsn.value as Textsheet;

    this.widget.pst.currentHL = document;
    this.widget.lsn.afterSetter = refreshpage;
    document.changeHighlight();
  }

  reading() async {
    if (await this.widget.tts.isLanguageAvailable('zh-CN'))
      setState(() {
        this.widget.tts.setCompletionHandler(() => setState(() {
              if (this.widget.pst.currentHL.son != null) {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = this.widget.pst.currentHL.son;
                this.widget.pst.currentHL.changeHighlight();
                reading();
              } else {
                this.widget.pst.isReading = !this.widget.pst.isReading;
                this.widget.pst.readingCompleteHandler();
              }
            }));
        this.widget.tts.speak(this.widget.pst.currentHL.text);
      });
    else
      print('language is not available');
  }

  readOrStop() async {
    if (await this.widget.tts.isLanguageAvailable('zh-CN')) {
      setState(() {
        if (this.widget.pst.isReading) {
          this.widget.tts.stop();
          this.widget.pst.isReading = !this.widget.pst.isReading;
        } else {
          this.widget.tts.setCompletionHandler(() {
            setState(() {
              if (this.widget.pst.currentHL.son != null) {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = this.widget.pst.currentHL.son;
                this.widget.pst.currentHL.changeHighlight();
                reading();
              } else {
                this.widget.pst.isReading = !this.widget.pst.isReading;
                this.widget.pst.readingCompleteHandler();
              }
            });
          });
          this.widget.tts.speak(this.widget.pst.currentHL.text);
        }
      });
    } else
      print('language is not available');
  }

  refreshpage() {
    if (this.mounted) setState(() => print("refresh page"));
  }

  setRead() {
    print('fasdfasdfa');
  }

  Widget textsheetToWidget(Textsheet sss) => Container(
      color: sss.cl,
      padding: EdgeInsets.all(5),
      child: GestureDetector(
          child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          onTap: () => setState(() {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = sss;
                this.widget.pst.currentHL.changeHighlight();
                readOrStop();
              })));
}
