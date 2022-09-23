import 'package:flutter/material.dart';
import 'package:open_weather_app/weather/presentation/screen/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        "/": (context) => const WeatherScreen(),
      },
    );
  }
}
