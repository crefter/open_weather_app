import 'package:flutter/widgets.dart';
import 'package:open_weather_app/core/screen_factory.dart';

abstract class Screens {
  static const home = '/';
}

class Navigation {
  final ScreenFactory _screenFactory = ScreenFactory();

  Map<String, WidgetBuilder> get routes => {
        Screens.home: (context) => _screenFactory.makeWeatherScreen(),
      };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {}
}
