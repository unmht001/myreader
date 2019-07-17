import 'package:flutter/material.dart';
import 'package:myreader/get_string.dart';
import 'package:myreader/value_listener.dart';

ListView menu(Bookdata bk,MyListener lsn){
  return ListView(
    children: <Widget>[
      Text(lsn.value.toString(),softWrap: true,)
    ],
  );
}