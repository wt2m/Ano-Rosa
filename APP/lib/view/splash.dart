import 'dart:async';

import 'package:anorosa/view/button_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'dart:typed_data';


final Color cortela = HexColor.fromHex('fad2e0');
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool starttela = true;
  bool startlogo = true;
  bool progress = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      setState(() {
        starttela = false;
      });
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        setState(() {
          startlogo = false;
        });
        Future.delayed(Duration(milliseconds: 1500)).then((_) {
          setState(() {
            progress = true;
          });
          Future.delayed(Duration(milliseconds: 1800)).then((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navegar(0)));
          });
        });
      });
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double progressx = MediaQuery.of(context).size.height/2 +  MediaQuery.of(context).size.width * .3;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
          child: SingleChildScrollView(
            child: Stack(children: <Widget> [
              AnimatedContainer(
                  margin: EdgeInsets.only(top: 0),
                  height: MediaQuery.of(context).size.height,
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                    gradient: new RadialGradient(
                      radius: starttela ?0.1 :2,
                      colors: [cortela, corprincipal],
                    )
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 0),
                height: MediaQuery.of(context).size.height,
                child: AnimatedOpacity(
                  opacity: startlogo ?0 :1, 
                  duration: Duration(seconds:1),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.width *.5,
                      width: MediaQuery.of(context).size.width *.5,
                      child: Image.asset('lib/assets/logo.png'),
                    )
                  ),
                  ),
              ),
              progress 
              ?Container(
                margin: EdgeInsets.only(top: progressx),
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                ),
              )
              :Container()
            ]),
          ),
        ),
    );
  }
}
//CircularProgressIndicator(),