import 'package:anorosa/view/screens/Errocarregarinfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anorosa/view/screens/informacoes/Informacoes.dart';
import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:anorosa/extension/NoGlowBehavior.dart';
import 'package:anorosa/services/APIFormulario.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anorosa/view/screens/formulario/Resultado.dart';
import 'dart:io';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
Color corForm = HexColor.fromHex('F7E1F1');
final String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";
enum SingingResposta { a, b, c, d }

class Preencher extends StatefulWidget {
  @override
  _PreencherState createState() => _PreencherState();
}

class _PreencherState extends State<Preencher> {
  int index = 1;
  String image;
  String explicacao, pergunta;
  String alternativa1, alternativa2, alternativa3, alternativa4;
  var indice1, indice2, indice3, indice4;
  var indice;
  int quantpaginas;
  var listaform;
  int duplicado = 0;
  var respostas;
  bool splash = true;
  bool erroapi = false;
  bool infoButton = false;

  SingingResposta _resposta; //Singingresposta.lafayette;
  conexao() async {
    setState(() {
      duplicado++;
    });
    listaform = await receberform();

    if (listaform != null) {
      setState(() {
        quantpaginas = listaform.length;
        image = listaform[0]['imagemexplicativa'];
        explicacao = listaform[0]['explicacaoprotocolo'];
        pergunta = listaform[0]['pergunta'];
        alternativa1 = listaform[0]['alternativa1'];
        alternativa2 = listaform[0]['alternativa2'];
        alternativa3 = listaform[0]['alternativa3'];
        alternativa4 = listaform[0]['alternativa4'];
        indice1 = listaform[0]['indicea1'];
        indice2 = listaform[0]['indicea2'];
        indice3 = listaform[0]['indicea3'];
        indice4 = listaform[0]['indicea4'];
        respostas = new List(quantpaginas);
      });
    } else {
      print("erro");
      setState(() {
        erroapi = true;
      });
    }

    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        splash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (duplicado == 0) {
      conexao();
    }

    var appBar = AppBar();
    double screenheightsize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return splash
        ? Scaffold(
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
            body: Center(
                child: Card(
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
              title: Text('Formulário',
                  style: GoogleFonts.poppins(
                    letterSpacing: 0,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              backgroundColor: corprincipal,
            ),
            body: erroapi
                //Retorna um erro caso a API não seja consultada
                ? erroAPI(context, screenheightsize, "Voltar a tela anterior",
                    () {
                    Navigator.pop(context);
                  })

                //Aqui está a tela
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                child: Column(children: <Widget>[
                              Container(
                                  height: screenheightsize * 0.03,
                                  alignment: Alignment.topRight,
                                  child: Text('$index/$quantpaginas',
                                      style: GoogleFonts.poppins(
                                        //textStyle: Theme.of(context).textTheme.display1,
                                        letterSpacing: 1,
                                        fontSize: 14,
                                        color: Colors.black,
                                        //fontStyle: FontStyle.values,
                                      ))),
                            ])),
                            Container(
                                margin: EdgeInsets.only(
                                    top: screenheightsize * .03),
                                child: Column(children: <Widget>[
                                  Container(
                                      child: Center(
                                    child: Image.network(
                                        'http://www.anorosa.com.br/storage/$image'),
                                  )),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenheightsize * 0.02,
                                        bottom: screenheightsize * 0.01,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: ConstrainedBox(
                                        constraints: new BoxConstraints(
                                          minHeight: screenheightsize * 0.1,
                                          //minWidth: 5.0,
                                          maxHeight: screenheightsize * 0.9,
                                          //maxWidth: 30.0,
                                        ),
                                        child: Text(
                                          "     " + explicacao,
                                          style: GoogleFonts.poppins(
                                            //textStyle: Theme.of(context).textTheme.display1,
                                            letterSpacing: 0,
                                            fontSize: 20,

                                            //fontWeight: FontWeight.bold,
                                            //fontStyle: FontStyle.values,
                                          ),
                                          textAlign: TextAlign.justify,
                                        )),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          bottom: screenheightsize * 0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      padding: EdgeInsets.only(
                                          top: screenheightsize * 0.01),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(width: 1))),
                                      child: Text(
                                        "     " + pergunta,
                                        style: GoogleFonts.poppins(
                                          //textStyle: Theme.of(context).textTheme.display1,
                                          letterSpacing: 0.5,
                                          fontSize: 20,

                                          fontWeight: FontWeight.bold,
                                          //fontStyle: FontStyle.values,
                                        ),
                                        textAlign: TextAlign.justify,
                                      )),
                                  Container(
                                    //margin: EdgeInsets.only(left: 0, right: 20),
                                    //height: screenheightsize * 0.2,
                                    child: radio(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: screenheightsize * 0.02,
                                      bottom: screenheightsize * 0.01,
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(flex: 5, child: botaoback()),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 25),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: index != quantpaginas
                                                    ? Container(
                                                        child: RaisedButton(
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_right,
                                                            size: 50,
                                                          ),
                                                          color:
                                                              Colors.blueAccent,
                                                          onPressed:
                                                              _resposta == null
                                                                  ? null
                                                                  : () {
                                                                      proximo();
                                                                    },
                                                        ),
                                                      )
                                                    : RaisedButton(
                                                        child: Icon(Icons.check,
                                                            size: 50),
                                                        color: Colors.green,
                                                        onPressed:
                                                            _resposta == null
                                                                ? null
                                                                : () {
                                                                    proximo();
                                                                  },
                                                      ))),
                                      ],
                                    ),
                                  ),
                                ]))
                          ],
                        ),
                      ),
                    ),
                  ),
            backgroundColor: cortela,
          );
  }

  infobutton() {
    return Container(
      transform: Matrix4.identity()..translate(0.0, 0.0),
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: infoButton ? 0.7 : 0,
            duration: Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  infoButton = !infoButton;
                });
              },
              child: Container(
                height: infoButton ? MediaQuery.of(context).size.height : 0,
                width: infoButton ? MediaQuery.of(context).size.width : 0,
                decoration: BoxDecoration(color: Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            transform: Matrix4.identity()..translate(0.0, 0.0),
            height: infoButton ? MediaQuery.of(context).size.height * 0.8 : 0,
            width: infoButton ? MediaQuery.of(context).size.width : 0,
            child: Center(
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Image.network(
                        'http://www.anorosa.com.br/storage/$image'),
                  ))),
            ),
          ),
        ],
      ),
    );
  }

  int selected = 0;
  proximo() {
    int dados = index;
    print(dados);
    print("-------");
    print(index);
    print("-------");
    print(quantpaginas);
    print("-------");
    if (index != quantpaginas) {
      if (_resposta != null) {
        selected = 0;
        index++;
        setState(() {
          image = listaform[dados]['imagemexplicativa'];
          explicacao = listaform[dados]['explicacaoprotocolo'];
          pergunta = listaform[dados]['pergunta'];
          alternativa1 = listaform[dados]['alternativa1'];
          alternativa2 = listaform[dados]['alternativa2'];
          alternativa3 = listaform[dados]['alternativa3'];
          alternativa4 = listaform[dados]['alternativa4'];
          indice1 = listaform[dados]['indicea1'];
          indice2 = listaform[dados]['indicea2'];
          indice3 = listaform[dados]['indicea3'];
          indice4 = listaform[dados]['indicea4'];
          respostas[dados - 1] = indice;
          indice = null;
          _resposta = null;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Selecione uma opção",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.black,
            backgroundColor: corprincipal,
            fontSize: 16.0);
      }
    } else {
      respostas[dados - 1] = indice;
      print(respostas);
      double total = 0;
      for (int i = 0; i <= dados - 1; i++) {
        total += respostas[i];
        print(respostas[i]);
      }
      total = double.parse(total.toStringAsPrecision(2));
      double divisao = quantpaginas / 100;
      double media = total / divisao;
      print("Total: $total, media: $media, index: $index");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new Resultado(media)),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget radio() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: selected == 1 ? EdgeInsets.all(2) : EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: selected == 1 ? Colors.green : corForm,
              border: Border.all(width: 1)),
          child: ListTile(
            title: Text(alternativa1),
            leading: Radio(
              value: SingingResposta.a,
              groupValue: _resposta,
              onChanged: (SingingResposta value) {
                setState(() {
                  _resposta = value;
                  indice = indice1;
                  selected = 1;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 5),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: selected == 2 ? EdgeInsets.all(2) : EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: selected == 2 ? Colors.green : corForm,
              border: Border.all(width: 1)),
          child: ListTile(
            title: Text(alternativa2),
            leading: Radio(
              value: SingingResposta.b,
              groupValue: _resposta,
              onChanged: (SingingResposta value) {
                setState(() {
                  _resposta = value;
                  indice = indice2;
                  selected = 2;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 5),
        alternativ3(),
        SizedBox(height: 5),
        alternativ4(),
      ],
    );
  }

  Widget alternativ3() {
    if (alternativa3 != null) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: selected == 3 ? EdgeInsets.all(2) : EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: selected == 3 ? Colors.green : corForm,
            border: Border.all(width: 1)),
        child: ListTile(
          title: Text(alternativa3),
          leading: Radio(
            value: SingingResposta.c,
            groupValue: _resposta,
            onChanged: (SingingResposta value) {
              setState(() {
                _resposta = value;
                indice = indice3;
                selected = 3;
              });
            },
          ),
        ),
      );
    }
    return Container();
  }

  Widget alternativ4() {
    if (alternativa4 != null) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: selected == 4 ? EdgeInsets.all(2) : EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: selected == 4 ? Colors.green : corForm,
            border: Border.all(width: 1)),
        child: ListTile(
          title: Text(alternativa4),
          leading: Radio(
            value: SingingResposta.d,
            groupValue: _resposta,
            onChanged: (SingingResposta value) {
              setState(() {
                _resposta = value;
                indice = indice4;
                selected = 4;
              });
            },
          ),
        ),
      );
    }
    return Container();
  }

  Widget botaoback() {
    if (index > 1) {
      return Container(
          padding: EdgeInsets.only(left: 25),
          alignment: Alignment.centerLeft,
          child: RaisedButton(
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 50,
              ),
              color: Colors.red,
              onPressed: () {
                selected = 0;
                index--;
                int dados = index - 1;
                respostas[dados] = null;
                print(respostas);
                setState(() {
                  image = listaform[dados]['imagemexplicativa'];
                  explicacao = listaform[dados]['explicacaoprotocolo'];
                  pergunta = listaform[dados]['pergunta'];
                  alternativa1 = listaform[dados]['alternativa1'];
                  alternativa2 = listaform[dados]['alternativa2'];
                  alternativa3 = listaform[dados]['alternativa3'];
                  alternativa4 = listaform[dados]['alternativa4'];
                  indice1 = listaform[dados]['indicea1'];
                  indice2 = listaform[dados]['indicea2'];
                  indice3 = listaform[dados]['indicea3'];
                  indice4 = listaform[dados]['indicea4'];
                  indice = null;
                  _resposta = null;
                });
              }));
    }
    return Container();
  }
}
