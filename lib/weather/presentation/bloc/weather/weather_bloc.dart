import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:open_weather_app/core/error/weather_response_exception.dart';
import 'package:open_weather_app/weather/domain/repository/weather_repository.dart';
import 'package:open_weather_app/weather/presentation/dto/weather_dto.dart';

part 'weather_event.dart';

part 'weather_state.dart';

part 'weather_bloc.freezed.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(const WeatherState.initial()) {
    on<WeatherEvent>((event, emit) async {
      await event.when(
        load: (city) => _onLoad(event, emit),
      );
    }, transformer: restartable());
  }

  Future<void> _onLoad(WeatherEvent event, Emitter<WeatherState> emit) async {
    if (event.city.length < 2) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    emit(WeatherState.loading(
      state.maybeWhen(
        loaded: (weatherDto) => weatherDto,
        orElse: () => WeatherDto.empty(),
      ),
    ));
    try {
      final weather = await _weatherRepository.getCurrentWeather(event.city);
      final weatherDto = WeatherDto.fromWeather(weather);
      emit(WeatherState.loaded(weatherDto));
      await _weatherRepository.saveWeather(weather);
    } on WeatherResponseException catch (e) {
      emit(WeatherState.error(e.message));
    }
  }
}
