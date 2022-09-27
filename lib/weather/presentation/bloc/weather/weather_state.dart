part of 'weather_bloc.dart';

@immutable
@freezed
abstract class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = _WeatherInitialState;
  const factory WeatherState.loading(WeatherDto weather) = _WeatherLoadingState;
  const factory WeatherState.loaded(WeatherDto weather) = _WeatherLoadedState;
  const factory WeatherState.error(String message) = _WeatherErrorState;
}
