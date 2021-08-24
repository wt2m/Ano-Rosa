import 'package:dio/dio.dart';
import '../extension/hextocolor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:anorosa/services/conexao.dart';
import 'package:anorosa/models/Token.dart';
import 'package:anorosa/persistencia/BD.dart';
import 'package:anorosa/extension/toast.dart';

final Color corprincipal = HexColor.fromHex('f06e9c');

Dio _dio = new Dio(conexao());

//Enviar avaliação
avaliarmedico(
    int iduser, int idmedico, double avaliacao, var comentario) async {
  var db = new BD();
  var token1 = await db.pegarToken();
  String token;
  try {
    token = Token.fromMap(token1[0]).accesstoken;
  } catch (e) {
    token = null;
    toast("Realize login para avaliar");
    return "Error";
  } finally {}
  if (token != null) {
    Response response;
    Map json1 = {
      "valoravaliacao": avaliacao,
      "user_id": iduser,
      "medico_id": idmedico
    };

    if (comentario != null) {
      json1['comentario'] = comentario;
    }
    print(iduser);
    try {
      response = await _dio.post("$url/api/avaliacao/add",
          data: json1,
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } catch (e) {
      return null;
    }
    var resul = json.decode(response.toString());
    if (resul['status'] == true) {
      print('Yay');
    } else {
      toast(resul['error']);
    }
  } else {}
}
