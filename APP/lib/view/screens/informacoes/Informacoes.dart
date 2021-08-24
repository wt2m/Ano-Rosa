import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:anorosa/services/APIInformacao.dart';
import 'package:anorosa/view/screens/informacoes/quoteInfo.dart';
import '../informacoes/Informacao.dart';
import 'package:anorosa/extension/NoGlowBehavior.dart';
import 'package:anorosa/view/button_navigation.dart';
import 'package:anorosa/view/screens/Errocarregarinfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

final Color corprincipal = HexColor.fromHex('f06e9c');
double screenheightsize;

class Informacoes extends StatefulWidget {
  @override
  _InformacoesState createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  var listainfo;
  var duplicado = 0;
  bool left, right = false;
  List<Quote> quotesLeft = [];
  List<Quote> quotesRight = [];
  bool splash = true;

  conexao() async {
    setState(() {
      duplicado++;
    });
    listainfo = await receberinfo();

    if (listainfo != null) {
      setState(() {
        //listainfo = lista;
        int length = listainfo.length - 1;
        //print("tamanho: $length");
        if (length != 0) {
          left = true;
          for (int i = 0; i <= length; i = i + 2) {
            print("$i:");
            print(listainfo[i]);
            quotesLeft.add(Quote(
                id: listainfo[i]['id'],
                tituloinfo: listainfo[i]['tituloinfo'],
                subtituloinfo: listainfo[i]['subtituloinfo'],
                imageminfo: listainfo[i]['imageminfo'],
                textoinfo: listainfo[i]['textoinfo'],
                url: listainfo[i]['url']));
          }
        }
        if (listainfo.length > 1) {
          right = true;
          for (int i = 1; i <= length; i = i + 2) {
            print("$i:");
            print(listainfo[i]);
            quotesRight.add(Quote(
                id: listainfo[i]['id'],
                tituloinfo: listainfo[i]['tituloinfo'],
                subtituloinfo: listainfo[i]['subtituloinfo'],
                imageminfo: listainfo[i]['imageminfo'],
                textoinfo: listainfo[i]['textoinfo']));
          }
        }
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
    screenheightsize = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).size.height * .06;

    return splash

        ///Tela de carregando enquanto webservice é consultado
        ? Scaffold(
            appBar: AppBar(
              title: Text('Informações',
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
        //Tela após a consulta do webservice
        : Scaffold(
            appBar: AppBar(
              title: Text('Informações',
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
                child: left == true
                    ? ListView(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * .5,
                                transform: Matrix4.identity()
                                  ..translate(0.0, 10.0),
                                child: Container(
                                    margin: EdgeInsets.only(left: 8, right: 4),
                                    child: Column(
                                      children: quotesLeft
                                          .map(
                                            (quote) => quoteTemplate(quote),
                                          )
                                          .toList(),
                                    ))),
                            Container(
                                width: MediaQuery.of(context).size.width * .5,
                                transform: Matrix4.identity()
                                  ..translate(0.0, 10.0),
                                child: right == true
                                    ? Container(
                                        margin:
                                            EdgeInsets.only(right: 8, left: 4),
                                        child: Column(
                                          children: quotesRight
                                              .map(
                                                (quote) => quoteTemplate(quote),
                                              )
                                              .toList(),
                                        ))
                                    : Container())
                          ],
                        ),
                        Container()
                      ])
                    : erroAPI(context, screenheightsize, "Tentar novamente",
                        () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Navegar(1)),
                          (Route<dynamic> route) => false,
                        );
                      })));
  }

  Widget quoteTemplate(quote) {
    String imagem = quote.imageminfo;
    String titulo = quote.tituloinfo;
    String subtitulo = quote.subtituloinfo;
    String texto = quote.textoinfo;
    String url = quote.url;
    String textoc = truncateWithEllipsis(115, texto);

    // print("===========================================");
    print("$imagem, $titulo, $subtitulo, $texto, $url");

    return Container(
        height: screenheightsize * 0.4,
        margin: EdgeInsets.only(top: 10),
        child: new GestureDetector(
            onTap: () => url == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new Informacao(imagem, titulo, subtitulo, texto)))
                : openNav(url),
            child: Card(
              elevation: 8,
              child: Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      'http://www.anorosa.com.br/storage/$imagem',
                                    ))))),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "$titulo",
                            style: GoogleFonts.poppins(
                              letterSpacing: 1,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text("$subtitulo",
                              style: GoogleFonts.poppins(
                                  letterSpacing: 1,
                                  fontSize: 10,
                                  color: Colors.grey
                                  //fontWeight: FontWeight.bold,
                                  )),
                          alignment: Alignment.topRight,
                        ))),
                    Expanded(
                        flex: 4,
                        child: Container(
                          child: Text(
                            "        $textoc",
                            style: GoogleFonts.poppins(
                              letterSpacing: 0,
                              fontSize: 12,

                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }
}

openNav(url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    // can't launch url, there is some error
    throw "Could not launch $url";
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
