import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude = 0;
  late double longitude = 0;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
