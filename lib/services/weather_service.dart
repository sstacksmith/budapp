import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/weather_models.dart';

class WeatherService {
  static const String _host = 'api.openweathermap.org';
  static const int _maxDays = 5; // Free tier limit

  String get _apiKey {
    try {
      if (!dotenv.isInitialized) {
        return '';
      }
      final key = dotenv.env['OPENWEATHER_API_KEY'];
      return key ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<WeatherReport> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw Exception('Podaj nazwę miasta.');
    }
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      throw Exception('Brak OPENWEATHER_API_KEY w pliku .env');
    }

    final currentUri = Uri.https(
      _host,
      '/data/2.5/weather',
      {
        'q': cityName,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'pl',
      },
    );

    final forecastUri = Uri.https(
      _host,
      '/data/2.5/forecast',
      {
        'q': cityName,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'pl',
      },
    );

    http.Response currentResponse;
    http.Response forecastResponse;
    
    try {
      // Dodaj timeout do requestów (30 sekund)
      currentResponse = await http.get(currentUri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: Nie udało się połączyć z serwerem pogodowym. Sprawdź połączenie internetowe.');
        },
      );
      
      forecastResponse = await http.get(forecastUri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: Nie udało się pobrać prognozy pogody. Sprawdź połączenie internetowe.');
        },
      );

      if (currentResponse.statusCode != 200) {
        throw Exception(_decodeError(currentResponse.body));
      }
      if (forecastResponse.statusCode != 200) {
        throw Exception(_decodeError(forecastResponse.body));
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Nie udało się pobrać danych pogodowych: ${e.toString()}');
    }

    final currentData = jsonDecode(currentResponse.body) as Map<String, dynamic>;
    final forecastData = jsonDecode(forecastResponse.body) as Map<String, dynamic>;

    final city = currentData['name'] as String? ?? cityName;
    final sys = currentData['sys'] as Map<String, dynamic>? ?? {};
    final main = currentData['main'] as Map<String, dynamic>? ?? {};
    final weatherList = currentData['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic> : {};
    final wind = currentData['wind'] as Map<String, dynamic>? ?? {};

    final List<dynamic> forecastList = forecastData['list'] as List<dynamic>? ?? [];
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final entry in forecastList) {
      final map = entry as Map<String, dynamic>;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        ((map['dt'] as num?)?.toInt() ?? 0) * 1000,
        isUtc: true,
      ).toLocal();
      final key = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      grouped.putIfAbsent(key, () => []).add(map);
    }

    final forecast = grouped.entries.take(_maxDays).map((entry) {
      final parts = entry.value;
      double minTemp = double.infinity;
      double maxTemp = -double.infinity;
      Map<String, dynamic>? representative;
      for (final part in parts) {
        final mainPart = part['main'] as Map<String, dynamic>? ?? {};
        final tempMin = (mainPart['temp_min'] as num?)?.toDouble();
        final tempMax = (mainPart['temp_max'] as num?)?.toDouble();
        if (tempMin != null && tempMin < minTemp) minTemp = tempMin;
        if (tempMax != null && tempMax > maxTemp) maxTemp = tempMax;
        final dtTxt = part['dt_txt'] as String? ?? '';
        if (dtTxt.contains('12:00:00')) {
          representative = part;
        }
      }
      representative ??= parts.first;
      final weatherPart = (representative?['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
      final dt = DateTime.parse(representative?['dt_txt'] as String? ?? entry.key);
      return DailyForecast(
        date: dt,
        minTemp: minTemp.isFinite ? minTemp : (maxTemp.isFinite ? maxTemp : 0),
        maxTemp: maxTemp.isFinite ? maxTemp : (minTemp.isFinite ? minTemp : 0),
        description: weatherPart['description'] as String? ?? 'Brak danych',
        iconCode: weatherPart['icon'] as String? ?? '01d',
      );
    }).toList();

    return WeatherReport(
      cityName: city,
      countryCode: sys['country'] as String? ?? '',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
      description: weather['description'] as String? ?? '',
      iconCode: weather['icon'] as String? ?? '01d',
      forecast: forecast,
    );
  }

  String _decodeError(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final message = data['message'] as String?;
      if (message != null) {
        if (message.contains('Invalid API key')) {
          return 'Nieprawidłowy klucz API OpenWeatherMap';
        }
        if (message.contains('city not found')) {
          return 'Nie znaleziono miasta';
        }
        return message;
      }
      return 'Nie udało się pobrać danych pogodowych';
    } catch (e) {
      return 'Nie udało się pobrać danych pogodowych';
    }
  }
}

