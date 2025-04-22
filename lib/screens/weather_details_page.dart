import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherDetailsPage extends StatelessWidget {
  final Weather weather;
  final bool isDark;

  const WeatherDetailsPage({super.key, required this.weather, required this.isDark});

  String _formatTime(int? timestamp) {
    if (timestamp == null) return '--';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF23272F) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          weather.city,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF23272F) : Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'weather_icon_${weather.city}',
                child: const Icon(Icons.wb_cloudy, size: 64, color: Color(0xFF007AFF)),
              ),
              const SizedBox(height: 16),
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF181A20)),
              ),
              const SizedBox(height: 10),
              Text(
                weather.description[0].toUpperCase() + weather.description.substring(1),
                style: TextStyle(fontSize: 22, color: isDark ? Colors.white70 : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _detailTile('Humidity', weather.humidity != null ? '${weather.humidity!.toStringAsFixed(0)}%' : '--'),
                  _detailTile('Wind', weather.windSpeed != null ? '${weather.windSpeed!.toStringAsFixed(1)} m/s' : '--'),
                  _detailTile('Feels like', weather.feelsLike != null ? '${weather.feelsLike!.toStringAsFixed(1)}°C' : '--'),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _detailTile('Min', weather.minTemp != null ? '${weather.minTemp!.toStringAsFixed(1)}°C' : '--'),
                  _detailTile('Max', weather.maxTemp != null ? '${weather.maxTemp!.toStringAsFixed(1)}°C' : '--'),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _detailTile('Sunrise', _formatTime(weather.sunrise)),
                  _detailTile('Sunset', _formatTime(weather.sunset)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
