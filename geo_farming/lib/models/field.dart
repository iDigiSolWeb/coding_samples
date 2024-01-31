// models/field.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'field.g.dart';

@HiveType(typeId: 0)
class Field extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String color;

  @HiveField(2)
  final String label;

  @HiveField(3)
  final List<LatLng> borderCoordinates;

  Field({
    required this.id,
    required this.color,
    required this.label,
    required this.borderCoordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'label': label,
      'borderCoordinates': borderCoordinates.map((latLng) => {'latitude': latLng.latitude, 'longitude': latLng.longitude}).toList(),
    };
  }

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      color: json['color'],
      label: json['label'],
      borderCoordinates:
          (json['borderCoordinates'] as List<dynamic>).map((coords) => LatLng(coords['latitude'], coords['longitude'])).toList(),
    );
  }
}
