import 'package:flutter_test/flutter_test.dart';
import 'package:budapp/services/weather_service.dart';

void main() {
  group('WeatherService Tests', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService();
    });

    test('WeatherService should be instantiated', () {
      expect(weatherService, isNotNull);
      expect(weatherService, isA<WeatherService>());
    });

    test('WeatherData.mock should create valid mock data', () {
      // Act
      final weather = WeatherData.mock();

      // Assert
      expect(weather, isNotNull);
      expect(weather.temperature, greaterThan(0));
      expect(weather.humidity, greaterThanOrEqualTo(0));
      expect(weather.humidity, lessThanOrEqualTo(100));
      expect(weather.condition, isNotEmpty);
    });

    test('getWorkRecommendations should return recommendations for good weather', () {
      // Arrange
      final weather = WeatherData(
        date: DateTime.now(),
        temperature: 20.0,
        feelsLike: 19.0,
        humidity: 60,
        windSpeed: 3.0,
        condition: 'Clear',
        description: 'Clear sky',
        icon: '01d',
      );

      // Act
      final recommendations = weatherService.getWorkRecommendations(weather);

      // Assert
      expect(recommendations, isNotNull);
      expect(recommendations.isSafeToWork, isTrue);
      expect(recommendations.recommendations, isNotEmpty);
      expect(recommendations.warnings, isEmpty);
    });

    test('getWorkRecommendations should warn about low temperature', () {
      // Arrange
      final weather = WeatherData(
        date: DateTime.now(),
        temperature: 2.0,
        feelsLike: 0.0,
        humidity: 70,
        windSpeed: 5.0,
        condition: 'Clear',
        description: 'Cold',
        icon: '01d',
      );

      // Act
      final recommendations = weatherService.getWorkRecommendations(weather);

      // Assert
      expect(recommendations.isSafeToWork, isFalse);
      expect(recommendations.warnings, isNotEmpty);
      expect(
        recommendations.warnings.any((w) => w.contains('temperatura')),
        isTrue,
      );
    });

    test('getWorkRecommendations should warn about rain', () {
      // Arrange
      final weather = WeatherData(
        date: DateTime.now(),
        temperature: 15.0,
        feelsLike: 14.0,
        humidity: 90,
        windSpeed: 4.0,
        condition: 'Rain',
        description: 'Deszcz',
        icon: '10d',
      );

      // Act
      final recommendations = weatherService.getWorkRecommendations(weather);

      // Assert
      expect(recommendations.isSafeToWork, isFalse);
      expect(recommendations.warnings, isNotEmpty);
      expect(
        recommendations.warnings.any((w) => w.toLowerCase().contains('deszcz')),
        isTrue,
      );
    });

    test('getWorkRecommendations should warn about strong wind', () {
      // Arrange
      final weather = WeatherData(
        date: DateTime.now(),
        temperature: 18.0,
        feelsLike: 17.0,
        humidity: 60,
        windSpeed: 15.0,
        condition: 'Clear',
        description: 'Windy',
        icon: '01d',
      );

      // Act
      final recommendations = weatherService.getWorkRecommendations(weather);

      // Assert
      expect(recommendations.isSafeToWork, isFalse);
      expect(recommendations.warnings, isNotEmpty);
      expect(
        recommendations.warnings.any((w) => w.contains('wiatr')),
        isTrue,
      );
    });

    test('isGoodWeatherForTask should work for painting', () {
      // Arrange
      final goodWeather = WeatherData(
        date: DateTime.now(),
        temperature: 18.0,
        feelsLike: 17.0,
        humidity: 60,
        windSpeed: 3.0,
        condition: 'Clear',
        description: 'Clear',
        icon: '01d',
      );

      // Act
      final isGood = weatherService.isGoodWeatherForTask(goodWeather, 'painting');

      // Assert
      expect(isGood, isTrue);
    });

    test('isGoodWeatherForTask should reject rain for painting', () {
      // Arrange
      final badWeather = WeatherData(
        date: DateTime.now(),
        temperature: 18.0,
        feelsLike: 17.0,
        humidity: 60,
        windSpeed: 3.0,
        condition: 'Rain',
        description: 'Rain',
        icon: '10d',
      );

      // Act
      final isGood = weatherService.isGoodWeatherForTask(badWeather, 'painting');

      // Assert
      expect(isGood, isFalse);
    });

    test('WeatherData iconUrl should be properly formatted', () {
      // Arrange
      final weather = WeatherData.mock();

      // Act
      final url = weather.iconUrl;

      // Assert
      expect(url, contains('openweathermap.org'));
      expect(url, contains(weather.icon));
    });
  });
}






