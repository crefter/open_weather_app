import 'package:open_weather_app/weather/domain/entity/weather.dart';

class WeatherModel {
  WeatherModel({
    List<WeatherInner>? weather,
    Main? main,
    Wind? wind,
    Rain? rain,
    Clouds? clouds,
  }) {
    _weather = weather;
    _main = main;
    _wind = wind;
    _rain = rain;
    _clouds = clouds;
  }

  WeatherModel.empty() {
    _weather?.add(WeatherInner(main: 'None', description: '', icon: null));
    _clouds = Clouds(all: 0);
    _rain = Rain(h: 0);
    _wind = Wind(speed: 0, deg: 0);
    _main = Main(temp: 0, feelsLike: 0, tempMin: 0, tempMax: 0, humidity: 0);
  }

  WeatherModel.fromJson(Map<String, dynamic> json) {
    if (json['weather'] != null) {
      _weather = [];
      json['weather'].forEach((v) {
        _weather?.add(WeatherInner.fromJson(v));
      });
    }
    _main = json['main'] != null ? Main.fromJson(json['main']) : null;
    _wind = json['wind'] != null ? Wind.fromJson(json['wind']) : null;
    _rain = json['rain'] != null ? Rain.fromJson(json['rain']) : null;
    _clouds = json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null;
  }

  List<WeatherInner>? _weather;
  Main? _main;
  Wind? _wind;
  Rain? _rain;
  Clouds? _clouds;

  WeatherModel copyWith({
    List<WeatherInner>? weather,
    Main? main,
    Wind? wind,
    Rain? rain,
    Clouds? clouds,
  }) =>
      WeatherModel(
        weather: weather ?? _weather,
        main: main ?? _main,
        wind: wind ?? _wind,
        rain: rain ?? _rain,
        clouds: clouds ?? _clouds,
      );

  List<WeatherInner>? get weather => _weather;

  Main? get main => _main;

  Wind? get wind => _wind;

  Rain? get rain => _rain;

