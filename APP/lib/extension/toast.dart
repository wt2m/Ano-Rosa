import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anorosa/view/button_navigation.dart';


toast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
        backgroundColor: corprincipal,
        fontSize: 16.0
      );
  }