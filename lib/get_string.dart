import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";

import 'package:gbk2utf8/gbk2utf8.dart';

import "value_listener.dart";

class PageOp {
  static charsetS(Response rp, {String charset: "utf8"}) {
    if (charset == 'gbk')
      return Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
    else if (charset == 'utf8')
      return Utf8Decoder().convert(rp.data);
    else
      return 'unknow charset : $charset';
  }

  static getmenudata({Bookdata book}) async => await getS(book ?? ListenerBox.instance['bk'].value);

  static getpagedata({Bookdata book ,MyListener lsner}) async {

    var lsn = lsner ??ListenerBox.instance['pagedoc'];
    if (lsn==ListenerBox.instance['pagedoc']) ListenerBox.instance['cpLoaded'].value=false;
    Bookdata bk = book ?? ListenerBox.instance['bk'].value;
    try {
      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );
      lsn.value = "等待";
      var response = await dio.get(bk.baseUrl + bk.menudata[bk.selected][0]);
      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: bk.siteCharset).toString());
        var _ss = soup.find(id: bk.contentSoupTap);
        var mch = _ss != null ? RegExp(bk.contentPatten, multiLine: true).allMatches(_ss.outerHtml) : null;
        
        lsn.value = mch.length != 0 ? Beautifulsoup(mch.first.group(1).toString()).doc.body.text : "没有找到";
        
      } else
        lsn.value = "Request failed with status: ${response.statusCode}.";
        if (lsn==ListenerBox.instance['pagedoc']) ListenerBox.instance['cpLoaded'].value=true;
    } catch (e) {
      lsn.value = e.toString();
    }
  }

  static getS(Bookdata bk) async {
    var lsn = ListenerBox.instance['menu'];
    try {
      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );
      lsn.value = "等待";
      Response response = await dio.get(bk.baseUrl + bk.menuUrl);

      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: bk.siteCharset).toString());
        var s1 = soup(bk.menuSoupTag);
        var s2 = RegExp(bk.menuPattan, multiLine: true).allMatches(s1.outerHtml);
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
}
