import 'dart:convert';

import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalWeatherDataSourceImpl implements LocalWeatherDataSource {
  SharedPreferences sharedPreferences;

  LocalWeatherDataSourceImpl({required this.sharedPreferences});

  static const String _weatherKey = "WEATHER_KEY";

  @override
  Future<WeatherModel> getWeather() async {
    if (sharedPreferences.getString(_weatherKey) == null) {
      return WeatherModel.empty();
    } else {
      String json = sharedPreferences.getString(_weatherKey) ?? '';
      Map<String, dynamic> map = jsonDecode(json);
      return WeatherModel.fromJson(map);
    }
  }

  @override
  Future<bool> saveWeather(WeatherModel weather) async {
    String json = jsonEncode(weather.toJson());
    return await sharedPreferences.setString(_weatherKey, json);
  }
}
