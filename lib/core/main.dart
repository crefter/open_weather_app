import 'package:flutter/material.dart';
import 'package:open_weather_app/core/navigation.dart';

void main() {
  runApp(MyApp(navigation: Navigation()));
}

class MyApp extends StatelessWidget {
  final Navigation _navigation;
  const MyApp({
    Key? key, required Navigation navigation,
  }) : _navigation = navigation, super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: _navigation.routes,
      onGenerateRoute: _navigation.onGenerateRoute,
    );
  }
}
