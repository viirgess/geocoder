// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'dart:math';

class CustomMap extends StatefulWidget {
  const CustomMap({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late MapController mapController;
  double? _markerSize;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _updateMarkerSize(double zoom) {
    setState(() {
      _markerSize = 70.0 * (zoom / 13.0);
    });
  }

  List<Marker> generateRandomMarkers(int count) {
    Random random = Random();
    return List.generate(count, (index) {
      double lat = 51.5 + random.nextDouble() * 0.1 - 0.05;
      double lng = -0.09 + random.nextDouble() * 0.1 - 0.05;
      return Marker(
        point: latLng.LatLng(lat, lng),
        width: 20,
        height: 20,
        builder: (ctx) => const Icon(
          Icons.location_pin,
          size: 30,
          color: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: latLng.LatLng(51.5, -0.09),
        zoom: 5,
        onPositionChanged: (position, hasGesture) {
          if (hasGesture) {
            _updateMarkerSize(position.zoom);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: generateRandomMarkers(10),
        ),
        RichAttributionWidget(
          popupInitialDisplayDuration: const Duration(seconds: 2),
          animationConfig: const ScaleRAWA(),
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () async => launchUrl(
                Uri.parse('https://openstreetmap.org/copyright'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
