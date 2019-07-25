import 'package:mytts8/mytts8.dart';

class Bookdata {
  String name;
  String baseUrl;
  String menuUrl;

  String menuSoupTag;
  String menuPattan;
  List menudata;
  num selected;

  Bookdata({this.name, this.baseUrl, this.menuUrl, this.menuPattan, this.menudata, this.menuSoupTag,this.selected});
}

class ListenerBox {
  static final Map<String, MyListener> _box = {};
  static ListenerBox _instance;

  static ListenerBox get instance => _getInstance();
  factory ListenerBox() => _getInstance();
  ListenerBox._internal();

  void el(String name) {
    if (name.isNotEmpty && ListenerBox.instance.getel(name) == null  ) _box[name] = new MyListener();
  }

  MyListener getel(String name) {
    if (name.isEmpty || _box[name] == null) return null;
    return _box[name];
  }

  static ListenerBox _getInstance() {
    if (_instance == null) _instance = new ListenerBox._internal();

    return _instance;
  }
}

class MyListener {
  dynamic _v = "初始";
  Function onGetter = () {};
  Function onSetter = () {};
  Function afterSetter = () {};
  // Function afterGetter=(){};
  get value {
    this.onGetter();
    return _v;
    // this.afterGetter();
  }

  set value(var va) {
    this.onSetter();
    _v = va;
    this.afterSetter();
  }
}

class StateInit {
  static StateInit _instance ;
  static StateInit get instance =>_instance??new StateInit._internal();
  factory StateInit() =>_instance??new StateInit._internal();
  StateInit._internal() {
    if (StateInit._instance == null) {
      ListenerBox.instance.el('lsner1'); //文本内容监听器
      ListenerBox.instance.el('lsner2'); //目录内容监听器
      ListenerBox.instance.el('bk'); //书本监听器
      ListenerBox.instance.el('bks'); //书本监听器
      ListenerBox.instance.el('tts'); //阅读器

      var bk = Bookdata(
        name: "剑来",
        baseUrl: "http://www.shumil.co/jianlai/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
      );
      ListenerBox.instance.getel("bk").value = bk;
      ListenerBox.instance.getel('bks').value = [bk];
      ListenerBox.instance.getel('tts').value=Mytts8();
    }
  }

}
