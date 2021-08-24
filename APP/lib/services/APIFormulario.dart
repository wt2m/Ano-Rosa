import 'package:dio/dio.dart';
import '../extension/hextocolor.dart';
import 'package:flutter/material.dart';/*
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anorosa/models/Usuario.dart';
import 'package:anorosa/models/Token.dart';
import 'package:anorosa/persistencia/BD.dart';
import 'package:anorosa/view/button_navigation.dart';*/
import 'dart:convert';
import 'package:anorosa/services/conexao.dart';
@override
final Color corprincipal = HexColor.fromHex('f06e9c');


Dio _dio = new Dio(conexao());

//Receber formulários
receberform() async{
  Response response;
  try{
    response = await _dio.get("$url/api/formulario/showall");
  }catch(e){
    print(e);
    return null;
  }
  
  var resul = json.decode(response.toString());
  
  if(resul['data'].toString() != "[]"){
    return resul['data'];
  }else{
    return null;
  }
  //return null;
}