  Clouds? get clouds => _clouds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_weather != null) {
      map['weather'] = _weather?.map((v) => v.toJson()).toList();
    }
    if (_main != null) {
      map['main'] = _main?.toJson();
    }
    if (_wind != null) {
      map['wind'] = _wind?.toJson();
    }
    if (_rain != null) {
      map['rain'] = _rain?.toJson();
    }
    if (_clouds != null) {
      map['clouds'] = _clouds?.toJson();
    }
    return map;
  }

  WeatherModel.fromWeather(Weather weather) {
    _weather?.add(
      WeatherInner(
          main: weather.weatherName,
          description: weather.weatherDescription,
          icon: weather.icon),
    );
    _clouds = Clouds(all: weather.clouds);
    _main = Main(
      temp: weather.temperature,
      tempMax: weather.maxTemperature,
      tempMin: weather.minTemperature,
    );
    _rain = Rain(h: weather.humidity);
    _wind = Wind(speed: weather.windSpeed, deg: weather.windDeg);
  }

  Weather toWeather() {
    return Weather(
      temperature: _main?.temp as double,
      maxTemperature: _main?.tempMax as double,
      minTemperature: _main?.tempMin as double,
      feelsLike: _main?.feelsLike as double,
      humidity: _main?.humidity as double,
      windSpeed: _wind?.speed as double,
      windDeg: _wind?.deg as double,
      rainVolumeForLast1Hour: _rain?.h as double,
      weatherName: _weather?.first.main ?? '',
      weatherDescription: _weather?.first.description ?? '',
      icon: 'http://openweathermap.org/'
              'img/wn/${_weather?.first.icon ?? '01d'}@2x.png',
      clouds: _clouds?.all as double,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModel &&
          runtimeType == other.runtimeType &&
          _weather == other._weather &&
          _main == other._main &&
          _wind == other._wind &&
          _rain == other._rain &&
          _clouds == other._clouds;

  @override
  int get hashCode =>
      _weather.hashCode ^
      _main.hashCode ^
      _wind.hashCode ^
      _rain.hashCode ^
      _clouds.hashCode;
}

/// all : 100

class Clouds {
  Clouds({
    num? all,
  }) {
    _all = all;
  }

  Clouds.fromJson(dynamic json) {
    _all = json['all'];
  }

  num? _all;

  Clouds copyWith({
    num? all,
  }) =>
      Clouds(
        all: all ?? _all,
      );

  num? get all => _all;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = _all;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Clouds && runtimeType == other.runtimeType && _all == other._all;

  @override
  int get hashCode => _all.hashCode;
}

/// 1h : 3.16

class Rain {
  Rain({
    num? h,
  }) {
    _h = h;
  }

  Rain.fromJson(dynamic json) {
    _h = json['1h'];
  }

  num? _h;

  Rain copyWith({
    num? h,
  }) =>
      Rain(
        h: h ?? _h,
      );

  num? get h => _h;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['1h'] = _h;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rain && runtimeType == other.runtimeType && _h == other._h;

  @override
  int get hashCode => _h.hashCode;
}

/// speed : 0.62
/// deg : 349
/// gust : 1.18

class Wind {
  Wind({
    num? speed,
    num? deg,
  }) {
    _speed = speed;
    _deg = deg;
  }

  Wind.fromJson(dynamic json) {
    _speed = json['speed'];
    _deg = json['deg'];
    _gust = json['gust'];
  }

  num? _speed;
  num? _deg;
  num? _gust;

  Wind copyWith({
    num? speed,
    num? deg,
    num? gust,
  }) =>
      Wind(
        speed: speed ?? _speed,
        deg: deg ?? _deg,
      );

  num? get speed => _speed;

  num? get deg => _deg;

  num? get gust => _gust;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speed'] = _speed;
    map['deg'] = _deg;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wind &&
          runtimeType == other.runtimeType &&
          _speed == other._speed &&
          _deg == other._deg;

  @override
  int get hashCode => _speed.hashCode ^ _deg.hashCode;
}

/// temp : 298.48
/// feels_like : 298.74
/// temp_min : 297.56
/// temp_max : 300.05
/// humidity : 64

class Main {
  Main({
    num? temp,
    num? feelsLike,
    num? tempMin,
    num? tempMax,
    num? humidity,
  }) {
    _temp = temp;
    _feelsLike = feelsLike;
    _tempMin = tempMin;
    _tempMax = tempMax;
    _humidity = humidity;
  }

  Main.fromJson(dynamic json) {
    _temp = json['temp'];
    _feelsLike = json['feels_like'];
    _tempMin = json['temp_min'];
    _tempMax = json['temp_max'];
    _humidity = json['humidity'];
  }

  num? _temp;
  num? _feelsLike;
  num? _tempMin;
  num? _tempMax;
  num? _humidity;

  Main copyWith({
    num? temp,
    num? feelsLike,
    num? tempMin,
    num? tempMax,
    num? humidity,
  }) =>
      Main(
        temp: temp ?? _temp,
        feelsLike: feelsLike ?? _feelsLike,
        tempMin: tempMin ?? _tempMin,
        tempMax: tempMax ?? _tempMax,
        humidity: humidity ?? _humidity,
      );

  num? get temp => _temp;

  num? get feelsLike => _feelsLike;

  num? get tempMin => _tempMin;

  num? get tempMax => _tempMax;

  num? get humidity => _humidity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temp'] = _temp;
    map['feels_like'] = _feelsLike;
    map['temp_min'] = _tempMin;
    map['temp_max'] = _tempMax;
    map['humidity'] = _humidity;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Main &&
          runtimeType == other.runtimeType &&
          _temp == other._temp &&
          _feelsLike == other._feelsLike &&
          _tempMin == other._tempMin &&
          _tempMax == other._tempMax &&
          _humidity == other._humidity;

  @override
  int get hashCode =>
      _temp.hashCode ^
      _feelsLike.hashCode ^
      _tempMin.hashCode ^
      _tempMax.hashCode ^
      _humidity.hashCode;
}

/// id : 501
/// main : "Rain"
/// description : "moderate rain"
/// icon : "10d"

class WeatherInner {
  WeatherInner({
    String? main,
    String? description,
    String? icon,
  }) {
    _main = main;
    _description = description;
    _icon = icon;
  }

  WeatherInner.fromJson(dynamic json) {
    _main = json['main'];
    _description = json['description'];
    _icon = json['icon'];
  }

  String? _main;
  String? _description;
  String? _icon;

  WeatherInner copyWith({
    num? id,
    String? main,
    String? description,
    String? icon,
  }) =>
      WeatherInner(
        main: main ?? _main,
        description: description ?? _description,
        icon: icon ?? _icon,
      );

  String? get main => _main;

  String? get description => _description;

  String? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main'] = _main;
    map['description'] = _description;
    map['icon'] = _icon;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherInner &&
          runtimeType == other.runtimeType &&
          _main == other._main &&
          _description == other._description &&
          _icon == other._icon;

  @override
  int get hashCode => _main.hashCode ^ _description.hashCode ^ _icon.hashCode;
}
