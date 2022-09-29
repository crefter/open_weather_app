import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:open_weather_app/weather/presentation/dto/weather_dto.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: const _EnterCityNameWidget(),
            ),
          ),
          const SizedBox(height: 16,),
          const _WeatherWidget(),
        ],
      ),
    );
  }
}

class _WeatherWidget extends StatelessWidget {
  const _WeatherWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _InitialWidget(),
          loading: (_) => const _LoadingWidget(),
          loaded: (dto) => _LoadedWidget(dto: dto),
          error: (message) => _ErrorWidget(message: message),
        );
      },
    );
  }
}

class _LoadedWidget extends StatelessWidget {
  final WeatherDto _dto;

  const _LoadedWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WeatherHeaderWidget(dto: _dto),
        const SizedBox(height: 16,),
        _HumidityWidget(dto: _dto),
        const SizedBox(height: 16,),
        _FeelsLikeWidget(dto: _dto),
        const SizedBox(height: 16,),
        _TemperatureWidget(dto: _dto),
        const SizedBox(height: 16,),
        _WindWidget(dto: _dto),
        const SizedBox(height: 16,),
        _CloudsWidget(dto: _dto),
      ],
    );
  }
}

class _WeatherHeaderWidget extends StatelessWidget {
  const _WeatherHeaderWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  final WeatherDto _dto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_dto.weatherName),
        SizedBox(width: 100, height: 100, child: Image.network(_dto.icon)),
        Text(_dto.weatherDescription),
      ],
    );
  }
}

class _CloudsWidget extends StatelessWidget {
  const _CloudsWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  final WeatherDto _dto;

  @override
  Widget build(BuildContext context) {
    return Text('Облачность: ${_dto.clouds.toString()} %');
  }
}

class _HumidityWidget extends StatelessWidget {
  const _HumidityWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  final WeatherDto _dto;

  @override
  Widget build(BuildContext context) {
    return Text('Влажность: ${_dto.humidity.toString()} %');
  }
}

class _FeelsLikeWidget extends StatelessWidget {
  const _FeelsLikeWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  final WeatherDto _dto;

  @override
  Widget build(BuildContext context) {
    return Text('По ощущениям: ${_dto.feelsLike.toString()} °C');
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _InitialWidget extends StatelessWidget {
  const _InitialWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _ErrorWidget extends StatelessWidget {
  final String _message;

  const _ErrorWidget({
    Key? key,
    required String message,
  })  : _message = message,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_message);
  }
}

class _WindWidget extends StatelessWidget {
  final WeatherDto _dto;

  const _WindWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ветер:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Направление: ${_dto.windDeg.toString()}°'),
            const SizedBox(
              width: 16,
            ),
            Text('Скорость: ${_dto.windSpeed.toString()} м/c'),
          ],
        ),
      ],
    );
  }
}

class _TemperatureWidget extends StatelessWidget {
  final WeatherDto _dto;

  const _TemperatureWidget({
    Key? key,
    required WeatherDto dto,
  })  : _dto = dto,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Температура:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Мин: ${_dto.minTemperature.toString()} °C'),
            const SizedBox(
              width: 16,
            ),
            Text('Текущая: ${_dto.temperature.toString()} °С'),
            const SizedBox(
              width: 16,
            ),
            Text('Макс: ${_dto.maxTemperature.toString()} °С'),
          ],
        )
      ],
    );
  }
}

class _EnterCityNameWidget extends StatefulWidget {
  const _EnterCityNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_EnterCityNameWidget> createState() => _EnterCityNameWidgetState();
}

class _EnterCityNameWidgetState extends State<_EnterCityNameWidget> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: (value) {
        context.read<WeatherBloc>().add(WeatherEvent.load(value));
      },
      decoration: const InputDecoration(hintText: 'Enter a city name...'),
    );
  }
}
