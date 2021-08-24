
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static openMap(double latitudeuser, double longitudeuser, double latitudemed, double longitudemed) async {
    String googleUrl = 'https://www.google.com.br/maps/dir/$latitudeuser,$longitudeuser/$latitudemed,$longitudemed';
    print(googleUrl);
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Não foi possível abrir o mapa.';
    }
  }
}