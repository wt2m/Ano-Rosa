import 'package:anorosa/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
 * primeiro método a ser exeutado pela aplicação
 */

void main() async {
  await DotEnv().load('.env');
  runApp(MaterialApp(
      //materialApp pq vamos usar widgets material design
      title: "Ano Rosa", //titulo da aplicação
      debugShowCheckedModeBanner: false,
      home: Splash() // chamei o login
      ));
}
