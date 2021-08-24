import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:anorosa/extension/gmaps.dart';
import 'package:anorosa/services/APIUsuario.dart';
import 'package:anorosa/services/ApiAvaliacao.dart';
import 'package:google_fonts/google_fonts.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";
var medicoselect;
Position positionuser;

class Medico extends StatefulWidget {
  Medico(var medico, Position user) {
    medicoselect = medico;
    positionuser = user;
  }
  @override
  _MedicoState createState() => _MedicoState();
}

class _MedicoState extends State<Medico> {
  double screenHsize;
  int duplicado = 0;
  bool splash = true;
  var validacaologin;
  int iduser;

  var appBar = AppBar();
  bool start = true;
  Duration duracao = Duration(milliseconds: 300);
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

  conexao() async {
    setState(() {
      duplicado++;
    });
    validacaologin = await usuariologado(null);
    if (validacaologin != null) {
      setState(() {
        print("passou aqui");
        iduser = validacaologin['id'];
      });
    }
    Future.delayed(Duration(milliseconds: 300)).then((_) {
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
    var medicrate =
        (medicoselect['avaliacaototal'] / medicoselect['quantavaliacao'])
            .toStringAsPrecision(2);
    screenHsize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(medicoselect['nomemed'],
              style: GoogleFonts.poppins(
                letterSpacing: 0,
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: corprincipal,
        ),

        //corpo da aplicação, aqui são setadas as telas
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
              child: Stack(children: <Widget>[
            AnimatedOpacity(
              opacity: start ? 0 : 1,
              duration: duracao,
              child: AnimatedContainer(
                duration: duracao,
                transform: start ? _stateFormStart() : Matrix4.identity()
                  ..translate(0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.2)),
                  color: Colors.grey[50],
                ),
                margin: EdgeInsets.only(top: screenHsize * .01),
                padding: EdgeInsets.only(bottom: screenHsize * .01),
                height: screenHsize * .21,
                child: Row(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Center(
                        child: Container(
                            child: ClipOval(
                                child: Image.network(
                                    "http://anorosa.com.br/storage/" +
                                        medicoselect['fotomed'])))),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .03),
                  Container(
                    width: MediaQuery.of(context).size.width * .57,
                    margin: EdgeInsets.only(top: screenHsize * .0625),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .67,
                          child: Text(medicoselect['nomemed'],
                              style: GoogleFonts.poppins(
                                letterSpacing: 0,
                                fontSize: 23,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: screenHsize * .05,
                                child: Row(
                                  children: <Widget>[
                                    RatingBar(
                                      itemSize: screenHsize * 0.025,
                                      initialRating: double.parse(medicrate),
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: corprincipal,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: screenHsize * .006),
                                      child: Text(medicrate,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: screenHsize * .018,
                                              color: Colors.grey)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: screenHsize * .006),
                                      child: Text(
                                          "(" +
                                              medicoselect['quantavaliacao']
                                                  .toString() +
                                              " avaliações)",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: screenHsize * .018,
                                              color: Colors.grey)),
                                    )
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: 0,
                                child: Container(
                                    height: screenHsize * .05,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            AnimatedOpacity(
              duration: duracao,
              opacity: start ? 0 : 1,
              child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05,
                      right: MediaQuery.of(context).size.width * .05,
                      top: screenHsize * .25),
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    Text(
                      "Sobre",
                      style: GoogleFonts.poppins(
                        letterSpacing: 1,
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: screenHsize * 0.01,
                    ),
                    Text(
                      "    " + medicoselect['aboutme'],
                      style: GoogleFonts.poppins(
                        letterSpacing: 0,
                        fontSize: 18,
                        //color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ])),
            ),
            AnimatedOpacity(
              duration: duracao,
              opacity: start ? 0 : 1,
              child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .05,
                    right: MediaQuery.of(context).size.width * .05,
                    top: screenHsize * .45),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                      child: Column(children: <Widget>[
                    Text("Endereço:",
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: screenHsize * .01,
                    ),
                    Text("Rua " + medicoselect['rua'],
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 15,
                          color: Colors.grey,
                          //fontWeight: FontWeight.bold,
                        )),
                    Text(medicoselect['bairro'],
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                    Text(medicoselect['cidade'] + " - " + medicoselect['uf'],
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                    RaisedButton(
                      onPressed: () {
                        MapUtils.openMap(
                            positionuser.latitude,
                            positionuser.longitude,
                            medicoselect['latitude'],
                            medicoselect['longitude']);
                      },
                      padding: EdgeInsets.all(0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Row(children: <Widget>[
                          Container(
                            child: Center(
                                child: Icon(
                              Icons.directions_car,
                              size: MediaQuery.of(context).size.width * .08,
                            )),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .02),
                          Container(
                            child: Center(
                                child: Text("Rotas",
                                    style: GoogleFonts.poppins(
                                      letterSpacing: 0,
                                      color: Colors.black,
                                    ))),
                          ),
                        ]),
                      ),
                    ),
                  ])),
                ),
              ),
            ),
            splash
                ? Container(
                    margin: EdgeInsets.only(top: screenHsize * .7),
                    height: screenHsize * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()))
                : Container(
                    margin: EdgeInsets.only(top: screenHsize * .7),
                    height: screenHsize * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Avalie este médico",
                              style: GoogleFonts.poppins(
                                  letterSpacing: 0,
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          RatingBar(
                            itemSize: 50,
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: corprincipal,
                            ),
                            onRatingUpdate: (rating) {
                              showAlertDialog(context, rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ])),
        ));
  }

  _stateFormStart() {
    return Matrix4.identity()..translate(0.0, -screenHsize * .3);
  }

  showAlertDialog(BuildContext context, double avaliacao) {
    bool comentar = false;
    var comentario = null;
    Widget simButton = FlatButton(
      child: Text('Avaliar',
          style: GoogleFonts.poppins(
            letterSpacing: 0,
            fontSize: 13,
            color: Colors.blueAccent,
          )),
      onPressed: () async {
        avaliarmedico(iduser, medicoselect['id'], avaliacao, comentario);
        Navigator.of(context).pop();
      },
    );
    Widget naoButton = FlatButton(
      child: Text('Cancelar',
          style: GoogleFonts.poppins(
              letterSpacing: 0,
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w300)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Avaliar'),
      content: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: screenHsize * 0.15,
          child: Column(children: <Widget>[
            Text(
              'Você avaliará este médico com $avaliacao estrela(s)',
              style: GoogleFonts.poppins(
                letterSpacing: 0,
                //fontSize: 13,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: screenHsize * 0.025),
            Center(
              child: Text("Adicionar comentário",
                  style: GoogleFonts.poppins(
                    letterSpacing: 0,
                    fontSize: 12,
                    color: Colors.black,
                  )),
            ),
            Center(
              child: Text(
                "Em breve!",
                style: GoogleFonts.poppins(
                  letterSpacing: 0,
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ])),
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
