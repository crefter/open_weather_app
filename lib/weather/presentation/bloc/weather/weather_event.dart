part of 'weather_bloc.dart';

@immutable
@freezed
abstract class WeatherEvent with _$WeatherEvent{
  const factory WeatherEvent.load(String city) = _WeatherLoadEvent;
}
