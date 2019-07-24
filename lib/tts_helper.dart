import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:myreader/value_listener.dart';
import 'package:mytts8/mytts8.dart';

import 'support.dart';
import 'value_listener.dart';

class Pagestate {
  Textsheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

//文本内容显示阅读页
class WordPage extends StatefulWidget {
  WordPage({Key key, Function fn})
      : this.tts = gettts(),
        super(key: key) {
    this.pst.readingCompleteHandler = fn; //设置阅读器读完本页后的动作
  }
  final Mytts8 tts; //用来表示阅读器
  final Pagestate pst = new Pagestate(); //用来表示页面状态
  static gettts() {
    if (ListenerBox.instance.getel('tts').value is String) StateInit();
    return ListenerBox.instance.getel('tts').value;
  }

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  Textsheet document;

  _WordPageState() : super() {
    document = ListenerBox.instance.getel('lsner1').value is String
        ? Textsheet.getTextsheetChain(ListenerBox.instance.getel('lsner1').value)
        : ListenerBox.instance.getel('lsner1').value as Textsheet;
  }

  @override
  void initState() {
    super.initState();
    this.widget.pst.currentHL = document;
    document.changeHighlight();
  }

  refreshpage() {
    setState(() {
      print("refresh page");
    });
  }

  Widget textsheetToWidget(Textsheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () {
              setState(() {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = sss;
                this.widget.pst.currentHL.changeHighlight();
                readOrStop();
              });
            }));
  }

//  readhandler() {}

  readOrStop() async {
    if (await this.widget.tts.isLanguageAvailable('zh-CN')) {
      setState(() {
        if (this.widget.pst.isReading) {
          this.widget.tts.stop();
          this.widget.pst.isReading = !this.widget.pst.isReading;
        } else {
          this.widget.tts.setCompletionHandler(() {
            setState(() {
              this.widget.pst.isReading = !this.widget.pst.isReading;
              if (this.widget.pst.currentHL.son != null) {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = this.widget.pst.currentHL.son;
                this.widget.pst.currentHL.changeHighlight();
                readOrStop();
              } else {
                this.widget.pst.readingCompleteHandler();
              }
            });
          });
          this.widget.tts.speak(this.widget.pst.currentHL.text);
        }
      });
    } else {
      print('language is not available');
    }
  }

  setRead() {
    print('fasdfasdfa');
  }

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
  Widget build(BuildContext context) {
    ListenerBox.instance.getel('lsner1').afterSetter = refreshpage;
    List<Widget> wl = chainToWidgetList(document);

    return ListView(children: wl);
  }
}
