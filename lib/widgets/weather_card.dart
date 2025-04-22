import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final bool isDark;
  final bool large;
  final bool showArt;
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isDark,
    this.large = false,
    this.showArt = false,
    this.onTap,
  });

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear')) return Icons.wb_sunny;
    if (desc.contains('cloud')) return Icons.cloud;
    if (desc.contains('rain')) return Icons.beach_access;
    if (desc.contains('storm') || desc.contains('thunder')) return Icons.flash_on;
    if (desc.contains('snow')) return Icons.ac_unit;
    if (desc.contains('mist') || desc.contains('fog')) return Icons.blur_on;
    return Icons.wb_cloudy;
  }

  Widget? _getWeatherArt(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear')) {
      return const Icon(Icons.sunny, size: 38, color: Color.fromRGBO(255, 255, 0, 0.8));
    } else if (desc.contains('cloud')) {
      return const Icon(Icons.cloud_queue, size: 38, color: Color.fromRGBO(105, 105, 105, 0.7));
    } else if (desc.contains('rain')) {
      return const Icon(Icons.grain, size: 38, color: Color.fromRGBO(0, 0, 255, 0.7));
    } else if (desc.contains('storm') || desc.contains('thunder')) {
      return const Icon(Icons.flash_on, size: 38, color: Color.fromRGBO(255, 191, 0, 0.7));
    } else if (desc.contains('snow')) {
      return const Icon(Icons.ac_unit, size: 38, color: Color.fromRGBO(173, 216, 230, 0.7));
    } else if (desc.contains('mist') || desc.contains('fog')) {
      return const Icon(Icons.blur_on, size: 38, color: Color.fromRGBO(128, 128, 128, 0.7));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF23272F), const Color(0xFF181A20)]
          : [const Color(0xFFB2FEFA), const Color(0xFF0ED2F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final weatherIcon = _getWeatherIcon(weather.description);
    final weatherArt = showArt ? _getWeatherArt(weather.description) : null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: large ? double.infinity : 380,
        constraints: const BoxConstraints(minHeight: 170),
        padding: EdgeInsets.symmetric(horizontal: large ? 28 : 18, vertical: large ? 28 : 18),
        margin: EdgeInsets.symmetric(horizontal: large ? 8 : 0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, isDark ? 0.13 : 0.10),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'weather_icon_${weather.city}',
              child: CircleAvatar(
                radius: large ? 38 : 28,
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
                child: Icon(weatherIcon, size: large ? 48 : 32, color: isDark ? const Color(0xFF0ED2F7) : const Color(0xFF007AFF)),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.city,
                    style: TextStyle(
                      fontSize: large ? 28 : 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF181A20),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: large ? 36 : 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF181A20),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    weather.description[0].toUpperCase() + weather.description.substring(1),
                    style: TextStyle(
                      fontSize: large ? 22 : 16,
                      color: isDark ? const Color.fromRGBO(255, 255, 255, 0.7) : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if (weatherArt != null) ...[
              const SizedBox(width: 10),
              weatherArt,
            ]
          ],
        ),
      ),
    );
  }
}
