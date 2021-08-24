import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anorosa/extension/hextocolor.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:anorosa/services/APIMedicos.dart';
import 'package:anorosa/view/screens/mapa/medico.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
//import 'dart:convert';
//import 'package:anorosa/services/conexao.dart';
//import 'package:anorosa/vertice.dart';

final Color corprincipal = HexColor.fromHex('f06e9c');

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

////Métodos e váriaveis do mapa

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
const double pi = 3.1415926535897932;
const double _CAMERA_ZOOM = 19.151926040649414;

class _MapaState extends State<Mapa> {
  var appBar = AppBar();
  int duplicado = 0;

  Position _position;
  CameraPosition _positionini;
  Set<Marker> _markers = Set<Marker>();

  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Completer<GoogleMapController> _controller = Completer();

  void _start() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      _position = res;
      _positionini = CameraPosition(
          target: LatLng(res.latitude, res.longitude),
          zoom: 16.151926040649414);
    });
  }

  void addmarkers() {
    int i = 0;
    double lowerdistance = 9999999;
    while (medicos[i] != null) {
      var medico = medicos[i];
      LatLng _medicoposition = LatLng(medico['latitude'], medico['longitude']);
      var distance = _coordinateDistance(
          _medicoposition.latitude, _medicoposition.longitude);
      double mod = pow(10.0, 1);
      double distanceformat = (distance * mod).round().toDouble() / mod;
      medico["distance"] = distanceformat.toString();
      Marker marker = Marker(
        markerId: MarkerId(i.toString()),
        position: _medicoposition,
        icon: pinLocationIcon,
        draggable: false,
        alpha: 1,
        onTap: () {
          setState(() {
            setPolylines(_medicoposition);
            medicoselecionado = medico;
            pinPillPosition = 0;
          });
        },
      );
      print(distance > lowerdistance);
      if (distance < lowerdistance) {
        lowerdistance = distance;
        setState(() {
          setPolylines(_medicoposition);
          medicoselecionado = medico;
          pinPillPosition = 0;
        });
      }
      _markers.add(marker);
      i++;
    }
  }

  //Calcula distância entre o usuario e o médico
  double _coordinateDistance(lat2, lon2) {
    var lat1 = _position.latitude;
    var lon1 = _position.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  setPolylines(LatLng dest) async {
    var googleAPIKey = DotEnv().env['API_GMAPS'];

    await polylinePoints
        .getRouteBetweenCoordinates(googleAPIKey, _position.latitude,
            _position.longitude, dest.latitude, dest.longitude)
        .then((result) {
      polylineCoordinates.clear();
      if (result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates);
        _polylines.add(polyline);
      });
    });
  }

  //Icone de marcador
  BitmapDescriptor pinLocationIcon;
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'lib/assets/pinmapa.png');
  }

  @override
  void initState() {
    // Seta localização inicial
    _start();
    //_getCurrentLocation();
    setCustomMapPin();
    super.initState();
  }

  ////Animação de start e carregamento de tela

  var carregamento = true;

  ////Conexao api
  ///
  var medicos;
  bool nulo = true;
  bool consultou = false;
  conexao() async {
    setState(() {
      duplicado++;
    });
    var resul = await recebermedicos();
    if (resul != null) {
      setState(() {
        nulo = false;
        medicos = resul;
      });
    }
    setState(() {
      consultou = true;
    });
  }

  ///Widget exibir informações do médico
  double pinPillPosition = -100;
  var medicoselecionado;

  Image medicoimg;
  ////Construção da tela aqui

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).size.height * .06;
    if (duplicado == 0) {
      conexao();
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text('Mapa',
            style: GoogleFonts.poppins(
              letterSpacing: 0,
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: corprincipal,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
              child: Stack(children: <Widget>[
            consultou && _positionini != null
                ? Container(
                    height: screensize,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _positionini,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        Future.delayed(Duration(milliseconds: 700)).then((_) {
                          setState(() {
                            carregamento = false;
                          });
                          addmarkers();
                        });
                      },
                      onTap: (LatLng location) {
                        setState(() {
                          _polylines = {};
                          pinPillPosition = -100;
                        });
                      },
                      myLocationEnabled: true,
                      markers: _markers,
                      polylines: _polylines,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                    )))
                : Container(),
            AnimatedPositioned(
                bottom: pinPillPosition,
                right: 0,
                left: 0,
                duration: Duration(milliseconds: 200),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new Medico(medicoselecionado, _position)));
                      },
                      child: Container(
                          margin: EdgeInsets.all(20),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    blurRadius: 20,
                                    offset: Offset.zero,
                                    color: Colors.grey.withOpacity(0.5))
                              ]),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: 50,
                                    height: 50,
                                    child: ClipOval(
                                        child: medicoselecionado != null
                                            ? medicoselecionado['fotomed'] !=
                                                    null
                                                ? Image.network(
                                                    "http://anorosa.com.br/storage/" +
                                                        medicoselecionado[
                                                            'fotomed'],
                                                    fit: BoxFit.cover)
                                                : Image.asset(
                                                    "lib/assets/usersemfoto.png",
                                                    fit: BoxFit.cover)
                                            : Image.asset(
                                                "lib/assets/usersemfoto.png",
                                                fit: BoxFit.cover))),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(medicoselecionado != null
                                            ? medicoselecionado["nomemed"]
                                            : ""),
                                        Text(
                                            medicoselecionado != null
                                                ? medicoselecionado['cidade'] +
                                                    " - " +
                                                    medicoselecionado['uf']
                                                : "",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text(
                                            medicoselecionado != null
                                                ? medicoselecionado[
                                                        'distance'] +
                                                    "km"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.navigate_next,
                                      color: Colors.blueAccent, size: 40),
                                )
                              ])),
                    ) // end of Container
                    ) // end of Align
                ),
            carregamento && !consultou
                ? Container(
                    height: screensize,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 0),
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container()
          ]))),
    );
  }
}
