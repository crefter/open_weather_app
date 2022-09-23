class Weather {
  final double temperature;
  final double maxTemperature;
  final double minTemperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double windDeg;
  final double rainVolumeForLast1Hour;
  final String weatherName;
  final String weatherDescription;
  final String icon;
  final double clouds;

  Weather({
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.rainVolumeForLast1Hour,
    required this.weatherName,
    required this.weatherDescription,
    required this.icon,
    required this.clouds,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Weather &&
          runtimeType == other.runtimeType &&
          temperature == other.temperature &&
          maxTemperature == other.maxTemperature &&
          minTemperature == other.minTemperature &&
          feelsLike == other.feelsLike &&
          humidity == other.humidity &&
          windSpeed == other.windSpeed &&
          windDeg == other.windDeg &&
          rainVolumeForLast1Hour == other.rainVolumeForLast1Hour &&
          weatherName == other.weatherName &&
          weatherDescription == other.weatherDescription &&
          icon == other.icon &&
          clouds == other.clouds;

  @override
  int get hashCode =>
      temperature.hashCode ^
      maxTemperature.hashCode ^
      minTemperature.hashCode ^
      feelsLike.hashCode ^
      humidity.hashCode ^
      windSpeed.hashCode ^
      windDeg.hashCode ^
      rainVolumeForLast1Hour.hashCode ^
      weatherName.hashCode ^
      weatherDescription.hashCode ^
      icon.hashCode ^
      clouds.hashCode;
}
