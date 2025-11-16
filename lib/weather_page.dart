import 'package:flutter/material.dart';

import 'models/weather_models.dart';
import 'services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  WeatherReport? _report;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _error = 'Wpisz nazwę miasta.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final report = await _weatherService.fetchWeather(city);
      if (!mounted) return;
      setState(() {
        _report = report;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  Widget _buildCurrentWeather(WeatherReport report) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (report.iconCode.isNotEmpty)
                  Image.network(
                    'https://openweathermap.org/img/wn/${report.iconCode}@2x.png',
                    width: 64,
                    height: 64,
                    errorBuilder: (_, __, ___) => const Icon(Icons.cloud),
                  ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${report.cityName}, ${report.countryCode}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${report.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text('Odczuwalna: ${report.feelsLike.toStringAsFixed(1)}°C'),
            Text('Wilgotność: ${report.humidity}%'),
            Text('Wiatr: ${report.windSpeed.toStringAsFixed(1)} m/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildForecast(List<DailyForecast> forecast) {
    if (forecast.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 8),
          child: Text(
            'Prognoza (maks. 5 dni)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...forecast.map(
          (day) => Card(
            child: ListTile(
              leading: Image.network(
                'https://openweathermap.org/img/wn/${day.iconCode}@2x.png',
                width: 48,
                height: 48,
                errorBuilder: (_, __, ___) => const Icon(Icons.cloud_queue),
              ),
              title: Text(
                '${_weekdayName(day.date.weekday)}, ${day.date.day}.${day.date.month}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(day.description),
              trailing: Text(
                '${day.maxTemp.toStringAsFixed(1)}° / ${day.minTemp.toStringAsFixed(1)}°C',
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _weekdayName(int weekday) {
    const names = [
      'Poniedziałek',
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela',
    ];
    return names[(weekday - 1) % names.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pogoda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Miasto',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _isLoading ? null : _fetchWeather,
                ),
              ),
              onSubmitted: (_) => _fetchWeather(),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const LinearProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_report != null) _buildCurrentWeather(_report!),
                    if (_report != null) _buildForecast(_report!.forecast),
                    if (_report == null && !_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: Center(
                          child: Text(
                            'Wpisz miasto, aby zobaczyć aktualną pogodę i prognozę.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

