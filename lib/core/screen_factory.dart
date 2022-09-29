import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_weather_app/weather/data/datasource/local/local_weather_data_source_impl.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source_impl.dart';
import 'package:open_weather_app/weather/data/repository/weather_repository_impl.dart';
import 'package:open_weather_app/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:open_weather_app/weather/presentation/screen/weather_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenFactory {
  Widget makeWeatherScreen() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, data) {
        if (data.hasData) {
          return BlocProvider(
            create: (context) => WeatherBloc(
              weatherRepository: WeatherRepositoryImpl(
                localWeatherDataSource:
                    LocalWeatherDataSourceImpl(sharedPreferences: data.data!),
                remoteWeatherDataSource: RemoteWeatherDataSourceImpl(
                  dio: Dio(),
                ),
                checker: InternetConnectionChecker(),
              ),
            ),
            child: const WeatherScreen(),
          );
        } else {
          return const Scaffold(
            body: SizedBox.shrink(),
          );
        }
      },
    );
  }
}
