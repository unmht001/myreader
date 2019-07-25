import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myreader/get_string.dart';
import 'package:mytts8/mytts8.dart';

import 'support.dart';
import 'value_listener.dart';

ListView menu(BuildContext context, Bookdata bk) => bk.menudata is List
    ? ListView.builder(
        itemCount: bk.menudata.length,
        itemBuilder: (BuildContext context, int index) => FlatButton(
            child: Text(bk.menudata[bk.menudata.length - 1 - index][1].toString(), softWrap: true),
            onPressed: () {
              bk.selected = bk.menudata.length - 1 - index;
              getpagedata();
            }))
    : ListView(children: <Widget>[Text(ListenerBox.instance.getel('lsner2').value.toString(), softWrap: true)]);

//文本内容显示阅读页
class Pagestate {
  Textsheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

class WordPage extends StatefulWidget {
  final Mytts8 tts;
  final Pagestate pst = new Pagestate(); //用来表示阅读器
  WordPage({Key key, Function fn})
      : this.tts = gettts(),
        super(key: key) {
    this.pst.readingCompleteHandler = fn; //设置阅读器读完本页后的动作
  } //用来表示页面状态
  @override
  _WordPageState createState() => _WordPageState();

  static gettts() {
    if (ListenerBox.instance.getel('tts').value is String) StateInit();
    return ListenerBox.instance.getel('tts').value;
  }
}

class _WordPageState extends State<WordPage> {
  Textsheet document;

  _WordPageState() : super() {
    document = ListenerBox.instance.getel('lsner1').value is String
        ? Textsheet.getTextsheetChain(ListenerBox.instance.getel('lsner1').value)
        : ListenerBox.instance.getel('lsner1').value as Textsheet;
  }

  @override
  Widget build(BuildContext context) => ListView(children: chainToWidgetList(document));

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
    this.widget.pst.currentHL = document;
    ListenerBox.instance.getel('lsner1').afterSetter = refreshpage;
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
