import 'package:flutter/material.dart';

class Chain {
  Chain _father;
  Chain _son;
  Chain();
  Chain get father => _father;
  set father(Chain fa) {
    this._father = fa;
    fa._son = this;
  }

  Chain get first => _father == null ? this : _father.first;

  Chain get last => _son == null ? this : _son.son;
  Chain get son => _son;

  set son(Chain fa) {
    fa._father = this;
    this._son = fa;
  }

  Chain born() {
    if (this.son != null) {
      return this.son;
    } else {
      var _r = new Chain();
      _r._father = this;
      _r.father._son = _r;
      return _r;
    }
  }

  static Chain exchange(Chain ch1, Chain ch2) {
    //用 ch1 代替 ch2的位置;返回ch2;
    if (ch2._father != null) ch1.father = ch2.father;
    if (ch2._son != null) ch1.son = ch2.son;
    return ch1;
  }
}

class Textsheet extends Chain {
  static const Color hColor = Colors.yellowAccent; //高亮颜色
  static const Color lColor = Colors.greenAccent; //平常颜色
  Map data = {}; //数据集

  Textsheet() : super() {
    this.data["document"] = ""; //文字
    this.data["highlight"] = false;
  } //获取颜色
  Textsheet.fromMap(mp) : this.fromString(mp['document'], mp['highlight']); //获取文字

  Textsheet.fromString(String document, [bool highlight]) : super() {
    this.data["document"] = document ?? ""; //文字
    this.data["highlight"] = highlight ?? false;
  }

  Color get cl => this.data['highlight'] ? hColor : lColor;
  String get text => data["document"];
  @override
  Chain born() => Chain.exchange(new Textsheet(), super.born());

  changeHighlight() => this.data["highlight"] = !this.data["highlight"];
  hightLight() => this.data["highlight"] = true;
  disHightLight() => this.data["highlight"] = false;
  
  static Textsheet getTextsheetChain(String text) {
    var s = text.split("\n");
    s.removeWhere((test) => test == "");
    if (s == null) {
      return null;
    } else {
      Textsheet ch1;
      Textsheet ch2;
      for (var item in s) {
        if (ch1 == null) {
          ch1 = Textsheet.fromString(item);
          ch2 = ch1;
        } else {
          ch2 = ch2.born();
          ch2.data["document"] = item;
        }
      }
      return ch1;
    }
  }
}
