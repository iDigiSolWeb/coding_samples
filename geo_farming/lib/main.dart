// main.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/field.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FieldAdapter());
  await Hive.openBox<Field>('fields');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFarmMap(),
    );
  }
}

class MyFarmMap extends StatefulWidget {
  @override
  _MyFarmMapState createState() => _MyFarmMapState();
}

class _MyFarmMapState extends State<MyFarmMap> {
  GoogleMapController? mapController;
  List<Field> fields = [];
  List<LatLng> currentPolyline = [];
  Color currentPolylineColor = Colors.red;

  void _saveFields() async {
    final box = Hive.box<Field>('fields');
    await box.clear(); // Clear previous fields
    await box.addAll(fields);
  }

  @override
  void initState() {
    super.initState();
    _loadFields(); // Load saved fields when the app starts
  }

  Future<void> _loadFields() async {
    final box = Hive.box<Field>('fields');
    setState(() {
      fields = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farm Map')),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(-34.0425, 22.2313889),
          zoom: 13.0,
        ),
        onTap: _handleMapTap,
        polylines: _getPolylines(),
        mapType: MapType.satellite,
        markers: _getMarkers(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showColorPicker(),
            child: Icon(Icons.color_lens),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _toggleMapType(),
            child: Icon(Icons.map),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _handleMapLongPress(),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Set<Polyline> _getPolylines() {
    Set<Polyline> polylines = fields.map((field) {
      return Polyline(
        polylineId: PolylineId(field.id),
        points: field.borderCoordinates,
        color: Color(int.parse(field.color)),
        width: 2,
      );
    }).toSet();

    if (currentPolyline.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('currentPolyline'),
          points: currentPolyline,
          color: currentPolylineColor,
          width: 2,
        ),
      );
    }

    return polylines;
  }

  Set<Marker> _getMarkers() {
    return fields.map((field) {
      return Marker(
        markerId: MarkerId(field.id),
        position: field.borderCoordinates[0], // You can adjust this to position the label marker
        infoWindow: InfoWindow(
          title: field.label,
          snippet: 'Geofenced Area',
        ),
      );
    }).toSet();
  }

  void _toggleMapType() {
    setState(() {
      // Toggle between normal and satellite map types
      //mapController!.animateCamera(CameraUpdate.newLatLng(mapController!.cameraPosition.target));
    });
  }

  void _handleMapTap(LatLng latLng) {
    setState(() {
      currentPolyline.add(latLng);
    });
  }

  void _handleMapLongPress() {
    if (currentPolyline.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Name for Geofenced Area:'),
            content: TextField(
              onChanged: (value) {
                // You can handle the entered name here
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    fields.add(Field(
                      id: UniqueKey().toString(),
                      label: 'Field ${fields.length + 1}',
                      color: currentPolylineColor.value.toString(),
                      borderCoordinates: List.from(currentPolyline),
                    ));
                    currentPolyline.clear();
                    _saveFields();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentPolylineColor,
              onColorChanged: (Color color) {
                setState(() => currentPolylineColor = color);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _handleMapLongPress();
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
