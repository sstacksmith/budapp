import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budapp/services/offline_sync_service.dart';
import 'package:budapp/models/renovation_plan.dart';

void main() {
  group('OfflineSyncService Tests', () {
    late OfflineSyncService offlineSync;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      offlineSync = OfflineSyncService();
      await offlineSync.init();
    });

    test('OfflineSyncService should be instantiated', () {
      expect(offlineSync, isNotNull);
      expect(offlineSync, isA<OfflineSyncService>());
    });

    test('saveRenovationPlanOffline should save plan locally', () async {
      // Arrange
      final plan = _createTestPlan();

      // Act
      await offlineSync.saveRenovationPlanOffline(plan);
      final plans = await offlineSync.getOfflineRenovationPlans();

      // Assert
      expect(plans, isNotEmpty);
      expect(plans.first.id, equals(plan.id));
      expect(plans.first.name, equals(plan.name));
    });

    test('getOfflineRenovationPlans should return empty list initially', () async {
      // Act
      final plans = await offlineSync.getOfflineRenovationPlans();

      // Assert
      expect(plans, isEmpty);
    });

    test('getOfflinePlanById should return correct plan', () async {
      // Arrange
      final plan = _createTestPlan();
      await offlineSync.saveRenovationPlanOffline(plan);

      // Act
      final retrievedPlan = await offlineSync.getOfflinePlanById(plan.id);

      // Assert
      expect(retrievedPlan, isNotNull);
      expect(retrievedPlan!.id, equals(plan.id));
      expect(retrievedPlan.name, equals(plan.name));
    });

    test('deleteRenovationPlanOffline should remove plan', () async {
      // Arrange
      final plan = _createTestPlan();
      await offlineSync.saveRenovationPlanOffline(plan);

      // Act
      await offlineSync.deleteRenovationPlanOffline(plan.id);
      final plans = await offlineSync.getOfflineRenovationPlans();

      // Assert
      expect(plans, isEmpty);
    });

    test('getPendingChangesCount should return correct count', () async {
      // Arrange
      final plan = _createTestPlan();
      await offlineSync.saveRenovationPlanOffline(plan);

      // Act
      final count = await offlineSync.getPendingChangesCount();

      // Assert
      expect(count, greaterThan(0));
    });

    test('clearOfflineData should remove all data', () async {
      // Arrange
      final plan = _createTestPlan();
      await offlineSync.saveRenovationPlanOffline(plan);

      // Act
      await offlineSync.clearOfflineData();
      final plans = await offlineSync.getOfflineRenovationPlans();
      final count = await offlineSync.getPendingChangesCount();

      // Assert
      expect(plans, isEmpty);
      expect(count, equals(0));
    });
  });
}

RenovationPlan _createTestPlan() {
  return RenovationPlan(
    id: 'test_${DateTime.now().millisecondsSinceEpoch}',
    userId: 'test_user',
    name: 'Test Plan',
    description: 'Test description',
    rooms: [],
    totalBudget: 10000,
    estimatedCost: 5000,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'draft',
    materialPrices: [],
    recommendations: [],
  );
}






