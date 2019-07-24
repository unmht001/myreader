import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
import 'package:gbk2utf8/gbk2utf8.dart';

import "value_listener.dart";

getMenuList(Bookdata bk) async => await getS(bk);

charsetS(Response rp) => Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));

getS(Bookdata bk) async {
  var lsn = ListenerBox.instance.getel('lsner2');
  try {
    Dio dio = new Dio(
      BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
    );
    lsn.value = "等待";
    Response response = await dio.get(bk.baseUrl + bk.menuUrl);

    if (response.statusCode == 200) {
      var soup = Beautifulsoup(charsetS(response).toString());
      var s1 = soup(bk.menuSoupTag);
      var s2 = RegExp("(<li.+?/li>)", multiLine: true).allMatches(s1.outerHtml);
      var s12 = RegExp("<a\\shref=\"(.+?)\">(.+?)</a>", multiLine: true);
      var _r;

      lsn.value = s2 == null
          ? "没有找到"
          : s2.length == 0
              ? 0
              : bk.menudata = s2
                  .map((vs) =>
                      [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
                  .toList();
    } else
      lsn.value = "Request failed with status: ${response.statusCode}.";
  } catch (e) {
    lsn.value = e.toString();
  }
}

getpagedata() async {
  var lsn = ListenerBox.instance.getel('lsner1');
  try {
    var url = "https://www.23us.so/files/article/html/1/1569/19553493.html";
    Dio dio = new Dio();
    lsn.value = "等待";
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var soup = Beautifulsoup(response.data.toString());
      var _ss = soup.find(id: "#contents");
      lsn.value = _ss != null ? _ss.text : "没有找到";
    } else
      lsn.value = "Request failed with status: ${response.statusCode}.";
  } catch (e) {
    lsn.value = e.toString();
  }
}
