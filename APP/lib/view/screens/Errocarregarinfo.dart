import 'package:flutter/material.dart';

Widget erroAPI(context, double screenheightsize, String textobotao,void Function() onpressed){
  return Container( ///tela caso a api não seja consultada ou não retorne nada.
        alignment: Alignment.center,
        child: Center(
         child: Column(children: <Widget>[
           Container(height: screenheightsize *.4,),
           Text('Houve um erro ao carregar as informações.'),
           RaisedButton(
             child: Text(textobotao),
             onPressed: (){
               onpressed();
             },)
          ]),
       ),
      );
}