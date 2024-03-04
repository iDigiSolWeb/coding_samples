import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OfflineMapScreen(),
    );
  }
}

class OfflineMapScreen extends StatefulWidget {
  @override
  _OfflineMapScreenState createState() => _OfflineMapScreenState();
}

class _OfflineMapScreenState extends State<OfflineMapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Offline Map'),
        ),
        body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(51.509364, -0.128928),
            initialZoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ));
  }
}
