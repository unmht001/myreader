import 'package:flutter/material.dart';
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
  WordPage({Key key, Textsheet document, Mytts8 tts, Function fn})
      : this.tts =
            tts is String ? new Mytts8() : tts,
        this.document= document is String? new Textsheet():document,
        super(key: key) {
    this.pst.readingCompleteHandler = fn; //设置阅读器读完本页后的动作
    this.pst.currentHL = this.document;
    if (this.document != null) this.document.changeHighlight();
    if (ListenerBox.instance.getel('tts').value is String) {}
  }
  final Mytts8 tts; //用来表示阅读器
  final Pagestate pst = new Pagestate(); //用来表示页面状态
  final Textsheet document; //用来表示 文本数据
  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  _WordPageState() {
    // ListenerBox.instance.getel('lsner1').afterSetter=refreshpage;
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
    List<Widget> wl = chainToWidgetList(this.widget.document);

    return ListView(children: wl);
  }
}
