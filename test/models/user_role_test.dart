import 'package:flutter_test/flutter_test.dart';
import 'package:budapp/models/user_role.dart';

void main() {
  group('UserRole Tests', () {
    test('UserProfile should be created correctly', () {
      // Arrange & Act
      final profile = UserProfile(
        id: 'user1',
        email: 'test@example.com',
        displayName: 'Test User',
        role: UserRole.investor,
        createdAt: DateTime.now(),
      );

      // Assert
      expect(profile.id, equals('user1'));
      expect(profile.email, equals('test@example.com'));
      expect(profile.role, equals(UserRole.investor));
    });

    test('UserProfile roleDisplayName should return correct Polish names', () {
      // Arrange & Act & Assert
      final investorProfile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.investor,
        createdAt: DateTime.now(),
      );
      expect(investorProfile.roleDisplayName, equals('Inwestor'));

      final managerProfile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.manager,
        createdAt: DateTime.now(),
      );
      expect(managerProfile.roleDisplayName, equals('Kierownik budowy'));

      final contractorProfile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.contractor,
        createdAt: DateTime.now(),
      );
      expect(contractorProfile.roleDisplayName, equals('Wykonawca'));

      final viewerProfile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.viewer,
        createdAt: DateTime.now(),
      );
      expect(viewerProfile.roleDisplayName, equals('Gość'));
    });

    test('Investor should have all permissions', () {
      // Arrange
      final profile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.investor,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(profile.hasPermission(Permission.viewProject), isTrue);
      expect(profile.hasPermission(Permission.editProject), isTrue);
      expect(profile.hasPermission(Permission.deleteProject), isTrue);
      expect(profile.hasPermission(Permission.editBudget), isTrue);
      expect(profile.hasPermission(Permission.changeRoles), isTrue);
    });

    test('Manager should have limited permissions', () {
      // Arrange
      final profile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.manager,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(profile.hasPermission(Permission.viewProject), isTrue);
      expect(profile.hasPermission(Permission.editProject), isTrue);
      expect(profile.hasPermission(Permission.editBudget), isFalse);
      expect(profile.hasPermission(Permission.deleteProject), isFalse);
      expect(profile.hasPermission(Permission.changeRoles), isFalse);
    });

    test('Contractor should have minimal permissions', () {
      // Arrange
      final profile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.contractor,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(profile.hasPermission(Permission.viewProject), isTrue);
      expect(profile.hasPermission(Permission.editProject), isFalse);
      expect(profile.hasPermission(Permission.editBudget), isFalse);
      expect(profile.hasPermission(Permission.updateTaskStatus), isTrue);
    });

    test('Viewer should only have view permissions', () {
      // Arrange
      final profile = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Test',
        role: UserRole.viewer,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(profile.hasPermission(Permission.viewProject), isTrue);
      expect(profile.hasPermission(Permission.editProject), isFalse);
      expect(profile.hasPermission(Permission.editBudget), isFalse);
      expect(profile.hasPermission(Permission.updateTaskStatus), isFalse);
    });

    test('ProjectMember should be created correctly', () {
      // Arrange & Act
      final member = ProjectMember(
        projectId: 'project1',
        userId: 'user1',
        userEmail: 'test@example.com',
        userName: 'Test User',
        role: UserRole.contractor,
        addedAt: DateTime.now(),
        addedBy: 'admin',
      );

      // Assert
      expect(member.projectId, equals('project1'));
      expect(member.userId, equals('user1'));
      expect(member.role, equals(UserRole.contractor));
    });

    test('Permission displayName should be in Polish', () {
      // Act & Assert
      expect(Permission.viewProject.displayName, equals('Przeglądanie projektu'));
      expect(Permission.editBudget.displayName, equals('Edycja budżetu'));
      expect(Permission.inviteMembers.displayName, equals('Zapraszanie członków'));
    });

    test('UserProfile copyWith should work correctly', () {
      // Arrange
      final original = UserProfile(
        id: 'test',
        email: 'test@example.com',
        displayName: 'Original Name',
        role: UserRole.contractor,
        createdAt: DateTime.now(),
      );

      // Act
      final updated = original.copyWith(
        displayName: 'Updated Name',
        role: UserRole.manager,
      );

      // Assert
      expect(updated.id, equals(original.id));
      expect(updated.email, equals(original.email));
      expect(updated.displayName, equals('Updated Name'));
      expect(updated.role, equals(UserRole.manager));
    });
  });
}

