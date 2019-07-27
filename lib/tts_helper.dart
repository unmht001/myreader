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

class SliderC extends StatefulWidget {
  final Function(double) fn;
  final String label;
  SliderC(this.label, {Key key, this.fn}) : super(key: key);

  _SliderCState createState() => _SliderCState(label, fn: fn);
}

class _SliderCState extends State<SliderC> {
  _SliderCState(this.label, {BuildContext context, this.fn}) : super();
  final String label;
  Function(double) fn;
  double mCurrentValue = 0.5;
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text(label),
      Container(
          width: 350,
          child: Slider(
            value: mCurrentValue,
            onChanged: (v) {
              mCurrentValue = (v * 100).toInt() / 100;
              setState(() {
                fn(mCurrentValue);
              });
            },
            min: 0.5,
            max: 2,
            divisions: 15,
            label: '$mCurrentValue',
          ))
    ]);
  }
}

settingPage(BuildContext context, Function(double) onchange) {
  return ListView(children: <Widget>[
    Container(
      height: 50,
    ),
    SliderC("语速", fn: (double v) {
      ListenerBox.instance['tts'].value.setSpeechRate(v / 2);
      onchange(v);
    }),
    SliderC("语调", fn: (double v) {
      ListenerBox.instance['tts'].value.setPitch(v);
      onchange(v);
    }),
    SliderC("未用", fn: (double v) {
      onchange(v);
    })
  ]);
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
  ContentPage({Key key, Function pageReadOverAction, MyListener listerner})
      : this.tts = gettts(),
        this.lsn = listerner ?? ListenerBox.instance['pagedoc'],
        super(key: key) {
    this.pst.readingCompleteHandler = pageReadOverAction; //设置阅读器读完本页后的动作
  } //用来表示页面状态
  ContentPage.secondPage(String pagename, {Function fn})
      : this(listerner: ListenerBox.instance[pagename], pageReadOverAction: fn);
  @override
  _ContentPageState createState() => _ContentPageState();

  static gettts() {
    if (ListenerBox.instance['tts'].value is String) StateInit();
    return ListenerBox.instance['tts'].value;
  }
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) => ListenerBox.instance['document'].value is String
      ? ListView(children: <Widget>[])
      : ListView(children: chainToWidgetList(ListenerBox.instance['document'].value as Textsheet));

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
    ListenerBox.instance['document'].afterSetter = () {};
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ListenerBox.instance['document'].afterSetter = () {
      if (this.mounted) setState(() {});
    };
    this.widget.pst.currentHL = ListenerBox.instance['document'].value = this.widget.lsn.value is String
        ? Textsheet.getTextsheetChain(this.widget.lsn.value)
        : this.widget.lsn.value as Textsheet;
    this.widget.lsn.afterSetter = refreshpage;
    ListenerBox.instance['document'].value.hightLight();
    ListenerBox.instance['cpLoaded'].afterSetter = () {
      if (ListenerBox.instance['isreading'].value && ListenerBox.instance['cpLoaded'].value) startReading();
    };
  }

  continueReading() async {
    if (await this.widget.tts.isLanguageAvailable('zh-CN'))
      setState(() {
        this.widget.tts.setCompletionHandler(() => setState(() {
              if (this.widget.pst.currentHL.son != null) {
                this.widget.pst.currentHL.disHightLight();
                this.widget.pst.currentHL = this.widget.pst.currentHL.son;
                this.widget.pst.currentHL.hightLight();
                continueReading();
              } else {
                this.widget.pst.isReading = false;
                this.widget.pst.readingCompleteHandler();
              }
            }));
        this.widget.tts.speak(this.widget.pst.currentHL.text);
      });
    else
      print('language is not available');
  }

  startReading() async {
    this.widget.pst.isReading = true;
    if (this.widget.lsn == ListenerBox.instance['pagedoc']) ListenerBox.instance['isreading'].value = true;

    continueReading();
  }

  stopReading() async {
    this.widget.pst.isReading = false;
    if (this.widget.lsn == ListenerBox.instance['pagedoc']) ListenerBox.instance['isreading'].value = false;
    this.widget.tts.stop();
    setState(() {});
  }

  refreshpage() {
    this.widget.pst.currentHL = ListenerBox.instance['document'].value = this.widget.lsn.value is String
        ? Textsheet.getTextsheetChain(this.widget.lsn.value)
        : this.widget.lsn.value as Textsheet;
    this.widget.lsn.afterSetter = refreshpage;
    ListenerBox.instance['document'].value.hightLight();
  }

  Widget textsheetToWidget(Textsheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => setState(() {
                  if (this.widget.pst.currentHL != null) this.widget.pst.currentHL.changeHighlight();
                  this.widget.pst.currentHL = sss;
                  this.widget.pst.currentHL.changeHighlight();
                  this.widget.pst.isReading ? stopReading() : startReading();
                })));
  }
}
