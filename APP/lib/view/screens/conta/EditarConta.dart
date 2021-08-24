import 'dart:io';
import 'package:anorosa/view/screens/informacoes/Informacoes.dart';
import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anorosa/extension/Imgconversor.dart';
import 'package:anorosa/services/APIUsuario.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";
String nameb, emailb, fotouserb;
int idusuario;
String base64;
double screensizef;

class EditarConta extends StatefulWidget {
  EditarConta(String name, String email, String fotouser, int id) {
    nameb = name;
    emailb = email;
    idusuario = id;
    fotouserb = fotouser;
  }

  @override
  _EditarContaState createState() => _EditarContaState();
}

class _EditarContaState extends State<EditarConta> {
  bool loading = false;
  File imagem;
  File imagemTemporaria;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nome, email;
  String senha;
  Duration animacao = Duration(milliseconds: 300);
  bool start = true;
  //final duration = Duration(seconds: 1);

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
    var appBar = AppBar();
    double screensize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    screensizef = screensize;
    return Scaffold(
        resizeToAvoidBottomInset: loading ? false : true,
        appBar: AppBar(
          title: Text('Formulário',
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
                                        child:
                                            Image.asset('lib/assets/logo.png')),
                                  )),
                            )),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: AnimatedContainer(
                        duration: animacao,
                        transform:
                            start ? _stateFormStart() : Matrix4.identity()
                              ..translate(0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: screensize * .1,
                              child: Row(children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Center(
                                      child: Text("Adicionar foto:",
                                          style: GoogleFonts.poppins(
                                            letterSpacing: 0,
                                            fontSize: 15,
                                          )),
                                    )),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    alignment: Alignment.topCenter,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        size: 60,
                                        color: corprincipal,
                                      ),
                                      onPressed: () {
                                        pegarImagemCamera();
                                      },
                                    )),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    alignment: Alignment.topCenter,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        size: 60,
                                        color: corprincipal,
                                      ),
                                      onPressed: () {
                                        pegarImagemGaleria();
                                      },
                                    ))
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              child: new Form(
                                key: _key,
                                autovalidate: _validate,
                                child: _formUI(),
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
                                    _sendForm();
                                  },
                                  child: Text('Alterar informação',
                                      style: GoogleFonts.poppins(
                                        letterSpacing: 0,
                                        fontSize: 20,
                                        color: Colors.white,
                                      )),
                                  textColor: Colors.black87,
                                ))),
                          ],
                        ),
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
                              margin: EdgeInsets.only(top: screensize * .15),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.width * .3,
                                child: Center(
                                    child: imagem == null
                                        ? fotouserb != null
                                            ? Image(
                                                image: NetworkImage(
                                                    'http://anorosa.com.br/storage/$fotouserb'))
                                            : Icon(
                                                Icons.person_outline,
                                                color: corprincipal,
                                                size: 80,
                                              )
                                        : Image.file(imagem)),
                              ),
                            ),
                          ),
                  ),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                      child: Text(
                                                          'Carregando...')),
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
                          /*
                  child: 
                  */
                        )
                      : Container(),
                ])))));
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

  //Puxar formulário
  _stateFormStart() {
    return Matrix4.identity()..translate(0.0, screensizef);
  }

  //Formulário
  Widget _formUI() {
    return new Column(children: <Widget>[
      new TextFormField(
        decoration: InputDecoration(
          labelText: "Nome Completo",
          hintText: nameb,
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
        validator: _validarNome,
        onChanged: (String val) {
          nome = val;
        },
      ),
      SizedBox(height: 20),
      new TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: emailb,
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
    ]);
  }

  //Validações
  String _validarNome(String value) {
    if (value.length != 0) {
      String patttern = r'(^[a-zA-Z ]*$)';
      RegExp regExp = new RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        return "O nome deve conter caracteres de a-z ou A-Z";
      } else if (value.length > 40) {
        return "Nome muito longo";
      }
      return null;
    } else {
      return null;
    }
  }

  String _validarEmail(String value) {
    if (value.length != 0) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return "Email inválido";
      } else {
        return null;
      }
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

  //OnPress do botão
  _sendForm() async {
    if (_key.currentState.validate()) {
      if (imagem != null) {
        converterimg();
      }
      setState(() {
        loading = true;
      });
      await editarusuario(nome, email, senha, base64, idusuario, context);
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

  ///Metodo para pegar imagem da galeria
  void pegarImagemGaleria() async {
    imagemTemporaria = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagem = imagemTemporaria;
    });
  }

  ///Metodo para pegar imagem da câmera
  void pegarImagemCamera() async {
    imagemTemporaria = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imagem = imagemTemporaria;
    });
  }

  ////Metodo que chama a extensão para converter imagem em base64 com await para evitar que
  //imagens grandes bloqueeiem a main thread.
  converterimg() async {
    base64 = await Imgconversor().tobase64(imagem);
  }
}
