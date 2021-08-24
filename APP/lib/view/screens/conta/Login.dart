//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anorosa/services/APIUsuario.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
double screensizef;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  var appBar = AppBar();
  String email, senha;
  String emailcadas, senhacadas, nomecadas, confirmarsenha;
  bool telaatual = true;
  bool telaatual2 = true;
  bool telaatual3 = true;
  bool start = true;
  bool loading = false;
  Duration animacao = Duration(milliseconds: 300);

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => animacaoinicial());
  }

  animacaoinicial() {
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      setState(() {
        start = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    screensizef = screensize;
    return Scaffold(
      resizeToAvoidBottomInset: loading ? false : true,
      appBar: AppBar(
        title: telaatual
            ? Text('Login',
                style: GoogleFonts.poppins(
                  letterSpacing: 0,
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ))
            : Text('Cadastro',
                style: GoogleFonts.poppins(
                  letterSpacing: 0,
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
        backgroundColor: corprincipal,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
                child: Stack(children: <Widget>[
              Container(
                  child: start
                      ? _stateInicial()
                      : AnimatedOpacity(
                          opacity: 1,
                          duration: animacao,
                          child: AnimatedContainer(
                              duration: animacao,
                              color: cortela,
                              height: screensizef * 0.25,
                              child: AnimatedOpacity(
                                opacity: 1,
                                duration: animacao,
                                child: Center(
                                    child: Image.asset('lib/assets/logo.png')),
                              )),
                        )),
              Container(
                  //height: MediaQuery.of(context).size.height * 0.6,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.27),
                  child: telaatual
                      ? AnimatedContainer(
                          duration: animacao,
                          transform: telaatual2
                              ? _stateLogintoCadas(1)
                              : _stateLogintoCadas(2),
                          child: AnimatedContainer(
                            duration: animacao,
                            transform:
                                start ? _stateFormStart() : Matrix4.identity()
                                  ..translate(0.0, 0.0),
                            child: Column(children: <Widget>[
                              Container(
                                transform: Matrix4.identity()
                                  ..translate(0.0, 0.0),
                                margin: EdgeInsets.only(top: 30.0),
                                child: new Form(
                                  key: _key,
                                  autovalidate: _validate,
                                  child: _formLoginUI(),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 30, bottom: 10),
                                  child: Center(
                                      child: RaisedButton(
                                    padding: EdgeInsets.all(10),
                                    elevation: 8,
                                    color: corprincipal,
                                    disabledColor: corprincipal,
                                    disabledTextColor: Colors.black,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      _sendFormLogin();
                                    },
                                    child: Text('Entrar',
                                        style: GoogleFonts.poppins(
                                          letterSpacing: 0,
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                    textColor: Colors.black87,
                                  ))),
                              Center(
                                  child: InkWell(
                                //Clickme para a tela de cadastro
                                child: Text('Criar Conta',
                                    style: GoogleFonts.poppins(
                                        letterSpacing: 0,
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline)),
                                onTap: () {
                                  setState(() {
                                    telaatual2 = !telaatual2;
                                  });
                                  Future.delayed(animacao, () {
                                    setState(() {
                                      telaatual = !telaatual;
                                    });
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      setState(() {
                                        telaatual3 = !telaatual3;
                                      });
                                    });
                                  });
                                },
                              ))
                            ]),
                          ),
                        )
                      : AnimatedContainer(
                          duration: animacao,
                          transform: telaatual3
                              ? _stateLogintoCadas(2)
                              : _stateLogintoCadas(1),
                          child: Column(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              child: new Form(
                                key: _key,
                                autovalidate: _validate,
                                child: _formCadastroUI(),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 15, bottom: 8),
                                child: Center(
                                    child: RaisedButton(
                                  padding: EdgeInsets.all(8),
                                  elevation: 6,
                                  color: corprincipal,
                                  disabledColor: corprincipal,
                                  disabledTextColor: Colors.black,
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    _sendFormCadastro();
                                  },
                                  child: Text('Cadastrar',
                                      style: GoogleFonts.poppins(
                                        letterSpacing: 0,
                                        fontSize: 20,
                                        color: Colors.white,
                                      )),
                                  textColor: Colors.black87,
                                ))),
                            Center(
                                child: InkWell(
                              //Clickme para a tela de cadastro
                              child: Text('Entrar',
                                  style: GoogleFonts.poppins(
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline)),
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    telaatual3 = !telaatual3;
                                  });
                                  Future.delayed(animacao, () {
                                    setState(() {
                                      telaatual = !telaatual;
                                    });
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      setState(() {
                                        telaatual2 = !telaatual2;
                                      });
                                    });
                                  });
                                });
                              },
                            ))
                          ]),
                        )),
              Center(
                  child: start
                      ? _stateCardInicial()
                      : AnimatedOpacity(
                          opacity: 1,
                          duration: animacao,
                          child: Card(
                            color: Colors.white,
                            elevation: 8,
                            margin: EdgeInsets.only(top: screensizef * .2),
                            child: Container(
                              child: Center(
                                  child: Icon(
                                Icons.person_outline,
                                color: corprincipal,
                                size: 80,
                              )),
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width * .2,
                            ),
                          ),
                        )),
              loading
                  ? Container(
                      child: Stack(
                        children: <Widget>[
                          Opacity(
                              opacity: .5,
                              child: Container(
                                  margin: EdgeInsets.only(top: 0),
                                  height: screensize,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey)),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            height: screensize,
                            child: Center(
                                child: Card(
                                    elevation: 8,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        height: screensize * .1,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          child: Row(children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator())),
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Carregando...')),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            ),
                                          ]),
                                        )))),
                          )
                        ],
                      ),
                    )
                  : Container()
            ]))),
      ),
    );
  }

  ////////////// Animações
  ///Animação da parte de cima da tela
  //Estado inicial quando a tela abre
  _stateInicial() {
    return AnimatedOpacity(
      opacity: 0,
      duration: animacao,
      child: AnimatedContainer(
          duration: animacao,
          color: cortela,
          height: 0,
          child: AnimatedOpacity(
            duration: animacao,
            opacity: 0,
            child: Center(child: Image.asset('lib/assets/logo.png')),
          )),
    );
  }

  //Card icone usuario

  Widget _stateCardInicial() {
    return AnimatedOpacity(
      opacity: 0,
      duration: animacao,
      child: Card(
        color: Colors.white,
        elevation: 8,
        margin: EdgeInsets.only(top: screensizef * .2),
        child: Container(
          child: Center(
              child: Icon(
            Icons.person_outline,
            color: corprincipal,
            size: 80,
          )),
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .2,
        ),
      ),
    );
  }

  ////Formulário
  _stateFormStart() {
    return Matrix4.identity()..translate(0.0, screensizef);
  }

  _stateLogintoCadas(int i) {
    switch (i) {
      case 1:
        {
          return Matrix4.identity()..translate(0.0, 0.0);
        }
        break;
      case 2:
        {
          return Matrix4.identity()
            ..translate(MediaQuery.of(context).size.width, 0.0);
        }
    }
  }

  //Formulário de login
  Widget _formLoginUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(
            labelText: "Email",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          validator: _validarEmail,
          onChanged: (String val) {
            email = val;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
            decoration: InputDecoration(
              labelText: "Senha",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            obscureText: true,
            validator: _validarSenha,
            onChanged: (String val) {
              senha = val;
            })
      ],
    );
  }

  String _validarEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String _validarSenha(String value) {
    if (value.length < 6) {
      return 'Senha inválida';
    } else {
      return null;
    }
  }

  _sendFormLogin() async {
    if (_key.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await loginuser(email, senha, context);
      setState(() {
        loading = false;
      });
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }

  //Fim do formulário de login

  //Formulário de cadastro

  Widget _formCadastroUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: InputDecoration(
            labelText: "Nome Completo",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.text,
          validator: _validarNomeCadas,
          onChanged: (String val) {
            nomecadas = val;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
          decoration: InputDecoration(
            labelText: "Email",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          validator: _validarEmailCadas,
          onChanged: (String val) {
            emailcadas = val;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
            decoration: InputDecoration(
              labelText: "Senha",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            obscureText: true,
            validator: _validarSenhaCadas,
            onChanged: (String val) {
              senhacadas = val;
            }),
        SizedBox(height: 20),
        new TextFormField(
            decoration: InputDecoration(
              labelText: "Senha",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            obscureText: true,
            validator: _validarConfirmarSenha,
            onChanged: (String val) {
              confirmarsenha = val;
            }),
      ],
    );
  }

  //Validações
  String _validarNomeCadas(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    } else {
      if (value.length > 40) {
        return "Nome muito longo";
      }
    }
    return null;
  }

  String _validarEmailCadas(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String _validarSenhaCadas(String value) {
    if (value.length < 6) {
      return 'A senha precisa de 6 ou mais dígitos';
    } else {
      return null;
    }
  }

  String _validarConfirmarSenha(String value) {
    if (senhacadas != confirmarsenha) {
      return 'As senhas não batem';
    }
    return null;
  }

  //OnPress do botão
  _sendFormCadastro() async {
    if (_key.currentState.validate()) {
      // Sem erros na validação
      //_key.currentState.save();
      setState(() {
        loading = true;
      });
      await cadastrarUser(emailcadas, senhacadas, nomecadas, context);
      setState(() {
        loading = false;
      });
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }
  //Fim do formulário de cadastro

}
