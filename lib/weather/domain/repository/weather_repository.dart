import 'package:open_weather_app/weather/domain/entity/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String city);
  Future<void> saveWeather(Weather weather);
}