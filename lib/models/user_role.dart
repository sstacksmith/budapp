import 'package:cloud_firestore/cloud_firestore.dart';

/// User roles in the construction app
enum UserRole {
  investor, // Inwestor - właściciel projektu, pełne uprawnienia
  manager, // Kierownik budowy - zarządzanie projektem, brak dostępu do finansów
  contractor, // Wykonawca - widok zadań, aktualizacja statusu
  viewer, // Gość - tylko odczyt
}

/// User profile with role and permissions
class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final List<String> assignedProjects; // IDs of projects user has access to
  final Map<String, dynamic> metadata;

  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    this.lastLogin,
    this.assignedProjects = const [],
    this.metadata = const {},
  });

  /// Convert role enum to string
  String get roleString {
    switch (role) {
      case UserRole.investor:
        return 'investor';
      case UserRole.manager:
        return 'manager';
      case UserRole.contractor:
        return 'contractor';
      case UserRole.viewer:
        return 'viewer';
    }
  }

  /// Get localized role name
  String get roleDisplayName {
    switch (role) {
      case UserRole.investor:
        return 'Inwestor';
      case UserRole.manager:
        return 'Kierownik budowy';
      case UserRole.contractor:
        return 'Wykonawca';
      case UserRole.viewer:
        return 'Gość';
    }
  }

  /// Get role description
  String get roleDescription {
    switch (role) {
      case UserRole.investor:
        return 'Pełne uprawnienia - zarządzanie projektem, budżetem i zespołem';
      case UserRole.manager:
        return 'Zarządzanie projektem i zadaniami, brak dostępu do szczegółów finansowych';
      case UserRole.contractor:
        return 'Widok przypisanych zadań, aktualizacja statusu';
      case UserRole.viewer:
        return 'Tylko odczyt - podgląd projektu bez możliwości edycji';
    }
  }

  /// Check if user has permission
  bool hasPermission(Permission permission) {
    return permission.isAllowedForRole(role);
  }

  /// Create from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: _parseRole(data['role']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
      assignedProjects: List<String>.from(data['assignedProjects'] ?? []),
      metadata: data['metadata'] ?? {},
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': roleString,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'assignedProjects': assignedProjects,
      'metadata': metadata,
    };
  }

  /// Parse role from string
  static UserRole _parseRole(String? roleString) {
    switch (roleString) {
      case 'investor':
        return UserRole.investor;
      case 'manager':
        return UserRole.manager;
      case 'contractor':
        return UserRole.contractor;
      case 'viewer':
        return UserRole.viewer;
      default:
        return UserRole.viewer; // Default to most restrictive
    }
  }

  /// Copy with method
  UserProfile copyWith({
    String? displayName,
    UserRole? role,
    DateTime? lastLogin,
    List<String>? assignedProjects,
    Map<String, dynamic>? metadata,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      assignedProjects: assignedProjects ?? this.assignedProjects,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Permission types in the app
enum Permission {
  // Project permissions
  viewProject,
  editProject,
  deleteProject,
  createProject,
  
  // Budget permissions
  viewBudget,
  editBudget,
  viewDetailedCosts,
  
  // Task permissions
  viewTasks,
  editTasks,
  assignTasks,
  updateTaskStatus,
  
  // Team permissions
  viewTeam,
  inviteMembers,
  removeMembers,
  changeRoles,
  
  // Material permissions
  viewMaterials,
  editMaterials,
  orderMaterials,
  
  // Report permissions
  generateReports,
  exportData,
  
  // Settings permissions
  editSettings,
}

extension PermissionExtension on Permission {
  /// Check if permission is allowed for given role
  bool isAllowedForRole(UserRole role) {
    switch (this) {
      // Investor has all permissions
      case Permission.viewProject:
        return true;
      case Permission.editProject:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.deleteProject:
        return role == UserRole.investor;
      case Permission.createProject:
        return role == UserRole.investor;
        
      case Permission.viewBudget:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.editBudget:
        return role == UserRole.investor;
      case Permission.viewDetailedCosts:
        return role == UserRole.investor;
        
      case Permission.viewTasks:
        return true;
      case Permission.editTasks:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.assignTasks:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.updateTaskStatus:
        return role != UserRole.viewer;
        
      case Permission.viewTeam:
        return true;
      case Permission.inviteMembers:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.removeMembers:
        return role == UserRole.investor;
      case Permission.changeRoles:
        return role == UserRole.investor;
        
      case Permission.viewMaterials:
        return true;
      case Permission.editMaterials:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.orderMaterials:
        return role == UserRole.investor || role == UserRole.manager;
        
      case Permission.generateReports:
        return role == UserRole.investor || role == UserRole.manager;
      case Permission.exportData:
        return role == UserRole.investor || role == UserRole.manager;
        
      case Permission.editSettings:
        return role == UserRole.investor;
    }
  }

  /// Get permission display name
  String get displayName {
    switch (this) {
      case Permission.viewProject:
        return 'Przeglądanie projektu';
      case Permission.editProject:
        return 'Edycja projektu';
      case Permission.deleteProject:
        return 'Usuwanie projektu';
      case Permission.createProject:
        return 'Tworzenie projektu';
      case Permission.viewBudget:
        return 'Przeglądanie budżetu';
      case Permission.editBudget:
        return 'Edycja budżetu';
      case Permission.viewDetailedCosts:
        return 'Szczegółowe koszty';
      case Permission.viewTasks:
        return 'Przeglądanie zadań';
      case Permission.editTasks:
        return 'Edycja zadań';
      case Permission.assignTasks:
        return 'Przypisywanie zadań';
      case Permission.updateTaskStatus:
        return 'Aktualizacja statusu';
      case Permission.viewTeam:
        return 'Przeglądanie zespołu';
      case Permission.inviteMembers:
        return 'Zapraszanie członków';
      case Permission.removeMembers:
        return 'Usuwanie członków';
      case Permission.changeRoles:
        return 'Zmiana ról';
      case Permission.viewMaterials:
        return 'Przeglądanie materiałów';
      case Permission.editMaterials:
        return 'Edycja materiałów';
      case Permission.orderMaterials:
        return 'Zamawianie materiałów';
      case Permission.generateReports:
        return 'Generowanie raportów';
      case Permission.exportData:
        return 'Eksport danych';
      case Permission.editSettings:
        return 'Edycja ustawień';
    }
  }
}

/// Project member - linking user to project with specific role
class ProjectMember {
  final String projectId;
  final String userId;
  final String userEmail;
  final String userName;
  final UserRole role;
  final DateTime addedAt;
  final String addedBy; // User ID who added this member

  ProjectMember({
    required this.projectId,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.role,
    required this.addedAt,
    required this.addedBy,
  });

  factory ProjectMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectMember(
      projectId: data['projectId'] ?? '',
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      role: _parseRole(data['role']),
      addedAt: (data['addedAt'] as Timestamp).toDate(),
      addedBy: data['addedBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'role': _roleToString(role),
      'addedAt': Timestamp.fromDate(addedAt),
      'addedBy': addedBy,
    };
  }

  static UserRole _parseRole(String? roleString) {
    switch (roleString) {
      case 'investor':
        return UserRole.investor;
      case 'manager':
        return UserRole.manager;
      case 'contractor':
        return UserRole.contractor;
      case 'viewer':
        return UserRole.viewer;
      default:
        return UserRole.viewer;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.investor:
        return 'investor';
      case UserRole.manager:
        return 'manager';
      case UserRole.contractor:
        return 'contractor';
      case UserRole.viewer:
        return 'viewer';
    }
  }
}






