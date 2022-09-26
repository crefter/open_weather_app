import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source.dart';
import 'package:open_weather_app/weather/data/repository/weather_repository_impl.dart';
import 'package:open_weather_app/weather/domain/entity/weather.dart';
import 'package:open_weather_app/weather/domain/repository/weather_repository.dart';

// Mocks
class MockLocalWeatherDataSource extends Mock
    implements LocalWeatherDataSource {}

class MockRemoteWeatherDataSource extends Mock
    implements RemoteWeatherDataSource {}

class MockChecker extends Mock implements InternetConnectionChecker {}

class WeatherModelFake extends Fake implements WeatherModel {}

void main() {
  group('weather repository tests', () {
    late LocalWeatherDataSource mockLocalWeatherDataSource;
    late RemoteWeatherDataSource mockRemoteWeatherDataSource;
    late InternetConnectionChecker mockChecker;
    late WeatherRepository weatherRepository;

    setUpAll(() {
      registerFallbackValue(WeatherModelFake());
    });

    setUp(() {
      mockChecker = MockChecker();
      mockLocalWeatherDataSource = MockLocalWeatherDataSource();
      mockRemoteWeatherDataSource = MockRemoteWeatherDataSource();
      weatherRepository = WeatherRepositoryImpl(
        localWeatherDataSource: mockLocalWeatherDataSource,
        remoteWeatherDataSource: mockRemoteWeatherDataSource,
        checker: mockChecker,
      );
    });
    group('tests for getCurrentWeather()', () {
      test('should return model from remote data source if there the internet',
          () async {
        when(() => mockChecker.hasConnection).thenAnswer(
          (invocation) => Future.value(true),
        );
        when(() => mockRemoteWeatherDataSource.getWeather(any())).thenAnswer(
          (invocation) => Future.value(
            WeatherModel.empty(),
          ),
        );
        final actual = await weatherRepository.getCurrentWeather('');
        expect(
          actual,
          isA<Weather>()
              .having((p0) => p0.weatherName, 'weather name', '')
              .having((p0) => p0.icon, 'icon',
                  'http://openweathermap.org/img/wn/01d@2x.png'),
        );
      });
      test(
          'should return model from local data source if there no the internet',
          () async {
        when(() => mockChecker.hasConnection).thenAnswer(
          (invocation) => Future.value(false),
        );
        when(() => mockLocalWeatherDataSource.getWeather()).thenAnswer(
          (invocation) => Future.value(
            WeatherModel.empty(),
          ),
        );
        final actual = await weatherRepository.getCurrentWeather('');
        expect(
          actual,
          isA<Weather>()
              .having((p0) => p0.weatherName, 'weather name', '')
              .having((p0) => p0.icon, 'icon',
                  'http://openweathermap.org/img/wn/01d@2x.png'),
        );
      });
    });
    group('tests for saveWeather()', () {
      test('should save weather', () async {
        when(() => mockLocalWeatherDataSource.saveWeather(any()))
            .thenAnswer((invocation) => Future.value(true));
        final actual = await weatherRepository.saveWeather(
          Weather(
              temperature: 0.0,
              maxTemperature: 0.0,
              minTemperature: 0.0,
              feelsLike: 0.0,
              humidity: 0.0,
              windSpeed: 0.0,
              windDeg: 0.0,
              rainVolumeForLast1Hour: 0.0,
              weatherName: '',
              weatherDescription: '',
              icon: '',
              clouds: 0.0),
        );
        expect(actual, true);
      });
    });
  });
}
