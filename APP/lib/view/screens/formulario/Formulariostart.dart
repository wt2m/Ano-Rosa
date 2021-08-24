import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import '../formulario/Preencher.dart';
import 'package:anorosa/extension/NoGlowBehavior.dart';
import 'package:google_fonts/google_fonts.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String preFormulario =
    "   O autoexame é aconselhado apenas como forma de autocuidado, o resultado não deverá ser tomado como diagnóstico e não substitui a mamografia ou exames físicos realizados por um profissional da saúde.";

class Formulariostart extends StatefulWidget {
  @override
  _FormulariostartState createState() => _FormulariostartState();
}

class _FormulariostartState extends State<Formulariostart> {
  //método de click ao botão do button navigation
  @override
  void _onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar();
    double screenheightsize = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).size.height * .06;
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar formulário',
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
        child: ListView(
          children: <Widget>[
            Container(
              height: screenheightsize * 0.05,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              height: screenheightsize * 0.65,
              child: Center(
                child: Text(
                  preFormulario,
                  style: GoogleFonts.poppins(
                    //textStyle: Theme.of(context).textTheme.display1,
                    letterSpacing: 0,
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.values,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Container(
              height: screenheightsize * 0.3,
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Preencher()));
                  },
                  textColor: Colors.white,
                  color: corprincipal,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Entendi, leve-me ao autoexame!',
                      style: GoogleFonts.poppins(
                        //textStyle: Theme.of(context).textTheme.display1,
                        letterSpacing: 1,
                        fontSize: 20,

                        //fontWeight: FontWeight.bold,
                        //fontStyle: FontStyle.values,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: cortela,
    );
  }
}
