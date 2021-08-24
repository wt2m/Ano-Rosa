import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';


const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";
class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {

  //método de click ao botão do button navigation
  @override
  void _onItemTapped(int index) {
    setState(() {


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário'),
        backgroundColor: corprincipal,
      ),

      //corpo da aplicação, aqui são setadas as telas
      body: Center(
          child: Text(lorem, style:   optionStyle,)
      ),
      backgroundColor: cortela,
    );
  }
}
