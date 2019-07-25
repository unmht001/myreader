import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
// import 'package:flutter/widgets.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

import "value_listener.dart";

charsetS(Response rp) => Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));

getMenuList(Bookdata bk) async => await getS(bk);

getpagedata() async {
  var lsn = ListenerBox.instance.getel('lsner1');
  Bookdata bk = ListenerBox.instance.getel('bk').value;
  try {
    // var url = "https://www.23us.so/files/article/html/1/1569/19553493.html";
    Dio dio = new Dio(
      BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
    );
    lsn.value = "等待";
    var response = await dio.get(bk.baseUrl + bk.menudata[bk.selected][0]);
    if (response.statusCode == 200) {
      var soup = Beautifulsoup(charsetS(response).toString());
      var _ss = soup.find(id: "#content");
      var mch =
          _ss != null ? RegExp("</div>[^>]+?(<p>[\\s\\S]+?</p>)", multiLine: true).allMatches(_ss.outerHtml) : null;

      lsn.value = mch.length != 0 ? Beautifulsoup(mch.first.group(1).toString()).get_text() : "没有找到";
    } else
      lsn.value = "Request failed with status: ${response.statusCode}.";
  } catch (e) {
    lsn.value = e.toString();
  }
}

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
