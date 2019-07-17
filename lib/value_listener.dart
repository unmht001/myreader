
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

class ListenerBox {
  static final Map<String, MyListener> _box = {};
  static ListenerBox _instance;

  static ListenerBox get instance => _getInstance();
  factory ListenerBox() => _getInstance();
  ListenerBox._internal();

  static ListenerBox _getInstance() {
    if (_instance == null) {
      _instance = new ListenerBox._internal();
    }
    return _instance;
  }

  void el(String name) {
    if (name.isNotEmpty ) {
      _box[name] = new MyListener();
    }
  }
  MyListener getel(String name){
    if (name.isEmpty){
      return null;
    }
    var _r=_box[name];
    if (_r == null){
      ListenerBox.instance.el(name); 
    }
    return ListenerBox._box[name];
  }
}
