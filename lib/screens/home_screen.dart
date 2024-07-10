import 'package:dars74_yandexmap/services/geolocator_service.dart';
import 'package:dars74_yandexmap/services/yandex_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController mapController;
  String currentLocationName = "";
  List<MapObject> markers = [];
  List<PolylineMapObject> polylines = [];
  List<Point> positions = [];
  Point? myLocation;
  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    setState(() {
      mapController = controller;

      mapController.moveCamera(
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1,
        ),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: najotTalim,
            zoom: 18,
          ),
        ),
      );
    });
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finish,
  ) {
    myLocation = position.target;
    setState(() {});
  }

  void addMarker() async {
    markers.add(
      PlacemarkMapObject(
        mapId: MapObjectId(UniqueKey().toString()),
        point: myLocation!,
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              "assets/placemark.png",
            ),
            scale: 0.5,
          ),
        ),
      ),
    );

    positions.add(myLocation!);

    if (positions.length == 2) {
      polylines = await YandexMapService.getDirection(
        positions[0],
        positions[1],
      );
    }

    setState(() {});
  }

  void getMyCurrentLocation() async {
    await Geolocator.openLocationSettings();
    // final myPosition = await GeolocatorService.getLocation();
    // print(myPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentLocationName),
        actions: [
          IconButton(
            onPressed: () async {
              currentLocationName =
                  await YandexMapService.searchPlace(myLocation!);
              setState(() {});
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              mapController.moveCamera(
                // animation: const MapAnimation(
                //   type: MapAnimationType.smooth,
                //   duration: 1,
                // ),
                CameraUpdate.zoomOut(),
              );
            },
            icon: const Icon(Icons.remove_circle),
          ),
          IconButton(
            onPressed: () {
              mapController.moveCamera(
                // animation: const MapAnimation(
                //   type: MapAnimationType.smooth,
                //   duration: 1,
                // ),
                CameraUpdate.zoomIn(),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: onMapCreated,
            onCameraPositionChanged: onCameraPositionChanged,
            mapType: MapType.map,
            mapObjects: [
              PlacemarkMapObject(
                mapId: const MapObjectId("najotTalim"),
                point: najotTalim,
                opacity: 1,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      "assets/placemark.png",
                    ),
                    scale: 0.5,
                  ),
                ),
              ),
              ...markers,
              // PlacemarkMapObject(
              //   mapId: const MapObjectId("meningJoylashuvim"),
              //   point: myLocation ?? najotTalim,
              //   icon: PlacemarkIcon.single(
              //     PlacemarkIconStyle(
              //       image: BitmapDescriptor.fromAssetImage(
              //         "assets/bluemarker.png",
              //       ),
              //       scale: 0.5,
              //     ),
              //   ),
              // ),
              // PolylineMapObject(
              //   mapId: const MapObjectId("UydanNajotTalimgacha"),
              //   polyline: Polyline(
              //     points: [
              //       najotTalim,
              //       myLocation ?? najotTalim,
              //     ],
              //   ),
              // ),
              ...polylines,
            ],
          ),
          const Align(
            child: Icon(
              Icons.place,
              size: 60,
              color: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 45,
            left: 10,
            child: FloatingActionButton(
              onPressed: getMyCurrentLocation,
              child: const Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMarker,
        child: const Icon(Icons.add_location),
      ),
    );
  }
}
