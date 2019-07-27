import 'dart:core';
import 'package:mytts8/mytts8.dart';

class Bookdata {
  String name;
  String baseUrl;
  String menuUrl;

  String menuSoupTag;
  String menuPattan;
  List menudata;
  num selected;
  String siteCharset;

  String contentSoupTap;

  String contentPatten;

  Bookdata({
    this.name,
    this.baseUrl,
    this.menuUrl,
    this.menuPattan,
    this.menudata,
    this.menuSoupTag,
    this.selected,
    this.siteCharset: 'utf8',
    this.contentPatten,
    this.contentSoupTap,
  });
}

class ListenerBox {
  static final Map<String, MyListener> _box = {};
  static ListenerBox _instance;

  static ListenerBox get instance => _getInstance();
  factory ListenerBox() => _getInstance();
  ListenerBox._internal();

  MyListener operator [](String key) => key.isEmpty ? null : (_box[key] ?? (_box[key] = new MyListener()) ?? _box[key]);
  operator []=(String key, MyListener value) => key.isEmpty ? null : _box[key] ?? ((_box[key] = value) ?? _box[key]);

  static ListenerBox _getInstance() => _instance ?? ((_instance = new ListenerBox._internal()) ?? _instance);

  void el(String name) => ListenerBox.instance[name];
  MyListener getel(String name) => ListenerBox.instance[name];

  Iterable<MapEntry> get entries => _box.entries;
  Iterable get keys => _box.keys;
  int get length => _box.length;
  Iterable get values => _box.values;

  void addAll(Map other) => _box.addAll(other);
  void addEntries(Iterable<MapEntry> newEntries) => _box.addEntries(newEntries);
  void clear() => _box.clear();
  void updateAll(MyListener Function(Object key, Object value) update) => _box.updateAll(update);
  void removeWhere(bool Function(Object key, Object value) predicate) => _box.removeWhere(predicate);
  void forEach(void Function(Object key, Object value) f) => _box.forEach(f);

  bool containsKey(Object key) => _box.containsKey(key);
  bool containsValue(Object value) => _box.containsValue(value);
  bool isEmpty() => _box.isEmpty;
  bool isNotEmpty() => _box.isNotEmpty;

  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(Object key, Object value) f) => map(f);
  Map<RK, RV> cast<RK, RV>() => _box.cast();

  putIfAbsent(key, Function() ifAbsent) => _box.putIfAbsent(key, ifAbsent);
  remove(Object key) => _box.remove(key);
  update(key, MyListener Function(Object value) update, {Function() ifAbsent}) =>
      _box.update(key, update, ifAbsent: ifAbsent);

  @override
  noSuchMethod(Invocation mirror) => print('You tried to use a non-existent member:' + '${mirror.memberName}');
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
  static StateInit _instance;
  static StateInit get instance => _instance ?? new StateInit._internal();
  factory StateInit() => _instance ?? new StateInit._internal();
  StateInit._internal() {
    if (StateInit._instance == null) {
      var bk1 = Bookdata(
        name: "剑来",
        baseUrl: "http://www.shumil.co/jianlai/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
      );
      var bk2 = Bookdata(
        name: "还是地球人狠",
        baseUrl: "http://www.shumil.co/huanshidiqiurenhen/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
      );
      var bk3 = Bookdata(
        name: "星辰之主",
        baseUrl: "http://www.shumil.co/xingchenzhizhu/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
      );
      var bk4 = Bookdata(
        name: "黎明之剑",
        baseUrl: "http://www.shumil.co/limingzhijian/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
      );
      var bk5 = Bookdata(
        name: "第一序列",
        baseUrl: "http://www.shumil.co/dixulie/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
      );
      ListenerBox.instance['bk'].value = bk1;
      ListenerBox.instance['bks'].value = [bk1, bk2, bk3, bk4,bk5];
      ListenerBox.instance['isreading'].value=false;
      ListenerBox.instance['cpLoaded'].value=false;
      ListenerBox.instance['tts'].value = Mytts8();
      ListenerBox.instance['speechrate'].value=1.5;
      ListenerBox.instance['pitch'].value=0.8;
      
    }
  }
}
