import 'dart:convert';

import 'package:gbk2utf8/gbk2utf8.dart';

main(List<String> args) {
var a="你好,世界";

var b=utf8.decode( unicode2utf8( utf82unicode( utf8.encode(a))));
print(b);  

}
