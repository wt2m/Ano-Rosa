import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:anorosa/extension/NoGlowBehavior.dart';
import 'package:anorosa/view/button_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
double media;
final String altasuspeita =
    "   Baseado em suas respostas, o seu caso se enquadra como suspeito de câncer de mama. É aconselhável que você busque atendimento médico para uma melhor análise.";
final String mediasuspeita =
    "   Baseado em suas respostas, o seu caso pode se enquadrar como suspeito de câncer de mama. É aconselhavel que você buse atendimento médico para uma melhor analise.";
final String baixasuspeita =
    "   Baseado em suas respostas, a probabilidade do seu caso se encaixar como suspeito de câncer de mama é baixa. Entretanto, não deixe de manter os exames médicos em dia. Ao manter os exames em dia, você aumenta as chances do encontro precoce do câncer de mama, evitando tratamentos agressivos.";
final String semsuspeita =
    "   Baseado em suas respostas, o seu caso não se enquadra como suspeito de câncer de mama. Entretanto, não deixe de manter os exames médicos em dia. Ao manter os exames em dia, você aumenta as chances do encontro precoce do câncer de mama, evitando tratamentos agressivos.";

class Resultado extends StatefulWidget {
  Resultado(double amedia) {
    media = amedia;
    print("media = $media");
  }
  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  @override
  Widget build(BuildContext context) {
    double altorisco = 70.0;
    double mediorisco = 50.0;
    double baixorisco = 25.0;
    var appBar = AppBar();
    double screenheightsize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado',
            style: GoogleFonts.poppins(
              letterSpacing: 0,
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: corprincipal,
      ),
      //corpo da aplicação, aqui são setadas as telas
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: screenheightsize * 0.05),
              height: screenheightsize * 0.2,
              child: Center(
                child: Image.asset('lib/assets/logo.png'),
              )),
          Container(
            margin: EdgeInsets.only(
                top: screenheightsize * 0.05,
                bottom: screenheightsize * 0.01,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child: media >= altorisco
                ? Text(
                    altasuspeita,
                    style: GoogleFonts.poppins(
                      letterSpacing: 0,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  )
                : media >= mediorisco
                    ? Text(
                        mediasuspeita,
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      )
                    : media >= baixorisco
                        ? Text(
                            baixasuspeita,
                            style: GoogleFonts.poppins(
                              letterSpacing: 0,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.justify,
                          )
                        : Text(
                            semsuspeita,
                            style: GoogleFonts.poppins(
                              //textStyle: Theme.of(context).textTheme.display1,
                              letterSpacing: 0,
                              fontSize: 20,

                              //fontWeight: FontWeight.bold,
                              //fontStyle: FontStyle.values,
                            ),
                            textAlign: TextAlign.justify,
                          ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: screenheightsize * 0.01,
            ),
            margin: EdgeInsets.only(
                bottom: screenheightsize * 0.01,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              "*O resultado do autoexame não é um dignóstico e não substitui a mamografia ou consultas médicas.",
              style: GoogleFonts.poppins(
                  letterSpacing: 0, fontSize: 12, fontWeight: FontWeight.w200),
              textAlign: TextAlign.justify,
            ),
          ),
          media <= baixorisco
              ? Container()
              : Container(
                  padding: EdgeInsets.only(
                    top: screenheightsize * 0.01,
                  ),
                  margin: EdgeInsets.only(
                      bottom: screenheightsize * 0.01,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    "   Verifique no mapa os médicos próximos a você e agende uma consulta!",
                    style: GoogleFonts.poppins(
                      letterSpacing: 0,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
          Container(
            height: screenheightsize * 0.2,
            child: media <= baixorisco
                ? Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Navegar(1)),
                          (Route<dynamic> route) => false,
                        );
                      },
                      textColor: Colors.white,
                      color: corprincipal,
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Voltar a tela inicial",
                          style: GoogleFonts.poppins(
                            letterSpacing: 0,
                            fontSize: 15,
                          )),
                    ))
                : Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Navegar(2)),
                          (Route<dynamic> route) => false,
                        );
                      },
                      textColor: Colors.white,
                      color: corprincipal,
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ir ao mapa',
                          style: GoogleFonts.poppins(
                            letterSpacing: 0,
                            fontSize: 15,
                          )),
                    )),
          )
        ]),
      ),
      backgroundColor: cortela,
    );
  }
}
