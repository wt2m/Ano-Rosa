//import 'dart:js';

import 'dart:io';

import 'package:anorosa/view/screens/conta/Conta.dart';
import 'package:anorosa/view/screens/formulario/Formulariostart.dart';
import 'package:anorosa/view/screens/informacoes/Informacoes.dart';
import 'package:anorosa/view/screens/mapa/Mapa.dart';
import '../extension/hextocolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int _selectedIndex = 0;
const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color iconeselecionado = HexColor.fromHex('bb285c');



//vetor de classes das telas a serem selecionadas
List<Widget> _stOptions = <Widget>[
  Formulariostart(), //0
  Informacoes(), //1
  Mapa(), //2
  Conta(), //3
];

class Navegar extends StatefulWidget {
  int _opcao;

  Navegar(this._opcao);

  @override
  _NavegarState createState() => _NavegarState(this._opcao);
}

class _NavegarState extends State<Navegar> {
  /// blocks rotation; sets orientation to: portrait
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //método de click ao botão do button navigation
  @override
  void _onItemTapped(int index) {
    
    setState(() {
      _selectedIndex = index;
    });
  }


  Future<bool> _onSair() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Fechar App?'),
            content: new Text('Deseja sair do App?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Não'),
              ),
              new FlatButton(
                onPressed: () {
                  exit(0);
                  //Navigator.of(context).pop(true);
                  /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Navegar(2)),
              );*/
                },
                child: new Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }
  
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    _portraitModeOnly();
    return WillPopScope(
        onWillPop: _onSair,
        child: Scaffold(
          /*appBar: AppBar(
            title: const Text('Avante Itinerante'),
            backgroundColor: corprincipal,
          ),*/

          //corpo da aplicação, aqui são setadas as telas
          body: Center(
              child: _stOptions.elementAt(
            _selectedIndex, //_widgetOptions.elementAt(_selectedIndex,
          )),
          
         bottomNavigationBar:SizedBox(height: screenheight * .06,child:BottomNavigationBar(
           
            type: BottomNavigationBarType.fixed,
            iconSize: screenheight * .04,
            backgroundColor: corprincipal,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                title: Text(''),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text(''),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on) ,
                title: Text(''),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(''),
              ),
            ],
            unselectedItemColor: Colors.black,
            selectedItemColor: iconeselecionado,
            currentIndex: _selectedIndex,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            selectedIconTheme: IconThemeData(size:screenheight*0.045),
            onTap:
                _onItemTapped, //chama o métdodo onItemTapped ao clicar no botao do BTNNavigation
          ),
          
        )));
  }



  //bloco de código para chamar a respectiva tela
  int _opcao;

  @override
  void initState() {
    _selectedIndex = _opcao;
  }

  //construtor
  _NavegarState(this._opcao);
}
