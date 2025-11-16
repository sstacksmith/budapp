import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/renovation_plan.dart';

class AIService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get API key from environment variables
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  final String aiMode = 'gemini';
  
  // Gemini Model
  late final GenerativeModel? _geminiModel;
  
  AIService() {
    try {
      if (_apiKey.isEmpty) {
        _geminiModel = null;
        return;
      }
      _geminiModel = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _apiKey,
      );
    } catch (e) {
      _geminiModel = null;
    }
  }

  // Generate renovation plan using AI
  Future<RenovationPlan> generateRenovationPlan({
    required String userId,
    required String name,
    required String description,
    required List<Room> rooms,
    required double budget,
  }) async {
    try {
      // Validate input
      if (rooms.isEmpty) {
        throw Exception('Lista pokoi nie może być pusta');
      }
      
      if (budget <= 0) {
        throw Exception('Budżet musi być większy od zera');
      }
      
      // Generate materials for each room based on work description
      List<Room> enhancedRooms = [];
      for (Room room in rooms) {
        List<Material> materials;
        List<Task> tasks;
        
        // Use Gemini AI if available, otherwise fallback to keyword matching
        if (aiMode == 'gemini' && _geminiModel != null) {
          materials = await _generateMaterialsWithGemini(room);
          tasks = await _generateTasksWithGemini(room);
        } else {
          materials = await _generateMaterialsForRoom(room);
          tasks = await _generateTasksForRoom(room);
        }
        
        double roomCost = materials.fold(0.0, (sum, material) => sum + material.totalPrice) +
                         tasks.fold(0.0, (sum, task) => sum + task.estimatedCost);
        
        enhancedRooms.add(Room(
          id: room.id,
          name: room.name,
          area: room.area,
          type: room.type,
          workDescription: room.workDescription,
          materials: materials,
          tasks: tasks,
          estimatedCost: roomCost,
        ));
      }

      // Generate recommendations
      List<Recommendation> recommendations = await _generateRecommendations(enhancedRooms, budget);

      // Calculate total cost
      double totalCost = enhancedRooms.fold(0.0, (sum, room) => sum + room.estimatedCost);

      // Create renovation plan
      RenovationPlan plan = RenovationPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
        description: description,
        rooms: enhancedRooms,
        totalBudget: budget,
        estimatedCost: totalCost,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'draft',
        materialPrices: await _getMaterialPrices(),
        recommendations: recommendations,
      );

      // Save to Firestore
      try {
        Map<String, dynamic> firestoreData = plan.toFirestore();
        await _firestore.collection('renovation_plans').doc(plan.id).set(firestoreData);
      } catch (firestoreError) {
        throw Exception('Nie udało się zapisać planu do bazy danych: $firestoreError');
      }

      return plan;
    } catch (e) {
      throw Exception('Nie udało się wygenerować planu remontu: $e');
    }
  }

  // Generate materials for a specific room based on work description
  Future<List<Material>> _generateMaterialsForRoom(Room room) async {
    List<Material> materials = [];
    
    // Calculate wall area (assuming 2.7m height)
    double wallArea = room.area * 2.5; // Obwód * wysokość (uproszczone)
    
    // Analyze work description for keywords
    String workDesc = room.workDescription.toLowerCase();
    bool needsPainting = workDesc.contains('malowanie') || workDesc.contains('farba') || workDesc.contains('ścian');
    bool needsTiling = workDesc.contains('płytki') || workDesc.contains('kafelki') || workDesc.contains('glazura');
    bool needsFlooring = workDesc.contains('podłoga') || workDesc.contains('panele') || workDesc.contains('parkiet');
    bool needsElectrical = workDesc.contains('elektryka') || workDesc.contains('gniazdka') || workDesc.contains('oświetlenie');
    bool needsPlumbing = workDesc.contains('hydraulika') || workDesc.contains('rury') || workDesc.contains('woda');
    bool needsDemolition = workDesc.contains('wyburzenie') || workDesc.contains('rozbiórka') || workDesc.contains('demontaż');
    
    // Generate materials based on work description AND room type
    if (needsPainting) {
      // Grunt pod farbę
      materials.add(Material(
        id: '${room.id}_primer',
        name: 'Grunt głęboko penetrujący',
        category: 'primer',
        quantity: wallArea * 0.12, // 0.12L na m² ściany
        unit: 'L',
        pricePerUnit: 35.0,
        totalPrice: wallArea * 0.12 * 35.0,
        supplier: 'Leroy Merlin',
        supplierUrl: 'https://leroymerlin.pl',
        imageUrl: '',
        description: 'Grunt głęboko penetrujący pod farbę',
      ));
      
      // Gładź gipsowa
      materials.add(Material(
        id: '${room.id}_plaster',
        name: 'Gładź gipsowa',
        category: 'plaster',
        quantity: wallArea * 1.5, // 1.5kg na m²
        unit: 'kg',
        pricePerUnit: 1.2,
        totalPrice: wallArea * 1.5 * 1.2,
        supplier: 'Castorama',
        supplierUrl: 'https://castorama.pl',
        imageUrl: '',
        description: 'Gładź gipsowa do wyrównania ścian',
      ));
      
      // Farba emulsyjna
      materials.add(Material(
        id: '${room.id}_paint',
        name: 'Farba emulsyjna premium',
        category: 'paint',
        quantity: wallArea * 0.15, // 0.15L na m² ściany (2 warstwy)
        unit: 'L',
        pricePerUnit: 45.0, // Cena realistyczna
        totalPrice: wallArea * 0.15 * 45.0,
        supplier: 'Leroy Merlin',
        supplierUrl: 'https://leroymerlin.pl',
        imageUrl: '',
        description: 'Farba emulsyjna premium do ścian i sufitów',
      ));
    }
    
    if (needsTiling) {
      // Płytki ceramiczne
      materials.add(Material(
        id: '${room.id}_tiles',
        name: 'Płytki ceramiczne premium',
        category: 'tiles',
        quantity: room.area * 1.15, // +15% na zapas (cięcie, uszkodzenia)
        unit: 'm²',
        pricePerUnit: 95.0, // Realistyczna cena
        totalPrice: room.area * 1.15 * 95.0,
        supplier: 'Castorama',
        supplierUrl: 'https://castorama.pl',
        imageUrl: '',
        description: 'Płytki ceramiczne premium 60x60cm',
      ));
      
      // Klej do płytek
      materials.add(Material(
        id: '${room.id}_tile_adhesive',
        name: 'Klej do płytek',
        category: 'adhesive',
        quantity: room.area * 6, // 6kg na m²
        unit: 'kg',
        pricePerUnit: 12.0, // Zaktualizowana cena
        totalPrice: room.area * 6 * 12.0,
        supplier: 'OBI',
        supplierUrl: 'https://obi.pl',
        imageUrl: '',
        description: 'Klej do płytek ceramicznych C2TE',
      ));
      
      // Fuga
      materials.add(Material(
        id: '${room.id}_grout',
        name: 'Fuga epoksydowa',
        category: 'grout',
        quantity: room.area * 0.5, // 0.5kg na m²
        unit: 'kg',
        pricePerUnit: 45.0,
        totalPrice: room.area * 0.5 * 45.0,
        supplier: 'Leroy Merlin',
        supplierUrl: 'https://leroymerlin.pl',
        imageUrl: '',
        description: 'Fuga epoksydowa wodoodporna',
      ));
      
      // Podkład pod płytki
      materials.add(Material(
        id: '${room.id}_tile_primer',
        name: 'Preparat gruntujący',
        category: 'primer',
        quantity: room.area * 0.15,
        unit: 'L',
        pricePerUnit: 25.0,
        totalPrice: room.area * 0.15 * 25.0,
        supplier: 'Castorama',
        supplierUrl: 'https://castorama.pl',
        imageUrl: '',
        description: 'Preparat gruntujący pod płytki',
      ));
    }
    
    if (needsFlooring) {
      // Panele podłogowe
      materials.add(Material(
        id: '${room.id}_flooring',
        name: 'Panele laminowane AC5',
        category: 'flooring',
        quantity: room.area * 1.08, // +8% na zapas
        unit: 'm²',
        pricePerUnit: 75.0, // Realistyczna cena dla dobrej jakości
        totalPrice: room.area * 1.08 * 75.0,
        supplier: 'Leroy Merlin',
        supplierUrl: 'https://leroymerlin.pl',
        imageUrl: '',
        description: 'Panele laminowane AC5, klasa ścieralności 32',
      ));
      
      // Podkład pod panele
      materials.add(Material(
        id: '${room.id}_underlay',
        name: 'Podkład pod panele',
        category: 'underlay',
        quantity: room.area * 1.05,
        unit: 'm²',
        pricePerUnit: 8.0,
        totalPrice: room.area * 1.05 * 8.0,
        supplier: 'OBI',
        supplierUrl: 'https://obi.pl',
        imageUrl: '',
        description: 'Podkład piankowy 3mm',
      ));
      
      // Listwy przypodłogowe
      double perimeterEstimate = math.sqrt(room.area) * 4; // Przybliżony obwód
      materials.add(Material(
        id: '${room.id}_skirting',
        name: 'Listwy przypodłogowe',
        category: 'skirting',
        quantity: perimeterEstimate * 1.1,
        unit: 'mb',
        pricePerUnit: 12.0,
        totalPrice: perimeterEstimate * 1.1 * 12.0,
        supplier: 'Leroy Merlin',
        supplierUrl: 'https://leroymerlin.pl',
        imageUrl: '',
        description: 'Listwy przypodłogowe MDF',
      ));
    }
    
    // Base materials based on room type (fallback)
    if (materials.isEmpty) {
      switch (room.type) {
      case 'kitchen':
        materials.addAll([
          Material(
            id: '${room.id}_floor_tiles',
            name: 'Płytki podłogowe',
            category: 'flooring',
            quantity: room.area,
            unit: 'm²',
            pricePerUnit: 45.0,
            totalPrice: room.area * 45.0,
            supplier: 'Leroy Merlin',
            supplierUrl: 'https://leroymerlin.pl',
            imageUrl: '',
            description: 'Płytki ceramiczne do kuchni',
          ),
          Material(
            id: '${room.id}_wall_tiles',
            name: 'Płytki ścienne',
            category: 'wall_tiles',
            quantity: room.area * 2.5,
            unit: 'm²',
            pricePerUnit: 35.0,
            totalPrice: room.area * 2.5 * 35.0,
            supplier: 'Castorama',
            supplierUrl: 'https://castorama.pl',
            imageUrl: '',
            description: 'Płytki ceramiczne na ściany',
          ),
          Material(
            id: '${room.id}_paint',
            name: 'Farba do ścian',
            category: 'paint',
            quantity: room.area * 2.5 * 0.1,
            unit: 'L',
            pricePerUnit: 25.0,
            totalPrice: room.area * 2.5 * 0.1 * 25.0,
            supplier: 'OBI',
            supplierUrl: 'https://obi.pl',
            imageUrl: '',
            description: 'Farba emulsyjna do kuchni',
          ),
        ]);
        break;
      case 'bathroom':
        materials.addAll([
          Material(
            id: '${room.id}_bathroom_tiles',
            name: 'Płytki łazienkowe',
            category: 'tiles',
            quantity: room.area * 3.0,
            unit: 'm²',
            pricePerUnit: 55.0,
            totalPrice: room.area * 3.0 * 55.0,
            supplier: 'Leroy Merlin',
            supplierUrl: 'https://leroymerlin.pl',
            imageUrl: '',
            description: 'Płytki ceramiczne do łazienki',
          ),
          Material(
            id: '${room.id}_waterproofing',
            name: 'Izolacja przeciwwodna',
            category: 'waterproofing',
            quantity: room.area,
            unit: 'm²',
            pricePerUnit: 15.0,
            totalPrice: room.area * 15.0,
            supplier: 'Castorama',
            supplierUrl: 'https://castorama.pl',
            imageUrl: '',
            description: 'Masa izolacyjna',
          ),
        ]);
        break;
      default:
        materials.addAll([
          Material(
            id: '${room.id}_paint',
            name: 'Farba do ścian',
            category: 'paint',
            quantity: room.area * 2.5 * 0.1,
            unit: 'L',
            pricePerUnit: 20.0,
            totalPrice: room.area * 2.5 * 0.1 * 20.0,
            supplier: 'OBI',
            supplierUrl: 'https://obi.pl',
            imageUrl: '',
            description: 'Farba emulsyjna',
          ),
        ]);
      }
    }

    return materials;
  }

  // ========================================
  // GEMINI AI METHODS
  // ========================================
  
  /// Generate materials using Google Gemini AI
  Future<List<Material>> _generateMaterialsWithGemini(Room room) async {
    try {
      if (_geminiModel == null) {
        return _generateMaterialsForRoom(room);
      }

      final prompt = '''
Jesteś doświadczonym ekspertem budowlanym i kosztorysantem. Przeanalizuj poniższe dane pokoju i wygeneruj szczegółową listę materiałów potrzebnych do remontu.

DANE POKOJU:
- Nazwa: ${room.name}
- Powierzchnia: ${room.area} m²
- Typ: ${room.type}
- Opis prac do wykonania: ${room.workDescription}

ZADANIE:
Wygeneruj listę materiałów w formacie JSON array. Każdy materiał musi mieć:
- name (string): Pełna nazwa materiału
- category (string): Kategoria (paint, tiles, flooring, plaster, adhesive, grout, waterproofing, electrical, plumbing, demolition)
- quantity (number): Ilość (zawsze dodatnia liczba)
- unit (string): Jednostka (m², L, kg, mb, szt)
- pricePerUnit (number): Cena za jednostkę w PLN (realistyczne polskie ceny 2024)

WAŻNE:
1. Uwzględnij WSZYSTKIE materiały potrzebne do opisanych prac
2. Dodaj materiały pomocnicze (grunt, podkład, itp.)
3. Dodaj 10-15% zapasu na cięcie i straty
4. Użyj realistycznych polskich cen z 2024 roku
5. Dla prac malarskich: oblicz powierzchnię ścian jako powierzchnia_podłogi * 2.5
6. Zwróć TYLKO JSON array, bez dodatkowego tekstu

Format odpowiedzi (przykład):
[
  {
    "name": "Farba emulsyjna premium biała",
    "category": "paint",
    "quantity": 15.5,
    "unit": "L",
    "pricePerUnit": 45.00
  },
  {
    "name": "Płytki ceramiczne 60x60cm",
    "category": "tiles",
    "quantity": 25.3,
    "unit": "m²",
    "pricePerUnit": 95.00
  }
]
''';
      final response = await _geminiModel!.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      // Parse JSON response
      final jsonStart = text.indexOf('[');
      final jsonEnd = text.lastIndexOf(']') + 1;
      
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final jsonStr = text.substring(jsonStart, jsonEnd);
        final List<dynamic> materialsData = jsonDecode(jsonStr);
        
        
        return materialsData.map((data) {
          final quantity = (data['quantity'] as num).toDouble();
          final pricePerUnit = (data['pricePerUnit'] as num).toDouble();
          
          return Material(
            id: '${room.id}_${data['name'].toString().replaceAll(' ', '_')}',
            name: data['name'],
            category: data['category'],
            quantity: quantity,
            unit: data['unit'],
            pricePerUnit: pricePerUnit,
            totalPrice: quantity * pricePerUnit,
            supplier: 'Leroy Merlin',
            supplierUrl: 'https://leroymerlin.pl',
            imageUrl: '',
            description: data['name'],
          );
        }).toList();
      }
      
      // Fallback to keyword matching if parsing fails
      return _generateMaterialsForRoom(room);
    } catch (e) {
      return _generateMaterialsForRoom(room);
    }
  }

  /// Generate tasks using Google Gemini AI
  Future<List<Task>> _generateTasksWithGemini(Room room) async {
    try {
      if (_geminiModel == null) {
        return _generateTasksForRoom(room);
      }

      final prompt = '''
Jesteś doświadczonym kierownikiem budowy. Przeanalizuj dane pokoju i wygeneruj harmonogram zadań do wykonania.

DANE POKOJU:
- Nazwa: ${room.name}
- Powierzchnia: ${room.area} m²
- Typ: ${room.type}
- Prace do wykonania: ${room.workDescription}

ZADANIE:
Wygeneruj listę zadań w formacie JSON array. Każde zadanie musi mieć:
- name (string): Nazwa zadania
- category (string): Kategoria (preparation, demolition, electrical, plumbing, flooring, tiling, painting, finishing, inspection)
- estimatedHours (number): Szacowany czas w godzinach
- estimatedCost (number): Szacowany koszt robocizny w PLN
- priority (string): high, medium lub low
- order (number): Kolejność wykonania (1, 2, 3...)

WAŻNE:
1. Zadania muszą być w LOGICZNEJ kolejności wykonania
2. Zaczynaj od przygotowania/rozbiórki, kończ na wykończeniu
3. Realistyczne czasy i koszty (stawka 60-100 PLN/h dla fachowca)
4. Uwzględnij zadania techniczne (elektryka, hydraulika) PRZED wykończeniem
5. Zwróć TYLKO JSON array, bez dodatkowego tekstu

Format odpowiedzi:
[
  {
    "name": "Zabezpieczenie pomieszczenia",
    "category": "preparation",
    "estimatedHours": 2,
    "estimatedCost": 150.00,
    "priority": "high",
    "order": 1
  }
]
''';

      final response = await _geminiModel!.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      final jsonStart = text.indexOf('[');
      final jsonEnd = text.lastIndexOf(']') + 1;
      
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final jsonStr = text.substring(jsonStart, jsonEnd);
        final List<dynamic> tasksData = jsonDecode(jsonStr);
        
        
        // Sort by order if provided
        tasksData.sort((a, b) {
          final orderA = a['order'] ?? 999;
          final orderB = b['order'] ?? 999;
          return orderA.compareTo(orderB);
        });
        
        return tasksData.map((data) {
          return Task(
            id: '${room.id}_${data['name'].toString().replaceAll(' ', '_')}',
            name: data['name'],
            description: data['name'],
            category: data['category'],
            estimatedHours: (data['estimatedHours'] as num).toInt(),
            estimatedCost: (data['estimatedCost'] as num).toDouble(),
            priority: data['priority'] ?? 'medium',
            status: 'pending',
            dependencies: [],
          );
        }).toList();
      }
      
      return _generateTasksForRoom(room);
    } catch (e) {
      return _generateTasksForRoom(room);
    }
  }

  // Generate tasks for a specific room based on work description
  Future<List<Task>> _generateTasksForRoom(Room room) async {
    List<Task> tasks = [];
    
    // Calculate wall area (assuming 2.7m height)
    double wallArea = room.area * 2.5; // Obwód * wysokość (uproszczone)
    
    // Analyze work description for tasks
    String workDesc = room.workDescription.toLowerCase();
    bool needsPainting = workDesc.contains('malowanie') || workDesc.contains('farba');
    bool needsTiling = workDesc.contains('płytki') || workDesc.contains('kafelki');
    bool needsFlooring = workDesc.contains('podłoga') || workDesc.contains('panele');
    bool needsElectrical = workDesc.contains('elektryka') || workDesc.contains('gniazdka');
    bool needsPlumbing = workDesc.contains('hydraulika') || workDesc.contains('rury');
    bool needsDemolition = workDesc.contains('wyburzenie') || workDesc.contains('rozbiórka');
    
    // Przygotowanie powierzchni (zawsze potrzebne)
    tasks.add(Task(
      id: '${room.id}_preparation',
      name: 'Przygotowanie powierzchni',
      description: 'Zabezpieczenie, oczyszczenie i przygotowanie powierzchni',
      category: 'preparation',
      estimatedHours: (room.area * 0.5).toInt() + 2,
      estimatedCost: room.area * 15.0, // 15 PLN za m²
      priority: 'high',
      status: 'pending',
      dependencies: [],
    ));
    
    // Generate tasks based on work description
    if (needsTiling) {
      tasks.add(Task(
        id: '${room.id}_tiling',
        name: 'Układanie płytek ceramicznych',
        description: 'Profesjonalne układanie płytek z fugowaniem',
        category: 'tiling',
        estimatedHours: (room.area * 3).toInt(), // 3h na m²
        estimatedCost: room.area * 120.0, // 120 PLN za m² (realistyczna cena)
        priority: 'high',
        status: 'pending',
        dependencies: ['${room.id}_preparation'],
      ));
    }
    
    if (needsPainting) {
      // Szpachlowanie
      tasks.add(Task(
        id: '${room.id}_plastering',
        name: 'Szpachlowanie ścian',
        description: 'Wyrównanie i wygładzenie ścian gipsem',
        category: 'plastering',
        estimatedHours: (wallArea * 0.5).toInt(),
        estimatedCost: wallArea * 25.0, // 25 PLN za m² ściany
        priority: 'high',
        status: 'pending',
        dependencies: ['${room.id}_preparation'],
      ));
      
      // Malowanie
      tasks.add(Task(
        id: '${room.id}_painting',
        name: 'Malowanie ścian i sufitów',
        description: 'Malowanie 2 warstwy farby emulsyjnej',
        category: 'painting',
        estimatedHours: (wallArea * 0.5).toInt(),
        estimatedCost: wallArea * 35.0, // 35 PLN za m² ściany (realistyczna cena)
        priority: 'medium',
        status: 'pending',
        dependencies: ['${room.id}_plastering'],
      ));
    }
    
    if (needsFlooring) {
      tasks.add(Task(
        id: '${room.id}_flooring',
        name: 'Montaż paneli podłogowych',
        description: 'Profesjonalny montaż paneli z podkładem i listwami',
        category: 'flooring',
        estimatedHours: (room.area * 1.2).toInt(), // 1.2h na m²
        estimatedCost: room.area * 50.0, // 50 PLN za m² (realistyczna cena)
        priority: 'high',
        status: 'pending',
        dependencies: ['${room.id}_preparation'],
      ));
    }
    
    if (needsElectrical) {
      // Koszt zależy od wielkości pomieszczenia
      int outletsEstimate = (room.area / 10).ceil() + 2; // ~1 gniazdko na 10m²
      tasks.add(Task(
        id: '${room.id}_electrical',
        name: 'Prace elektryczne',
        description: 'Montaż instalacji elektrycznej, gniazdek (${outletsEstimate}szt), włączników i oświetlenia',
        category: 'electrical',
        estimatedHours: outletsEstimate * 2 + 4,
        estimatedCost: outletsEstimate * 150.0 + 500.0, // 150 PLN/gniazdko + podstawa
        priority: 'high',
        status: 'pending',
        dependencies: [],
      ));
    }
    
    if (needsPlumbing) {
      tasks.add(Task(
        id: '${room.id}_plumbing',
        name: 'Prace hydrauliczne',
        description: 'Montaż instalacji wodnej i kanalizacyjnej',
        category: 'plumbing',
        estimatedHours: 16,
        estimatedCost: 2500.0, // Realistyczna cena
        priority: 'high',
        status: 'pending',
        dependencies: [],
      ));
    }
    
    if (needsDemolition) {
      tasks.add(Task(
        id: '${room.id}_demolition',
        name: 'Prace rozbiórkowe',
        description: 'Wyburzenie starych elementów, wywóz gruzu',
        category: 'demolition',
        estimatedHours: (room.area * 1).toInt() + 4,
        estimatedCost: room.area * 40.0 + 500.0, // 40 PLN/m² + wywóz
        priority: 'high',
        status: 'pending',
        dependencies: [],
      ));
    }
    
    // Fallback: generate tasks based on room type if no specific tasks
    if (tasks.isEmpty) {
      switch (room.type) {
      case 'kitchen':
        tasks.addAll([
          Task(
            id: '${room.id}_preparation',
            name: 'Przygotowanie powierzchni',
            description: 'Oczyszczenie i przygotowanie ścian i podłogi',
            category: 'preparation',
            estimatedHours: 4,
            estimatedCost: 200.0,
            priority: 'high',
            status: 'pending',
            dependencies: [],
          ),
          Task(
            id: '${room.id}_tiling',
            name: 'Układanie płytek',
            description: 'Układanie płytek podłogowych i ściennych',
            category: 'tiling',
            estimatedHours: 8,
            estimatedCost: 400.0,
            priority: 'high',
            status: 'pending',
            dependencies: ['${room.id}_preparation'],
          ),
          Task(
            id: '${room.id}_painting',
            name: 'Malowanie',
            description: 'Malowanie ścian i sufitów',
            category: 'painting',
            estimatedHours: 6,
            estimatedCost: 300.0,
            priority: 'medium',
            status: 'pending',
            dependencies: ['${room.id}_tiling'],
          ),
        ]);
        break;
      case 'bathroom':
        tasks.addAll([
          Task(
            id: '${room.id}_waterproofing',
            name: 'Izolacja przeciwwodna',
            description: 'Wykonanie izolacji przeciwwodnej',
            category: 'waterproofing',
            estimatedHours: 6,
            estimatedCost: 350.0,
            priority: 'high',
            status: 'pending',
            dependencies: [],
          ),
          Task(
            id: '${room.id}_tiling',
            name: 'Układanie płytek',
            description: 'Układanie płytek w łazience',
            category: 'tiling',
            estimatedHours: 10,
            estimatedCost: 500.0,
            priority: 'high',
            status: 'pending',
            dependencies: ['${room.id}_waterproofing'],
          ),
        ]);
        break;
      default:
        tasks.addAll([
          Task(
            id: '${room.id}_preparation',
            name: 'Przygotowanie powierzchni',
            description: 'Oczyszczenie i przygotowanie ścian',
            category: 'preparation',
            estimatedHours: 2,
            estimatedCost: 100.0,
            priority: 'high',
            status: 'pending',
            dependencies: [],
          ),
          Task(
            id: '${room.id}_painting',
            name: 'Malowanie',
            description: 'Malowanie ścian i sufitów',
            category: 'painting',
            estimatedHours: 4,
            estimatedCost: 200.0,
            priority: 'medium',
            status: 'pending',
            dependencies: ['${room.id}_preparation'],
          ),
        ]);
      }
    }

    return tasks;
  }

  // Generate AI recommendations
  Future<List<Recommendation>> _generateRecommendations(List<Room> rooms, double budget) async {
    List<Recommendation> recommendations = [];
    
    double totalCost = rooms.fold(0.0, (sum, room) => sum + room.estimatedCost);
    
    
    // 1. Budget recommendations
    if (totalCost > budget) {
      double difference = totalCost - budget;
      recommendations.add(Recommendation(
        id: 'budget_exceeded',
        type: 'cost_saving',
        title: '⚠️ Przekroczenie budżetu',
        description: 'Szacowany koszt (${totalCost.toStringAsFixed(2)} PLN) przekracza budżet o ${difference.toStringAsFixed(2)} PLN. Rozważ:\n• Wybór tańszych materiałów\n• Zmniejszenie zakresu prac\n• Rozłożenie remontu na etapy',
        potentialSavings: difference,
        priority: 'high',
        relatedMaterials: [],
      ));
    } else {
      double surplus = budget - totalCost;
      if (surplus > 1000) {
        recommendations.add(Recommendation(
          id: 'budget_surplus',
          type: 'quality_improvement',
          title: '✨ Możliwość ulepszenia',
          description: 'Masz ${surplus.toStringAsFixed(2)} PLN wolnego budżetu! Rozważ:\n• Lepszej jakości materiały\n• Dodatkowe elementy (grzejniki, lepsze oświetlenie)\n• Profesjonalny montaż',
          potentialSavings: 0,
          priority: 'low',
          relatedMaterials: [],
        ));
      }
    }

    // 2. Material-based recommendations
    Map<String, List<Material>> materialsByCategory = {};
    for (Room room in rooms) {
      for (Material material in room.materials) {
        String category = material.category;
        if (!materialsByCategory.containsKey(category)) {
          materialsByCategory[category] = [];
        }
        materialsByCategory[category]!.add(material);
      }
    }

    // Recommendations for expensive materials
    int materialRecommendationsCount = 0;
    for (Room room in rooms) {
      for (Material material in room.materials) {
        if (material.pricePerUnit > 70 && materialRecommendationsCount < 2) {
          double savings = material.totalPrice * 0.12; // 12% savings (realistyczne)
          recommendations.add(Recommendation(
            id: '${material.id}_alternative',
            type: 'cost_saving',
            title: '💰 Tańsza alternatywa: ${material.name}',
            description: 'W ${room.name}: ${material.name} kosztuje ${material.totalPrice.toStringAsFixed(2)} PLN.\n\nZnaleziono tańszą opcję w ${_getCheaperSupplier(material.supplier)} za ${(material.pricePerUnit * 0.88).toStringAsFixed(2)} PLN/${material.unit}.\n\n💡 Oszczędność: ${savings.toStringAsFixed(2)} PLN',
            potentialSavings: savings,
            priority: 'medium',
            relatedMaterials: [material.id],
          ));
          materialRecommendationsCount++;
        }
      }
    }

    // 3. Task optimization recommendations
    Map<String, List<Room>> roomsByTask = {};
    for (Room room in rooms) {
      for (Task task in room.tasks) {
        if (!roomsByTask.containsKey(task.category)) {
          roomsByTask[task.category] = [];
        }
        roomsByTask[task.category]!.add(room);
      }
    }

    for (String taskCategory in roomsByTask.keys) {
      if (roomsByTask[taskCategory]!.length > 1) {
        List<Room> affectedRooms = roomsByTask[taskCategory]!;
        double totalTaskCost = affectedRooms.fold(0.0, (sum, room) =>
          sum + room.tasks.where((t) => t.category == taskCategory).fold(0.0, (s, t) => s + t.estimatedCost)
        );
        recommendations.add(Recommendation(
          id: 'bulk_${taskCategory}',
          type: 'cost_saving',
          title: '🔨 Oszczędność na ${_getTaskNamePL(taskCategory)}',
          description: 'Wykryto ${affectedRooms.length} pokoje wymagające ${_getTaskNamePL(taskCategory)} (${affectedRooms.map((r) => r.name).join(', ')}).\n\nWykonując te prace jednocześnie możesz zaoszczędzić do 20% na robociźnie (${(totalTaskCost * 0.2).toStringAsFixed(2)} PLN).',
          potentialSavings: totalTaskCost * 0.2,
          priority: 'high',
          relatedMaterials: [],
        ));
      }
    }

    // 4. Season-based recommendations
    DateTime now = DateTime.now();
    if (now.month >= 11 || now.month <= 2) {
      recommendations.add(Recommendation(
        id: 'winter_discount',
        type: 'cost_saving',
        title: '❄️ Zimowe promocje',
        description: 'Zima to najlepszy czas na remont! Większość firm ma niższe ceny i większą dostępność.\nPotencjalna oszczędność: 10-15% na robociźnie.',
        potentialSavings: totalCost * 0.1,
        priority: 'low',
        relatedMaterials: [],
      ));
    } else if (now.month >= 6 && now.month <= 8) {
      recommendations.add(Recommendation(
        id: 'summer_timing',
        type: 'time_saving',
        title: '☀️ Letni sezon remontowy',
        description: 'Lato to popularny sezon remontowy - wysokie ceny i długie terminy oczekiwania.\nRozważ przesunięcie niepriorytecnych prac na jesień/zimę.',
        potentialSavings: 0,
        priority: 'low',
        relatedMaterials: [],
      ));
    }

    // 5. Quality recommendations
    bool hasWaterProofing = rooms.any((r) => 
      r.materials.any((m) => m.category == 'waterproofing') || 
      r.type == 'bathroom'
    );
    
    if (hasWaterProofing) {
      recommendations.add(Recommendation(
        id: 'quality_waterproofing',
        type: 'quality_improvement',
        title: '💧 Ważne: Izolacja przeciwwodna',
        description: 'W Twoim planie są pomieszczenia mokre (łazienka/kuchnia).\n\nNIE oszczędzaj na:\n• Izolacji przeciwwodnej (min. 2 warstwy)\n• Jakości płytek (klasa min. 4)\n• Fudze wodoodpornej\n\nTo zabezpieczy przed kosztownymi naprawami w przyszłości!',
        potentialSavings: 0,
        priority: 'high',
        relatedMaterials: [],
      ));
    }

    // 6. Always add at least one general tip
    if (recommendations.isEmpty || recommendations.length < 2) {
      recommendations.add(Recommendation(
        id: 'general_tip_1',
        type: 'cost_saving',
        title: '💡 Ogólna rada: Kupuj materiały z zapasem',
        description: 'Zawsze kupuj o 5-10% więcej materiałów niż wyliczone:\n• Płytki: +10% (cięcie i uszkodzenia)\n• Farba: +10% (druga warstwa)\n• Panele: +5% (cięcie)\n\nTo zabezpieczy przed brakiem materiału i różnicą w odcieniu!',
        potentialSavings: 0,
        priority: 'medium',
        relatedMaterials: [],
      ));
    }

    if (recommendations.length < 3) {
      recommendations.add(Recommendation(
        id: 'general_tip_2',
        type: 'time_saving',
        title: '⏱️ Optymalna kolejność prac',
        description: 'Zalecana kolejność remontu:\n1. Wyburzenia i rozbiórki\n2. Instalacje (elektryka, hydraulika)\n3. Tynkowanie i gładzie\n4. Podłogi\n5. Malowanie\n6. Montaż wyposażenia\n\nTo zapobiegnie uszkodzeniom i powtarzaniu prac!',
        potentialSavings: 0,
        priority: 'medium',
        relatedMaterials: [],
      ));
    }

    return recommendations;
  }

  String _getCheaperSupplier(String currentSupplier) {
    Map<String, String> alternatives = {
      'Leroy Merlin': 'Castorama',
      'Castorama': 'Merkury Market',
      'OBI': 'Castorama',
      'Merkury Market': 'OBI',
    };
    return alternatives[currentSupplier] ?? 'innym sklepie';
  }

  String _getTaskNamePL(String category) {
    Map<String, String> names = {
      'tiling': 'układaniu płytek',
      'painting': 'malowaniu',
      'flooring': 'układaniu podłóg',
      'electrical': 'pracach elektrycznych',
      'plumbing': 'pracach hydraulicznych',
      'preparation': 'przygotowaniu powierzchni',
      'waterproofing': 'izolacji',
    };
    return names[category] ?? category;
  }

  // Get material prices from various suppliers
  Future<List<MaterialPrice>> _getMaterialPrices() async {
    // Simulate fetching prices from multiple suppliers
    // W rzeczywistej aplikacji użyj web scraping lub API
    List<MaterialPrice> prices = [];
    
    // Płytki ceramiczne premium
    prices.addAll([
      MaterialPrice(
        id: 'tiles_leroy',
        materialName: 'Płytki ceramiczne premium',
        supplier: 'Leroy Merlin',
        price: 95.0,
        url: 'https://leroymerlin.pl/plytki-ceramiczne',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'tiles_castorama',
        materialName: 'Płytki ceramiczne premium',
        supplier: 'Castorama',
        price: 89.0,
        url: 'https://castorama.pl/plytki',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'tiles_obi',
        materialName: 'Płytki ceramiczne premium',
        supplier: 'OBI',
        price: 98.0,
        url: 'https://obi.pl/plytki-scienne-i-podlogowe',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'tiles_merkury',
        materialName: 'Płytki ceramiczne premium',
        supplier: 'Merkury Market',
        price: 82.0,
        url: 'https://merkurymarket.pl',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
    ]);
    
    // Farba emulsyjna premium
    prices.addAll([
      MaterialPrice(
        id: 'paint_leroy',
        materialName: 'Farba emulsyjna premium',
        supplier: 'Leroy Merlin',
        price: 45.0,
        url: 'https://leroymerlin.pl/farby',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'paint_castorama',
        materialName: 'Farba emulsyjna premium',
        supplier: 'Castorama',
        price: 42.0,
        url: 'https://castorama.pl/farby',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'paint_obi',
        materialName: 'Farba emulsyjna premium',
        supplier: 'OBI',
        price: 48.0,
        url: 'https://obi.pl/farby-wewnetrzne',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
    ]);
    
    // Panele laminowane AC5
    prices.addAll([
      MaterialPrice(
        id: 'flooring_leroy',
        materialName: 'Panele laminowane AC5',
        supplier: 'Leroy Merlin',
        price: 75.0,
        url: 'https://leroymerlin.pl/panele-podlogowe',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'flooring_castorama',
        materialName: 'Panele laminowane AC5',
        supplier: 'Castorama',
        price: 69.0,
        url: 'https://castorama.pl/panele',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'flooring_obi',
        materialName: 'Panele laminowane AC5',
        supplier: 'OBI',
        price: 82.0,
        url: 'https://obi.pl/panele-podlogowe',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
    ]);
    
    // Klej do płytek
    prices.addAll([
      MaterialPrice(
        id: 'adhesive_leroy',
        materialName: 'Klej do płytek',
        supplier: 'Leroy Merlin',
        price: 12.0,
        url: 'https://leroymerlin.pl/kleje-do-plytek',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'adhesive_castorama',
        materialName: 'Klej do płytek',
        supplier: 'Castorama',
        price: 11.5,
        url: 'https://castorama.pl/kleje',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
      MaterialPrice(
        id: 'adhesive_obi',
        materialName: 'Klej do płytek',
        supplier: 'OBI',
        price: 9.0,
        url: 'https://obi.pl/kleje-do-plytek',
        lastUpdated: DateTime.now(),
        currency: 'PLN',
      ),
    ]);
    
    // Sort by price (lowest first)
    prices.sort((a, b) => a.price.compareTo(b.price));
    
    return prices;
  }

  // Update material prices
  Future<void> updateMaterialPrices() async {
    try {
      List<MaterialPrice> prices = await _getMaterialPrices();
      await _firestore.collection('material_prices').doc('current').set({
        'prices': prices.map((price) => price.toMap()).toList(),
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update material prices: $e');
    }
  }

  // Get renovation plans for user
  Future<List<RenovationPlan>> getUserRenovationPlans(String userId) async {
    try {
      
      QuerySnapshot snapshot = await _firestore
          .collection('renovation_plans')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      
      List<RenovationPlan> plans = snapshot.docs
          .map((doc) {
            try {
              RenovationPlan plan = RenovationPlan.fromFirestore(doc);
              return plan;
            } catch (e) {
              return null;
            }
          })
          .whereType<RenovationPlan>()
          .toList();
      
      return plans;
    } catch (e) {
      
      // Jeśli błąd to brak indeksu, zwróć pustą listę zamiast rzucać wyjątek
      if (e.toString().contains('FAILED_PRECONDITION') || 
          e.toString().contains('requires an index')) {
        return [];
      }
      
      throw Exception('Failed to get renovation plans: $e');
    }
  }

  // Delete renovation plan
  Future<void> deleteRenovationPlan(String planId) async {
    try {
      await _firestore.collection('renovation_plans').doc(planId).delete();
    } catch (e) {
      throw Exception('Failed to delete renovation plan: $e');
    }
  }

  // Regenerate AI recommendations for an existing plan
  Future<RenovationPlan> regenerateRecommendations(RenovationPlan plan) async {
    try {
      
      // Generate new recommendations
      List<Recommendation> newRecommendations = await _generateRecommendations(plan.rooms, plan.totalBudget);
      
      
      // Create updated plan
      RenovationPlan updatedPlan = RenovationPlan(
        id: plan.id,
        userId: plan.userId,
        name: plan.name,
        description: plan.description,
        rooms: plan.rooms,
        totalBudget: plan.totalBudget,
        estimatedCost: plan.estimatedCost,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now(),
        status: plan.status,
        materialPrices: plan.materialPrices,
        recommendations: newRecommendations,
      );
      
      // Update in Firestore
      await _firestore.collection('renovation_plans').doc(plan.id).update({
        'recommendations': newRecommendations.map((rec) => rec.toMap()).toList(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      
      
      return updatedPlan;
    } catch (e) {
      throw Exception('Nie udało się wygenerować rekomendacji: $e');
    }
  }
}

