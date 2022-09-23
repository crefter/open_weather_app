import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';

abstract class LocalWeatherDataSource {
  Future<WeatherModel> getWeather();
  Future<bool> saveWeather(WeatherModel weather);
}