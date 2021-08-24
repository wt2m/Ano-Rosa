import Leaflet from 'leaflet';
import mapMarkerImg from '../../../imagens/pinmapa.png';

const mapIcon = Leaflet.icon({
  iconUrl: mapMarkerImg,

  iconSize: [30, 30],
  iconAnchor: [29, 68],
  popupAnchor: [0, -60]
});

export default mapIcon