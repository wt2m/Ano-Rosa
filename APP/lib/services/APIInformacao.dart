import 'package:dio/dio.dart';
import '../extension/hextocolor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:anorosa/services/conexao.dart';
import 'package:anorosa/extension/toast.dart';

final Color corprincipal = HexColor.fromHex('f06e9c');

Dio _dio = new Dio(conexao());

//Receber informacoes
receberinfo() async{
  Response response;
  try{
    response = await _dio.get("$url/api/informacao/showall");
  }catch(e){
    //toast("Erro ao carregar informações");
    //print(e);
    return null;
  }
  var resul =json.decode(response.toString());
  if(resul['data'] != null){
    return resul['data'];
  }else{
    return null;
  }
  
}
