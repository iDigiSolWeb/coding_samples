import 'package:meta/meta.dart';
import 'package:flutter/material.dart';



enum Endpoints{ items, details}

class FlavorConfig{
  String appTitle;
  Map<Endpoints,String>? appEndpoint;
  String imageLocation;
  ThemeData? theme;

  FlavorConfig({this.appTitle = 'Flavor Example',this.imageLocation = 'assets/images/default_image.jpg'}){
    this.theme = ThemeData.light();
  }

}