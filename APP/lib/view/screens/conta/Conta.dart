//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:anorosa/view/screens/conta/Login.dart';
import 'package:anorosa/view/screens/conta/EditarConta.dart';
import 'package:anorosa/services/APIUsuario.dart';
import 'package:anorosa/extension/NoGlowBehavior.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Constants.dart';
import 'package:anorosa/models/Token.dart';
import 'package:anorosa/persistencia/BD.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";

class Conta extends StatefulWidget {
  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  var validacaologin;
  var tokens;
  int duplicado = 0;
  String name, fotouser, email;
  int id;
  bool splash = true;

  @override
  void _onItemTapped(int index) {
    setState(() {});
  }

  conexao() async {
    setState(() {
      duplicado++;
    });
    validacaologin = await usuariologado(tokens);
    if (validacaologin != null) {
      setState(() {
        //print("passou aqui");
        name = validacaologin['name'];
        fotouser = validacaologin['fotouser'];
        email = validacaologin['email'];
        id = validacaologin['id'];
      });
    }
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        splash = false;
      });
    });
  }

  consultartoken(context) async {
    var db = new BD();
    tokens = await db.pegarToken();
    if (tokens.length == 0) {
      Future.delayed(Duration(milliseconds: 600)).then((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar();
    if (duplicado == 0) {
      consultartoken(context);
      conexao();
    }

    double screenheightsize = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).size.height * .06;
    return splash
        ? Scaffold(
            appBar: AppBar(
              title: Text('Conta',
                  style: GoogleFonts.poppins(
                    letterSpacing: 0,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              backgroundColor: corprincipal,
            ),
            body: Center(
                child: Card(
                    //color: Colors.black,
                    elevation: 8,
                    child: Container(
                        width: MediaQuery.of(context).size.width * .45,
                        height: screenheightsize * .1,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          child: Row(children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                                flex: 2,
                                child:
                                    Center(child: CircularProgressIndicator())),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Carregando...')),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                          ]),
                        )))),
            backgroundColor: Colors.grey[200],
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Conta',
                  style: GoogleFonts.poppins(
                    letterSpacing: 0,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              backgroundColor: corprincipal,
            ),
            body: validacaologin == null
                ? Container(
                    height: screenheightsize,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(),
                        ),
                        Text("Nenhuma conta encontrada.", style: optionStyle),
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text('Logar'),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(),
                        ),
                      ]),
                    ),
                  )
                : ScrollConfiguration(
                    behavior: NoGlowBehavior(),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                //border: Border.all(width: 1),
                                color: cortela,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[600],
                                      blurRadius: 3.0,
                                      spreadRadius: 0.0, //aumenta a sombra
                                      offset: Offset(
                                        0.0, // Horizontal
                                        5.0, // Vertical
                                      ))
                                ]),
                            height: screenheightsize * 0.13,
                            child: Center(
                              child: new ListTile(
                                dense: false,
                                title: title(),
                                leading: leading(),
                                trailing: trailing(),
                              ),
                            )),
                        Container(
                          height: screenheightsize * 0.135,
                          alignment: Alignment.bottomCenter,
                          child: Text("Histórico de formulários",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ),
                        Container(
                          height: screenheightsize * 0.6,
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border(top: BorderSide(width: 1)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[600],
                                              blurRadius: 3.0,
                                              spreadRadius:
                                                  0.0, //aumenta a sombra
                                              offset: Offset(
                                                5.0, // Horizontal
                                                5.0, // Vertical
                                              ))
                                        ]),
                                    child: ListView(
                                      controller: ScrollController(
                                          keepScrollOffset: false),
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  left: BorderSide(width: 1),
                                                  right: BorderSide(width: 1)),
                                              color: cortela),
                                          child: ListTile(
                                            title: Text("Formulario X"),
                                            trailing: Text('01/02/11'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Expanded(flex: 1, child: Container()),
                            ],
                          ),
                        ),
                        Container(
                          height: screenheightsize * 0.135,
                        ),
                      ],
                    ),
                  ));
  }

  Widget leading() {
    if (fotouser != null) {
      return new CircleAvatar(
          backgroundImage:
              NetworkImage('http://anorosa.com.br/storage/$fotouser'),
          radius: 30);
    } else {
      return new CircleAvatar(
        backgroundImage: Image.asset('lib/assets/usersemfoto.png').image,
        radius: 30,
      );
    }
  }

  Widget title() {
    return new Text(
      name,
      style: GoogleFonts.poppins(
        letterSpacing: 0,
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget trailing() {
    return new PopupMenuButton(
        onSelected: trailingSelected,
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice,
                  style: GoogleFonts.poppins(
                    letterSpacing: 0,
                    fontSize: 14,
                    color: Colors.black,
                  )),
            );
          }).toList();
        });
  }

  trailingSelected(String choice) {
    if (choice == Constants.edit) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  new EditarConta(name, email, fotouser, id)));
    }
    if (choice == Constants.singOut) {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget simButton = FlatButton(
      child: Text('Sim'),
      onPressed: () async {
        await logout(context);
        Navigator.of(context).pop();
      },
    );
    Widget naoButton = FlatButton(
      child: Text('Não'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Logout',
          style: GoogleFonts.poppins(
            letterSpacing: 0,
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )),
      content: Text('Você deseja sair de sua conta?',
          style: GoogleFonts.poppins(
            letterSpacing: 0,
            fontSize: 14,
          )),
      actions: <Widget>[
        naoButton,
        simButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }
}
