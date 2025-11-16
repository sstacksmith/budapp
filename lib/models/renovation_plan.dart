import 'package:cloud_firestore/cloud_firestore.dart';

class RenovationPlan {
  final String id;
  final String userId;
  final String name;
  final String description;
  final List<Room> rooms;
  final double totalBudget;
  final double estimatedCost;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // 'draft', 'in_progress', 'completed'
  final List<MaterialPrice> materialPrices;
  final List<Recommendation> recommendations;

  RenovationPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.rooms,
    required this.totalBudget,
    required this.estimatedCost,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.materialPrices,
    required this.recommendations,
  });

  factory RenovationPlan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Safe date parsing
    DateTime parseTimestamp(dynamic value, DateTime fallback) {
      if (value == null) return fallback;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? fallback;
      return fallback;
    }
    
    return RenovationPlan(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      rooms: (data['rooms'] as List<dynamic>?)
          ?.map((room) => Room.fromMap(room))
          .toList() ?? [],
      totalBudget: (data['totalBudget'] ?? 0).toDouble(),
      estimatedCost: (data['estimatedCost'] ?? 0).toDouble(),
      createdAt: parseTimestamp(data['createdAt'], DateTime.now()),
      updatedAt: parseTimestamp(data['updatedAt'], DateTime.now()),
      status: data['status'] ?? 'draft',
      materialPrices: (data['materialPrices'] as List<dynamic>?)
          ?.map((price) => MaterialPrice.fromMap(price))
          .toList() ?? [],
      recommendations: (data['recommendations'] as List<dynamic>?)
          ?.map((rec) => Recommendation.fromMap(rec))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'rooms': rooms.map((room) => room.toMap()).toList(),
      'totalBudget': totalBudget,
      'estimatedCost': estimatedCost,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'status': status,
      'materialPrices': materialPrices.map((price) => price.toMap()).toList(),
      'recommendations': recommendations.map((rec) => rec.toMap()).toList(),
    };
  }
}

class Room {
  final String id;
  final String name;
  final double area;
  final String type; // 'kitchen', 'bathroom', 'living_room', 'bedroom', 'other'
  final String workDescription; // Detailed description of work to be done
  final List<Material> materials;
  final List<Task> tasks;
  final double estimatedCost;

  Room({
    required this.id,
    required this.name,
    required this.area,
    required this.type,
    required this.workDescription,
    required this.materials,
    required this.tasks,
    required this.estimatedCost,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      area: (map['area'] ?? 0).toDouble(),
      type: map['type'] ?? 'other',
      workDescription: map['workDescription'] ?? '',
      materials: (map['materials'] as List<dynamic>?)
          ?.map((material) => Material.fromMap(material))
          .toList() ?? [],
      tasks: (map['tasks'] as List<dynamic>?)
          ?.map((task) => Task.fromMap(task))
          .toList() ?? [],
      estimatedCost: (map['estimatedCost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'type': type,
      'workDescription': workDescription,
      'materials': materials.map((material) => material.toMap()).toList(),
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'estimatedCost': estimatedCost,
    };
  }
}

class Material {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double totalPrice;
  final String supplier;
  final String supplierUrl;
  final String imageUrl;
  final String description;

  Material({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.supplier,
    required this.supplierUrl,
    required this.imageUrl,
    required this.description,
  });

  factory Material.fromMap(Map<String, dynamic> map) {
    return Material(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      pricePerUnit: (map['pricePerUnit'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      supplier: map['supplier'] ?? '',
      supplierUrl: map['supplierUrl'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
      'supplier': supplier,
      'supplierUrl': supplierUrl,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

class Task {
  final String id;
  final String name;
  final String description;
  final String category;
  final int estimatedHours;
  final double estimatedCost;
  final String priority; // 'low', 'medium', 'high'
  final String status; // 'pending', 'in_progress', 'completed'
  final List<String> dependencies;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.estimatedHours,
    required this.estimatedCost,
    required this.priority,
    required this.status,
    required this.dependencies,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      estimatedHours: map['estimatedHours'] ?? 0,
      estimatedCost: (map['estimatedCost'] ?? 0).toDouble(),
      priority: map['priority'] ?? 'medium',
      status: map['status'] ?? 'pending',
      dependencies: List<String>.from(map['dependencies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'estimatedHours': estimatedHours,
      'estimatedCost': estimatedCost,
      'priority': priority,
      'status': status,
      'dependencies': dependencies,
    };
  }
}

class MaterialPrice {
  final String id;
  final String materialName;
  final String supplier;
  final double price;
  final String url;
  final DateTime lastUpdated;
  final String currency;

  MaterialPrice({
    required this.id,
    required this.materialName,
    required this.supplier,
    required this.price,
    required this.url,
    required this.lastUpdated,
    required this.currency,
  });

  factory MaterialPrice.fromMap(Map<String, dynamic> map) {
    // Safe date parsing
    DateTime parseTimestamp(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }
    
    return MaterialPrice(
      id: map['id'] ?? '',
      materialName: map['materialName'] ?? '',
      supplier: map['supplier'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      url: map['url'] ?? '',
      lastUpdated: parseTimestamp(map['lastUpdated']),
      currency: map['currency'] ?? 'PLN',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'materialName': materialName,
      'supplier': supplier,
      'price': price,
      'url': url,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'currency': currency,
    };
  }
}

class Recommendation {
  final String id;
  final String type; // 'cost_saving', 'quality_improvement', 'time_saving'
  final String title;
  final String description;
  final double potentialSavings;
  final String priority;
  final List<String> relatedMaterials;

  Recommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.potentialSavings,
    required this.priority,
    required this.relatedMaterials,
  });

  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      potentialSavings: (map['potentialSavings'] ?? 0).toDouble(),
      priority: map['priority'] ?? 'medium',
      relatedMaterials: List<String>.from(map['relatedMaterials'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'potentialSavings': potentialSavings,
      'priority': priority,
      'relatedMaterials': relatedMaterials,
    };
  }
}

