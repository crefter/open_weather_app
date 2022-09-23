import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';

abstract class RemoteWeatherDataSource {
  Future<WeatherModel> getWeather(String city);
}