// import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
import 'package:gbk2utf8/gbk2utf8.dart';

import "value_listener.dart";

// import "dart:convert";
// import 'package:gbk_codec/gbk_codec.dart';

class Bookdata {
  String name;
  String baseUrl;
  String menuUrl;

  String menuSoupTag;
  String menuPattan;
  List menudata;
}

getMenuList(Bookdata bk) async {
  var lsn = ListenerBox.instance.getel('lsner2');
  await getS(bk, lsn);
  // print(lsn.value);
}

charsetS(Response rp) {
  var ss2 = Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
  return ss2;
}

getS(Bookdata bk, MyListener lsn) async {
  try {
    var opt = BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes);

    Dio dio = new Dio(opt);
    lsn.value = "等待";
    Response response = await dio.get(bk.baseUrl + bk.menuUrl);

    if (response.statusCode == 200) {
      var s = charsetS(response);
      var soup = Beautifulsoup(s.toString());
      var s1 = soup(bk.menuSoupTag);
      // print(s1.outerHtml);
      // var s11=Beautifulsoup(s1.outerHtml);
      // var spt="(<div\\sclass=\"list\">.*?</div>)";
      var spt = "(<li.+?/li>)";
      var s11 = RegExp(spt, multiLine: true);
      var s2 = s11.allMatches(s1.outerHtml);
      // var s2=s11("div.list");
      // lsn.value=s2;
      var s12 = RegExp("<a\\shref=\"(.+?)\">(.+?)</a>", multiLine: true);

      if (s2 != null) {
        if (s2.length == 0) {
          lsn.value = 0;
        } else {
          bk.menudata = s2
              .map((vs) {
                var _r = s12.firstMatch(vs.group(1).toString());
                return [_r.group(1).toString(),_r.group(2).toString()];
              })
              .toList();
          lsn.value=bk.menudata;
              
        }
        // print("not null");
        // lsn.value = s2.length.toString();
      } else {
        lsn.value = "没有找到";
      }
    } else {
      lsn.value = "Request failed with status: ${response.statusCode}.";
    }
  } catch (e) {
    lsn.value = e.toString();
  }
}

getpagedata(MyListener lsn) async {
  try {
    var url = "https://www.23us.so/files/article/html/1/1569/19553493.html";
    Dio dio = new Dio();
    lsn.value = "等待";
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var s = response.data;
      var soup = Beautifulsoup(s.toString());

      var _ss = soup.find(id: "#contents");

      if (_ss != null) {
        var _sp = _ss.text;
        lsn.value = _sp;
      } else {
        lsn.value = "没有找到";
      }
    } else {
      lsn.value = "Request failed with status: ${response.statusCode}.";
    }
  } catch (e) {
    lsn.value = e.toString();
  }
}
