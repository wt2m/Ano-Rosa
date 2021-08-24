import 'package:dio/dio.dart';
import '../extension/hextocolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anorosa/models/Usuario.dart';
import 'package:anorosa/models/Token.dart';
import 'package:anorosa/persistencia/BD.dart';
import 'package:anorosa/view/button_navigation.dart';
import 'dart:convert';
import 'package:anorosa/services/conexao.dart';
@override
final Color corprincipal = HexColor.fromHex('f06e9c');

Dio _dio = new Dio(conexao());
///Cadastrar usuário
cadastrarUser(String email, String senhauser, String nomeuser, context) async {
  //var booleano = true;
  Response response;
  try{
    response = await _dio.post("$url/api/usuario/add", data: {
      "email": email,
      "password": senhauser,
      "name": nomeuser
    });
  }catch(e){}
  var resul = json.decode(response.toString());
  print(resul);
  if(resul['status'] == null){
    
    return toast("Email já cadastrado");
      
  }else{
    loginuser(email, senhauser, context);
  }
}

///Realizar o login do usuário
loginuser(String email, String senhauser, context) async{
  var db = new BD();
  Response response;
   try{
    response = await _dio.post("$url/api/usuario/login",data: {
      "email": email,
      "password": senhauser,
    });
   }catch(e) {
     print(e);
     return toast("Falha ao conectar");
  }
  var resul = json.decode(response.toString());
  if(resul['authenticated'] == false){
    toast(resul['error']);
    return null;
  }else{
    print(resul);
    await db.inserirToken(new Token(resul['access_token']));
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) =>new Navegar(3)),
      (Route<dynamic> route) => false,);
  }
}
   

///Resgatar informações do usuário que está logado
usuariologado(var tokens) async{
  Response response;
  var db = new BD();
  if (tokens == null){
    tokens = await db.pegarToken();
  }
  if(tokens.length!=0){
    String token = Token.fromMap(tokens[0]).accesstoken;
    try{response = await _dio.post("$url/api/usuario/logado?token=$token");
    }catch(e){
      //await db.resetarTabelaToken();
      //toast("Favor, logue novamente");
      return null;
    }
    var resul =json.decode(response.toString());
    if(resul['status'] == false){
      db.resetarTabelaToken();
      toast("Favor, logue novamente");
      return null;
    }else{
      print(resul);
      return resul;
    }
    
  }else{
    return null;
  }
}

///Editar usuário
editarusuario(String name, String email, String password, String foto, int id, context) async{
  Map json1 = {"password":password};
  Response response;
  if(name != null){
    json1['name'] = name;
  }
  if(email != null){
    json1['email'] = email;
  }
  if(foto!= null){
    json1['fotouser'] = foto;
  }
  var db = new BD();
  var tokens = await db.pegarToken();
  var jsonfinal = json.encode(json1);
  String token = Token.fromMap(tokens[0]).accesstoken;
  print(jsonfinal);
 //print(id);
  try{response = await _dio.put("$url/api/usuario/update/$id",data:json1, 
    options: Options(receiveTimeout: 50000,
    headers:{
        "Authorization": "Bearer $token"
      }
  ));
  }catch(e){
    print(e);
    return toast("Tente novamente");
  }

  var resul =json.decode(response.toString());
  if(resul['status'] == true){
    return Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) =>new Navegar(3)),
      (Route<dynamic> route) => false,);
  }else{
    return toast(resul['error']);
  }
  
}
////Deslogar usuario
logout(context) async{
  Response response;
  var db = new BD();
  var token1 = await db.pegarToken();
  if(token1.length!=0){
    String token = Token.fromMap(token1[0]).accesstoken;
    try{response = await _dio.post("$url/api/usuario/logout?token=$token");
    }catch(e){
    }
    var resul =json.decode(response.toString());
    //print(resul);
    if(resul['status']== true){
      toast(resul['message']);
      await db.resetarTabelaToken();
      return Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) =>new Navegar(3)),
      (Route<dynamic> route) => false,);
    }else{
      toast("Falha ao sair");
    }
  }else{
    toast("Nenhum usuario logado.");
  }
  
}

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












