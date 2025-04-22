import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Weather?> fetchWeather(String city) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Weather>> fetchMainCitiesWeather(List<String> cities) async {
    final List<Weather> result = [];
    for (final city in cities) {
      final weather = await fetchWeather(city);
      if (weather != null) result.add(weather);
    }
    return result;
  }
}
