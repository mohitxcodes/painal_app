import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentWeatherWidget extends StatefulWidget {
  const CurrentWeatherWidget({super.key});

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      const apiKey = '24f571c1b31347086e7af0b8196b1dbb';
      const city = 'Patna';
      const url =
          'https://api.openweathermap.org/data/2.5/weather?q=$city,IN&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color weatherColor = Colors.green[700]!;
    if (weatherData != null) {
      final main = (weatherData!['weather'][0]['main'] as String).toLowerCase();
      if (main.contains('rain')) {
        weatherColor = Colors.blue[700]!;
      } else if (main.contains('cloud'))
        weatherColor = Colors.green[700]!;
      else if (main.contains('clear'))
        weatherColor = Colors.orange[700]!;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: Icon(_getWeatherIcon(), color: Colors.white, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child:
                isLoading
                    ? Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    )
                    : errorMessage.isNotEmpty
                    ? Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.orange[200],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.orange[100],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                    : weatherData != null
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${weatherData!['main']['temp'].round()}°C',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              weatherData!['weather'][0]['main'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: Colors.white.withOpacity(0.75),
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Humidity: ${weatherData!['main']['humidity']}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.air,
                              color: Colors.white.withOpacity(0.75),
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Wind: ${weatherData!['wind']['speed']} m/s',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Icon(Icons.cloud_off, color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'No data',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: fetchWeatherData,
            icon: const Icon(Icons.refresh, color: Colors.white70, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon() {
    if (weatherData == null) return Icons.cloud;
    final main = (weatherData!['weather'][0]['main'] as String).toLowerCase();
    if (main.contains('rain')) return Icons.umbrella;
    if (main.contains('cloud')) return Icons.cloud;
    if (main.contains('clear')) return Icons.wb_sunny;
    if (main.contains('snow')) return Icons.ac_unit;
    if (main.contains('storm')) return Icons.flash_on;
    return Icons.cloud;
  }
}
