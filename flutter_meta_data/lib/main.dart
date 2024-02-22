import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: ImageMetadataScreen(),
  ));
}

class ImageMetadataScreen extends StatefulWidget {
  @override
  _ImageMetadataScreenState createState() => _ImageMetadataScreenState();
}

class _ImageMetadataScreenState extends State<ImageMetadataScreen> {
  File? _image;
  Map<String, dynamic>? _metadata;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _metadata = null; // Reset metadata when a new image is selected
      });

      _extractMetadata();
    }
  }

  Future<void> _extractMetadata() async {
    try {
      final bytes = await _image!.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image != null) {
        final exifData = await readExifFromBytes(bytes);

        setState(() {
          _metadata = exifData;
        });
      }
    } catch (e) {
      print('Error extracting metadata: $e');
    }
  }

  Widget _buildMetadataList() {
    if (_metadata == null) {
      return Container(); // Return an empty container if no metadata available
    }

    List<Widget> metadataWidgets = [];

    _metadata!.forEach((key, value) {
      metadataWidgets.add(
        ListTile(
          title: Text(key),
          subtitle: Text(value.toString()),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: metadataWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Metadata'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _image != null
              ? Expanded(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                )
              : Placeholder(), // Placeholder if no image is selected
          ElevatedButton(
            onPressed: _getImage,
            child: Text('Choose Image'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildMetadataList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
