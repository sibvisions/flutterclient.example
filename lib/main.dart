import 'package:flutter/material.dart';
import 'package:jvx_mobile_v3/custom_screen/custom_application_widget.dart';
import 'package:jvx_mobile_v3/utils/config.dart';

import 'example_custom_screen_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // To use the JVx flutter application you need to return the CustomApplicationWidget
    // This manages all the Utils needed for the App to run.
    return CustomApplicationWidget(
      // Also if you want to run with a Developer Config you can pass one as a parameter
      config: Config(
          baseUrl: 'http://192.168.1.42:8080/JVx.mobile/services/mobile',
          appName: 'demo',
          appMode: 'full',
          debug: true,
          username: 'features',
          password: 'features'),
      // To add a Custom Screen pass it as an parameter here:
      screenManager: ExampleCustomScreenManager(),
    );
  }
}
