import 'package:flutter/material.dart';
import 'package:flutter_map_type/map_option_1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_option_2.dart';
import 'map_option_3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          mapController.setMapStyle(mapOption3);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco coordinates
          zoom: 12.0,
        ),
        
      ),
    );
  }
}
