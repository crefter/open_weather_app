import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source.dart';
import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source_impl.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPref extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late LocalWeatherDataSource localWeatherDataSource;
  setUp(() {
    sharedPreferences = MockSharedPref();
    localWeatherDataSource =
        LocalWeatherDataSourceImpl(sharedPreferences: sharedPreferences);
  });
  group('tests for save weather model', () {
    test('should return true when save weather model is successful', () async {
      when(() => sharedPreferences.setString(any(), any()))
          .thenAnswer((invocation) => Future.value(true));
      bool actual = await localWeatherDataSource.saveWeather(WeatherModel());
      expect(actual, isTrue);
    });
    test('should return false when save weather model is unsuccessful',
        () async {
      when(() => sharedPreferences.setString(any(), any()))
          .thenAnswer((invocation) => Future.value(false));
      bool actual = await localWeatherDataSource.saveWeather(WeatherModel());
      expect(actual, isFalse);
    });
  });
  group('tests for get weather model', () {
    test('should return weather model when get weather model is successful',
        () async {
      when(() => sharedPreferences.getString(any()))
          .thenAnswer((invocation) => '{'
              '"weather": ['
              '{'
              '"id": 501,'
              '"main": "Rain",'
              '"description": "moderate rain",'
              '"icon": "10d"'
              '}'
              '],'
              '"main": {'
              '"temp": 298.48,'
              '"feels_like": 298.74,'
              '"temp_min": 297.56,'
              '"temp_max": 300.05,'
              '"humidity": 64'
              '},'
              '"wind": {'
              '"speed": 0.62,'
              '"deg": 349,'
              '"gust": 1.18'
              '},'
              '"rain": {'
              '"1h": 3.16'
              '},'
              '"clouds": {'
              '"all": 100'
              '}'
              '}');
      WeatherModel actual = await localWeatherDataSource.getWeather();
      expect(
        actual,
        isA<WeatherModel>()
            .having((p) => p.weather?.first.id, 'weather_id', 501)
            .having((p) => p.rain?.h, 'rain_h', 3.16),
      );
    });
    test(
        'should return empty weather model when get weather model is '
        'unsuccessful', () async {
      when(() => sharedPreferences.getString(any()))
          .thenAnswer((invocation) => null);
      WeatherModel actual = await localWeatherDataSource.getWeather();
      expect(
        actual.main?.temp,
        0
      );
    });
  });
}
