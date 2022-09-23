import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_app/core/error/weather_response_exception.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late RemoteWeatherDataSource remoteWeatherDataSource;
  late MockDio mockDio;
  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    remoteWeatherDataSource = RemoteWeatherDataSourceImpl(dio: mockDio);
  });
  group('tests for remote weather data source', () {
    test('should return weather model when there are no errors ', () async {
      when(() => mockDio.get<String>(any())).thenAnswer(
        (invocation) => Future.value(
          Response<String>(
            requestOptions: RequestOptions(path: ''),
            data: '{'
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
                '}',
          ),
        ),
      );
      final actual = await remoteWeatherDataSource.getWeather('Moscow');
      expect(
        actual,
        isA<WeatherModel>()
            .having((p0) => p0.main?.temp, 'temp', 298.48)
            .having((p0) => p0.weather?.first.main, 'main', 'Rain'),
      );
    });
    test('should return WeatherResponseException when DioError', () async {
      when(() => mockDio.get<String>(any())).thenThrow(DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response));
      expect(() async {
        await remoteWeatherDataSource.getWeather('Moscow');
      }, throwsA(isA<WeatherResponseException>()));
    });
    test('should return WeatherResponseException when data is null', () async {
      when(() => mockDio.get<String>(any())).thenAnswer(
        (invocation) => Future.value(
          Response<String>(
              requestOptions: RequestOptions(path: ''), data: null),
        ),
      );
      expect(() async {
        await remoteWeatherDataSource.getWeather('Moscow');
      }, throwsA(isA<WeatherResponseException>()));
    });
  });
}
