import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source.dart';
import 'package:open_weather_app/weather/domain/entity/weather.dart';
import 'package:open_weather_app/weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  LocalWeatherDataSource localWeatherDataSource;
  RemoteWeatherDataSource remoteWeatherDataSource;
  InternetConnectionChecker checker;

  WeatherRepositoryImpl({
    required this.localWeatherDataSource,
    required this.remoteWeatherDataSource,
    required this.checker,
  });

  @override
  Future<Weather> getCurrentWeather(String city) async {
    if (await checker.hasConnection) {
      final model = await remoteWeatherDataSource.getWeather(city);
      return model.toWeather();
    }
    final model = await localWeatherDataSource.getWeather();
    return model.toWeather();
  }

  @override
  Future<void> saveWeather(Weather weather) async {
    localWeatherDataSource.saveWeather(WeatherModel.fromWeather(weather));
  }
}
