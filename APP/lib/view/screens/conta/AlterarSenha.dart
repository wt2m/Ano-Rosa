import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:anorosa/view/screens/conta/Conta.dart';


const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
final Color corprincipal = HexColor.fromHex('f06e9c');
final Color cortela = HexColor.fromHex('fad2e0');
final String lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque scelerisque purus fringilla sapien lacinia blandit. Aliquam pulvinar eros lacus, accumsan cursus velit pulvinar eu. Suspendisse eget fermentum tellus. Sed dignissim.";
class AlterarSenha extends StatefulWidget {
  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final _formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    
    var appBar = AppBar();
    double screenheightsize = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar senha'),
        backgroundColor: corprincipal,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      child: new Container(child: ListView(children: <Widget>[
        Container(height: screenheightsize*0.2),
        Container(
          height: screenheightsize*0.6, 
          child: Row(children: <Widget>[
            Expanded(flex: 2, child: Container(),),
            Expanded(flex: 6, child: Container(
              decoration: BoxDecoration(border: Border.all(color: corprincipal,width: 1)),
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Expanded(flex: 4, child: Center(
                  child: Icon(Icons.lock, color: corprincipal, size: 75,),
                ),),
                Expanded(flex: 3, child: Container(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                      labelText: "Senha antiga"
                      ),
                      validator: (String arg) {
                        if(arg.length < 3)
                          return 'O Nome deve ter mais de 2 caracteres';
                        else
                          return null;
                      },
                    ))
                  /*TextField(
                    decoration: InputDecoration(
                      hintText: "Senha antiga"
                    )),*/),),
                Expanded(flex: 3, child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Nova senha"
                    )),),),
                Expanded(flex: 3, child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Confirmar nova senha"
                      
                    )),),),
                Expanded(flex: 2, child: Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    disabledColor: corprincipal,
                    disabledTextColor: Colors.black,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Conta()),
            );
                      }
                    },
                    child: Text('Alterar senha'),),
                ),)
              ],),
            ),),
            Expanded(flex: 2, child: Container(),),
          ],),),
        Container(height: screenheightsize*0.2),
      ],)
    )
    )
    );
  }
}
