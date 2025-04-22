class Weather {
  final double temperature;
  final String description;
  final String city;
  final double? humidity;
  final double? windSpeed;
  final double? feelsLike;
  final double? minTemp;
  final double? maxTemp;
  final int? sunrise;
  final int? sunset;

  Weather({
    required this.temperature,
    required this.description,
    required this.city,
    this.humidity,
    this.windSpeed,
    this.feelsLike,
    this.minTemp,
    this.maxTemp,
    this.sunrise,
    this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      city: json['name'],
      humidity: (json['main']['humidity'] as num?)?.toDouble(),
      windSpeed: (json['wind']?['speed'] as num?)?.toDouble(),
      feelsLike: (json['main']?['feels_like'] as num?)?.toDouble(),
      minTemp: (json['main']?['temp_min'] as num?)?.toDouble(),
      maxTemp: (json['main']?['temp_max'] as num?)?.toDouble(),
      sunrise: (json['sys']?['sunrise'] as int?),
      sunset: (json['sys']?['sunset'] as int?),
    );
  }
}
