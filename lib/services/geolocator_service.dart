import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  static bool serviceEnabled = false;
  static LocationPermission permission = LocationPermission.denied;

  static Future<void> init() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
      }
    }
  }

  static Future<Position> getLocation() async {
    return Geolocator.getCurrentPosition();
  }

  static Stream<Position> getLiveLocation() async* {
    yield* Geolocator.getPositionStream();
  }
}
