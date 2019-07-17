// import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
import 'package:gbk2utf8/gbk2utf8.dart';

import "value_listener.dart";

// import "dart:convert";
// import 'package:gbk_codec/gbk_codec.dart';



class Bookdata{
  String name;
  String baseUrl;
  String menuUrl;

  String menuSoupTag;
  String menuPattan;
}



getMenuList(Bookdata bk)async{
  bk.name="剑来";
  bk.baseUrl="http://www.shumil.co/jianlai/";
  bk.menuUrl="index.html";
  bk.menuSoupTag=".list";
  var lsn=ListenerBox.instance.getel('lsner2');
  await getS(bk.baseUrl+bk.menuUrl,lsn);
  // print(lsn.value);
  
  
}

charsetS(Response rp){
  // var strs=rp.data.toString();
  // // var s2=Beautifulsoup(strs.toString());
  // // RegExp exp=new RegExp("(?:<meta[^>]*?charset=(\\w+)[\\W]*?>)");
  // // var m=exp.firstMatch(s2.doc.head.innerHtml);
  // // var _r="";
  // // if (m.groupCount!=0){
  // //   _r= m.group(1);
  // // }

  // var sss=Utf8Encoder().convert(rp.data);
  var ss1=gbk2unicode(rp.data);
  var ss2=Utf8Decoder().convert( unicode2utf8(ss1));
  print(ss2);
  

  return ss2;

} 

getS(String url ,MyListener lsn)async{
  try {
      var opt = BaseOptions(
        contentType: ContentType.html,
        responseType: ResponseType.bytes
      );

      Dio dio = new Dio(opt);
      lsn.value = "等待";
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        print('response get');
        var s=charsetS(response);
        
        print(s);
        print('response show over');

        if (s != null) {
          lsn.value = s;
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
