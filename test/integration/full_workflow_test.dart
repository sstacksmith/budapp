import 'package:flutter_test/flutter_test.dart';
import 'package:budapp/services/offline_sync_service.dart';
import 'package:budapp/services/weather_service.dart';
import 'package:budapp/models/renovation_plan.dart';
import 'package:budapp/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Integration test for full workflow
void main() {
  group('Full Workflow Integration Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('Complete renovation plan workflow', () async {
      // 1. Create user profile
      final userProfile = UserProfile(
        id: 'user123',
        email: 'test@example.com',
        displayName: 'Test Investor',
        role: UserRole.investor,
        createdAt: DateTime.now(),
      );

      expect(userProfile.hasPermission(Permission.createProject), isTrue);

      // 2. Create renovation plan
      final plan = RenovationPlan(
        id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
        userId: userProfile.id,
        name: 'Complete Home Renovation',
        description: 'Full apartment renovation',
        rooms: [
          Room(
            id: 'room1',
            name: 'Living Room',
            area: 30.0,
            type: 'living_room',
            workDescription: 'Painting walls, new flooring',
            materials: [],
            tasks: [],
            estimatedCost: 5000.0,
          ),
        ],
        totalBudget: 20000.0,
        estimatedCost: 5000.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'draft',
        materialPrices: [],
        recommendations: [],
      );

      expect(plan.rooms, hasLength(1));
      expect(plan.totalBudget, greaterThan(plan.estimatedCost));

      // 3. Save plan offline
      final offlineSync = OfflineSyncService();
      await offlineSync.init();
      await offlineSync.saveRenovationPlanOffline(plan);

      final offlinePlans = await offlineSync.getOfflineRenovationPlans();
      expect(offlinePlans, hasLength(1));
      expect(offlinePlans.first.id, equals(plan.id));

      // 4. Check weather for construction work
      final weatherService = WeatherService();
      final weather = WeatherData.mock();
      final recommendations = weatherService.getWorkRecommendations(weather);

      expect(recommendations, isNotNull);
      expect(recommendations.recommendations, isNotEmpty);

      // 5. Check if weather is good for painting
      final isGoodForPainting = weatherService.isGoodWeatherForTask(weather, 'painting');
      expect(isGoodForPainting, isA<bool>());

      // 6. Verify pending changes
      final pendingCount = await offlineSync.getPendingChangesCount();
      expect(pendingCount, greaterThan(0));

      // Cleanup
      await offlineSync.clearOfflineData();
    });

    test('Multi-user project workflow', () async {
      // 1. Investor creates project
      final investor = UserProfile(
        id: 'investor1',
        email: 'investor@example.com',
        displayName: 'John Investor',
        role: UserRole.investor,
        createdAt: DateTime.now(),
      );

      expect(investor.hasPermission(Permission.inviteMembers), isTrue);

      // 2. Manager is added to project
      final manager = UserProfile(
        id: 'manager1',
        email: 'manager@example.com',
        displayName: 'Jane Manager',
        role: UserRole.manager,
        createdAt: DateTime.now(),
      );

      expect(manager.hasPermission(Permission.editProject), isTrue);
      expect(manager.hasPermission(Permission.editBudget), isFalse);

      // 3. Contractor is added
      final contractor = UserProfile(
        id: 'contractor1',
        email: 'contractor@example.com',
        displayName: 'Bob Contractor',
        role: UserRole.contractor,
        createdAt: DateTime.now(),
      );

      expect(contractor.hasPermission(Permission.updateTaskStatus), isTrue);
      expect(contractor.hasPermission(Permission.editProject), isFalse);

      // 4. Create project members
      final projectId = 'project123';
      final members = [
        ProjectMember(
          projectId: projectId,
          userId: investor.id,
          userEmail: investor.email,
          userName: investor.displayName,
          role: investor.role,
          addedAt: DateTime.now(),
          addedBy: investor.id,
        ),
        ProjectMember(
          projectId: projectId,
          userId: manager.id,
          userEmail: manager.email,
          userName: manager.displayName,
          role: manager.role,
          addedAt: DateTime.now(),
          addedBy: investor.id,
        ),
        ProjectMember(
          projectId: projectId,
          userId: contractor.id,
          userEmail: contractor.email,
          userName: contractor.displayName,
          role: contractor.role,
          addedAt: DateTime.now(),
          addedBy: investor.id,
        ),
      ];

      expect(members, hasLength(3));
      expect(members.where((m) => m.role == UserRole.investor), hasLength(1));
      expect(members.where((m) => m.role == UserRole.manager), hasLength(1));
      expect(members.where((m) => m.role == UserRole.contractor), hasLength(1));
    });

    test('Weather-based work planning', () async {
      final weatherService = WeatherService();

      // Test good weather
      final goodWeather = WeatherData(
        date: DateTime.now(),
        temperature: 20.0,
        feelsLike: 19.0,
        humidity: 60,
        windSpeed: 3.0,
        condition: 'Clear',
        description: 'Clear sky',
        icon: '01d',
      );
      var recommendations = weatherService.getWorkRecommendations(goodWeather);
      expect(recommendations.isSafeToWork, isTrue, reason: 'Good weather should be safe');

      // Test cold weather
      final coldWeather = WeatherData(
        date: DateTime.now(),
        temperature: 3.0,
        feelsLike: 1.0,
        humidity: 70,
        windSpeed: 5.0,
        condition: 'Clear',
        description: 'Cold',
        icon: '01d',
      );
      recommendations = weatherService.getWorkRecommendations(coldWeather);
      expect(recommendations.isSafeToWork, isFalse, reason: 'Cold weather should not be safe');
      expect(recommendations.warnings, isNotEmpty);

      // Test rainy weather
      final rainyWeather = WeatherData(
        date: DateTime.now(),
        temperature: 15.0,
        feelsLike: 14.0,
        humidity: 90,
        windSpeed: 4.0,
        condition: 'Rain',
        description: 'Rain',
        icon: '10d',
      );
      recommendations = weatherService.getWorkRecommendations(rainyWeather);
      expect(recommendations.isSafeToWork, isFalse, reason: 'Rainy weather should not be safe');
      expect(recommendations.warnings, isNotEmpty);
    });
  });
}

