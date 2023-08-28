import 'package:flavors_in_flutter/resources/flavors_config.dart';
import 'package:flutter/material.dart';

import 'main_common.dart';

void main() {
  // Inject our own configurations
  // School 2

  mainCommon(
    FlavorConfig()
      ..appTitle = "School 2"
      ..imageLocation = "assets/images/two.png"
      ..appEndpoint = {
        Endpoints.items: "api.flutterjunction.dev/items",
        Endpoints.details: "api.flutterjunction.dev/items"
      }
      ..theme = ThemeData.dark(),
  );
}