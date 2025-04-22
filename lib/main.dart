import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/weather.dart';
import 'services/weather_service.dart';
import 'widgets/weather_card.dart';
import 'screens/weather_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  Future<Weather?>? _weatherFuture;
  String? _error;
  final FocusNode _focusNode = FocusNode();

  final List<String> _mainCities = ['New York', 'London', 'Tokyo', 'Chennai'];
  late Future<List<Weather>> _mainCitiesWeather;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _mainCitiesWeather = _weatherService.fetchMainCitiesWeather(_mainCities);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_controller.text.trim());
      _focusNode.unfocus();
    });
  }

  void _openDetails(Weather weather) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailsPage(weather: weather, isDark: Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : null,
      body: Container(
        decoration: !isDark
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7), Color(0xFF007AFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : null,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Color.fromRGBO(255, 255, 255, 0.85),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: const Color(0x11000000), // 7% opacity black
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_outlined, size: 64, color: Color(0xFF007AFF)),
                  const SizedBox(height: 16),
                  const Text(
                    'Weather',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF181A20),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: isDark ? const Color(0xFF23272F) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: isDark ? 0 : 4,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search for a city',
                        hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF007AFF)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      ),
                      onSubmitted: (_) => _search(),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _search,
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text('Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: isDark ? 0 : 2,
                      ),
                    ),
                  ),
                  if (_weatherFuture != null)
                    FutureBuilder<Weather?>(
                      future: _weatherFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: _shimmerCard(isDark, large: true),
                          );
                        } else if (snapshot.hasError || _error != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _error ?? 'Error fetching weather.',
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final weather = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: WeatherCard(
                              weather: weather,
                              isDark: isDark,
                              large: true,
                              onTap: () => _openDetails(weather),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  const SizedBox(height: 24),
                  FutureBuilder<List<Weather>>(
                    future: _mainCitiesWeather,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: List.generate(4, (i) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _shimmerCard(isDark),
                          )),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Unable to load main cities weather.',
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        final citiesWeather = snapshot.data!;
                        return Column(
                          children: citiesWeather.map((weather) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: WeatherCard(
                              weather: weather,
                              isDark: isDark,
                              large: false,
                              showArt: true,
                              onTap: () => _openDetails(weather),
                            ),
                          )).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerCard(bool isDark, {bool large = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: large ? double.infinity : 380,
      constraints: BoxConstraints(minHeight: large ? 170 : 120),
      padding: EdgeInsets.symmetric(horizontal: large ? 28 : 18, vertical: large ? 28 : 18),
      margin: EdgeInsets.symmetric(horizontal: large ? 8 : 0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : Colors.grey[300],
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: large ? 76 : 56,
            height: large ? 76 : 56,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: large ? 26 : 18,
                  width: large ? 120 : 70,
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                Container(
                  height: large ? 24 : 16,
                  width: large ? 80 : 50,
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                Container(
                  height: large ? 18 : 12,
                  width: large ? 100 : 60,
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
