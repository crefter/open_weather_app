import 'dart:convert';

import 'package:open_weather_app/core/error/weather_response_exception.dart';
import 'package:open_weather_app/weather/data/datasource/model/weather_model.dart';
import 'package:open_weather_app/weather/data/datasource/remote/remote_weather_data_source.dart';
import 'package:dio/dio.dart';

class RemoteWeatherDataSourceImpl implements RemoteWeatherDataSource {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/';
  static const _apiKey = '65caa4e73f698ba55a3f8456d599044a';
  Dio dio;

  RemoteWeatherDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = _baseUrl;
    dio.options.responseType = ResponseType.json;
  }

  @override
  Future<WeatherModel> getWeather(String city) async {
    try {
      dio.options.queryParameters = {
        'appid': _apiKey,
        'q': city,
        'units': 'metric',
      };
      final response = await dio.get<String>('/weather');
      if (response.data != null) {
        final map = jsonDecode(response.data!);
        return WeatherModel.fromJson(map);
      }
      throw WeatherResponseException('-1/Bad Request');
    } on DioError catch (e) {
      throw WeatherResponseException(e.message);
    }
  }
}
