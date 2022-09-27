import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_app/core/error/weather_response_exception.dart';
import 'package:open_weather_app/weather/domain/entity/weather.dart';
import 'package:open_weather_app/weather/domain/repository/weather_repository.dart';
import 'package:open_weather_app/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:open_weather_app/weather/presentation/dto/weather_dto.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class WeatherFake extends Fake implements Weather {}

void main() {
  group('weather bloc tests', () {
    late WeatherBloc weatherBloc;
    late WeatherRepository mockRepo;

    setUpAll(() {
      registerFallbackValue(WeatherFake());
    });
    setUp(() {
      mockRepo = MockWeatherRepository();
      weatherBloc = WeatherBloc(weatherRepository: mockRepo);
    });
    test('initial state is initial', () {
      expect(weatherBloc.state, const WeatherState.initial());
    });
    test(
        'should state is loaded when added load event if get current weather is successful',
        () async {
      final weather = Weather(
        temperature: 0.0,
        maxTemperature: 0.0,
        minTemperature: 0.0,
        feelsLike: 0.0,
        humidity: 0.0,
        windDeg: 0.0,
        windSpeed: 0.0,
        rainVolumeForLast1Hour: 0.0,
        weatherName: 'name',
        weatherDescription: 'description',
        icon: '1d',
        clouds: 0.0,
      );
      when(() => mockRepo.getCurrentWeather(any())).thenAnswer(
        (invocation) => Future.value(weather),
      );
      when(() => mockRepo.saveWeather(any())).thenAnswer(
        (invocation) => Future.value(true),
      );
      weatherBloc.add(const WeatherEvent.load('Moscow'));
      await Future.delayed(const Duration(microseconds: 50));
      final actual = weatherBloc.state;
      expect(actual, WeatherState.loaded(WeatherDto.fromWeather(weather)));
    });
    test(
        'should state is error when added load event if get current weather is thrown exception',
        () async {
      when(() => mockRepo.getCurrentWeather(any())).thenThrow(
        WeatherResponseException('message'),
      );
      weatherBloc.add(const WeatherEvent.load('Moscow'));
      await Future.delayed(const Duration(microseconds: 100));
      final actual = weatherBloc.state;
      expect(actual, const WeatherState.error('message'));
    });
    test(
        'should call saveWeather() in repository when added load event if get current weather is successful',
            () async {
              final weather = Weather(
                temperature: 0.0,
                maxTemperature: 0.0,
                minTemperature: 0.0,
                feelsLike: 0.0,
                humidity: 0.0,
                windDeg: 0.0,
                windSpeed: 0.0,
                rainVolumeForLast1Hour: 0.0,
                weatherName: 'name',
                weatherDescription: 'description',
                icon: '1d',
                clouds: 0.0,
              );
              when(() => mockRepo.getCurrentWeather(any())).thenAnswer(
                    (invocation) => Future.value(weather),
              );
              when(() => mockRepo.saveWeather(any())).thenAnswer(
                    (invocation) => Future.value(true),
              );
              weatherBloc.add(const WeatherEvent.load('Moscow'));
              await Future.delayed(const Duration(microseconds: 50));
              verify(() => mockRepo.saveWeather(any())).called(1);
        });
  });
}
