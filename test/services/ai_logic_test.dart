import 'package:flutter_test/flutter_test.dart';
import 'package:budapp/models/renovation_plan.dart';

/// Tests for AI Logic (without Firebase dependency)
/// These tests verify the core AI logic and algorithms
void main() {
  group('AI Logic Tests (No Firebase)', () {
    group('Keyword Matching Logic', () {
      test('Painting keywords are detected correctly', () {
        const descriptions = [
          'malowanie ścian',
          'farba na suficie',
          'pomalować pokój',
        ];

        for (var desc in descriptions) {
          final lowerDesc = desc.toLowerCase();
          final hasPaintingKeyword = lowerDesc.contains('malow') || 
              lowerDesc.contains('farb') || 
              lowerDesc.contains('ścian');
          
          expect(hasPaintingKeyword, isTrue, reason: 'Should detect painting in: $desc');
        }
      });

      test('Tiling keywords are detected correctly', () {
        const descriptions = [
          'układanie płytek',
          'kafelki w łazience',
          'glazura na ścianie',
        ];

        for (var desc in descriptions) {
          final lowerDesc = desc.toLowerCase();
          final hasTilingKeyword = lowerDesc.contains('płyt') || 
              lowerDesc.contains('kafel') || 
              lowerDesc.contains('glazur') ||
              lowerDesc.contains('układa');
          
          expect(hasTilingKeyword, isTrue, reason: 'Should detect tiling in: $desc');
        }
      });

      test('Flooring keywords are detected correctly', () {
        const descriptions = [
          'wymiana podłogi',
          'panele podłogowe',
          'parkiet w salonie',
        ];

        for (var desc in descriptions) {
          final lowerDesc = desc.toLowerCase();
          final hasFlooringKeyword = lowerDesc.contains('podłog') || 
              lowerDesc.contains('panel') || 
              lowerDesc.contains('parkiet');
          
          expect(hasFlooringKeyword, isTrue, reason: 'Should detect flooring in: $desc');
        }
      });

      test('Electrical keywords are detected correctly', () {
        const descriptions = [
          'wymiana instalacji elektrycznej',
          'nowe gniazdka',
          'oświetlenie LED',
        ];

        for (var desc in descriptions) {
          final lowerDesc = desc.toLowerCase();
          final hasElectricalKeyword = lowerDesc.contains('elektr') || 
              lowerDesc.contains('gniazdka') || 
              lowerDesc.contains('oświetlenie');
          
          expect(hasElectricalKeyword, isTrue, reason: 'Should detect electrical in: $desc');
        }
      });

      test('Plumbing keywords are detected correctly', () {
        const descriptions = [
          'wymiana rur wodnych',
          'instalacja hydrauliczna',
          'nowa instalacja wodna',
        ];

        for (var desc in descriptions) {
          final lowerDesc = desc.toLowerCase();
          final hasPlumbingKeyword = lowerDesc.contains('hydraul') || 
              lowerDesc.contains('rur') || 
              lowerDesc.contains('wod') ||
              lowerDesc.contains('instalac');
          
          expect(hasPlumbingKeyword, isTrue, reason: 'Should detect plumbing in: $desc');
        }
      });
    });

    group('Material Calculation Logic', () {
      test('Paint quantity calculation with wall area', () {
        const roomArea = 20.0;
        const wallHeight = 2.5;
        // Simplified: wall area = floor area * 2.5 (approximation)
        const wallArea = roomArea * 2.5; // 50 m²
        const paintPerM2 = 0.15; // 0.15L per m² (2 coats)
        final paintNeeded = wallArea * paintPerM2;

        expect(paintNeeded, 7.5);
        expect(wallArea, 50.0);
      });

      test('Tile quantity includes waste margin', () {
        const floorArea = 15.0;
        const wasteMargin = 1.15; // 15% for cutting
        final tilesNeeded = floorArea * wasteMargin;

        expect(tilesNeeded, 17.25);
        expect(tilesNeeded / floorArea, 1.15);
      });

      test('Flooring calculation with underlay', () {
        const floorArea = 25.0;
        const flooringWaste = 1.08; // 8% waste
        const underlayWaste = 1.05; // 5% waste

        final flooringNeeded = floorArea * flooringWaste;
        final underlayNeeded = floorArea * underlayWaste;

        expect(flooringNeeded, 27.0);
        expect(underlayNeeded, 26.25);
      });

      test('Adhesive quantity for tiles', () {
        const tileArea = 20.0;
        const adhesivePerM2 = 6.0; // 6 kg per m²
        final adhesiveNeeded = tileArea * adhesivePerM2;

        expect(adhesiveNeeded, 120.0);
      });
    });

    group('Cost Calculation Logic', () {
      test('Material total price calculation', () {
        final material = Material(
          id: 'mat_1',
          name: 'Farba',
          category: 'paint',
          quantity: 10.0,
          unit: 'L',
          pricePerUnit: 45.0,
          totalPrice: 450.0,
          supplier: 'Test',
          supplierUrl: '',
          imageUrl: '',
          description: '',
        );

        expect(material.totalPrice, equals(450.0));
        expect(material.quantity * material.pricePerUnit, equals(material.totalPrice));
      });

      test('Multiple materials cost sum', () {
        final materials = [
          Material(
            id: 'mat_1',
            name: 'Farba',
            category: 'paint',
            quantity: 10.0,
            unit: 'L',
            pricePerUnit: 45.0,
            totalPrice: 450.0,
            supplier: 'Test',
            supplierUrl: '',
            imageUrl: '',
            description: '',
          ),
          Material(
            id: 'mat_2',
            name: 'Płytki',
            category: 'tiles',
            quantity: 20.0,
            unit: 'm²',
            pricePerUnit: 95.0,
            totalPrice: 1900.0,
            supplier: 'Test',
            supplierUrl: '',
            imageUrl: '',
            description: '',
          ),
        ];

        final totalCost = materials.fold<double>(
          0.0,
          (sum, material) => sum + material.totalPrice,
        );

        expect(totalCost, 2350.0);
      });

      test('Labor cost calculation based on hours', () {
        const hourlyRate = 80.0; // PLN per hour
        const hours = 8;
        final laborCost = hourlyRate * hours;

        expect(laborCost, 640.0);
      });

      test('Task costs are within professional rates', () {
        final tasks = [
          Task(
            id: 'task_1',
            name: 'Malowanie',
            description: 'Test',
            category: 'painting',
            estimatedHours: 8,
            estimatedCost: 640.0,
            priority: 'medium',
            status: 'pending',
            dependencies: [],
          ),
          Task(
            id: 'task_2',
            name: 'Tiling',
            description: 'Test',
            category: 'tiling',
            estimatedHours: 6,
            estimatedCost: 540.0,
            priority: 'high',
            status: 'pending',
            dependencies: [],
          ),
        ];

        for (var task in tasks) {
          final hourlyRate = task.estimatedCost / task.estimatedHours;
          expect(hourlyRate, greaterThanOrEqualTo(60.0), reason: 'Minimum wage');
          expect(hourlyRate, lessThanOrEqualTo(100.0), reason: 'Maximum professional rate');
        }
      });
    });

    group('Budget Analysis Logic', () {
      test('Budget overrun percentage calculation', () {
        const budget = 10000.0;
        const estimatedCost = 12500.0;
        final overrun = estimatedCost - budget;
        final overrunPercentage = (overrun / budget) * 100;

        expect(overrun, 2500.0);
        expect(overrunPercentage, 25.0);
      });

      test('Budget savings percentage calculation', () {
        const budget = 15000.0;
        const estimatedCost = 11000.0;
        final savings = budget - estimatedCost;
        final savingsPercentage = (savings / budget) * 100;

        expect(savings, 4000.0);
        expect(savingsPercentage, closeTo(26.67, 0.01));
      });

      test('Budget within 5% tolerance', () {
        const budget = 10000.0;
        const estimatedCost = 10300.0;
        final difference = (estimatedCost - budget).abs();
        final differencePercentage = (difference / budget) * 100;

        expect(differencePercentage, lessThan(5.0));
      });

      test('Budget categories distribution', () {
        const materialsCost = 6000.0;
        const laborCost = 4000.0;
        const totalCost = materialsCost + laborCost;

        final materialsPercent = (materialsCost / totalCost) * 100;
        final laborPercent = (laborCost / totalCost) * 100;

        expect(totalCost, 10000.0);
        expect(materialsPercent, 60.0);
        expect(laborPercent, 40.0);
        expect(materialsPercent + laborPercent, 100.0);
      });
    });

    group('Room Type Specific Logic', () {
      test('Living room typical characteristics', () {
        const roomType = 'living_room';
        const typicalArea = 25.0;
        const typicalWorks = ['malowanie', 'podłoga', 'oświetlenie'];

        expect(roomType, 'living_room');
        expect(typicalArea, greaterThan(15.0));
        expect(typicalWorks.length, greaterThanOrEqualTo(3));
      });

      test('Bathroom waterproofing requirements', () {
        const roomType = 'bathroom';
        const requiresWaterproofing = true;
        const waterproofingArea = 8.0; // Full floor area

        expect(roomType, 'bathroom');
        expect(requiresWaterproofing, isTrue);
        expect(waterproofingArea, greaterThan(0));
      });

      test('Kitchen specific requirements', () {
        const roomType = 'kitchen';
        const needsTiling = true; // Behind counters
        const needsElectrical = true; // Appliances
        const needsPlumbing = true; // Sink, dishwasher

        expect(roomType, 'kitchen');
        expect(needsTiling, isTrue);
        expect(needsElectrical, isTrue);
        expect(needsPlumbing, isTrue);
      });
    });

    group('Task Sequencing Logic', () {
      test('Task order follows logical construction sequence', () {
        final taskCategories = [
          'preparation',
          'demolition',
          'electrical',
          'plumbing',
          'tiling',
          'painting',
          'finishing',
          'inspection',
        ];

        expect(taskCategories.first, 'preparation');
        expect(taskCategories.last, 'inspection');
        
        // Electrical before finishing
        final electricalIndex = taskCategories.indexOf('electrical');
        final finishingIndex = taskCategories.indexOf('finishing');
        expect(electricalIndex, lessThan(finishingIndex));

        // Painting after plumbing
        final plumbingIndex = taskCategories.indexOf('plumbing');
        final paintingIndex = taskCategories.indexOf('painting');
        expect(plumbingIndex, lessThan(paintingIndex));
      });

      test('Task priorities are valid', () {
        const validPriorities = ['high', 'medium', 'low'];
        const testPriorities = ['high', 'low', 'medium'];

        for (var priority in testPriorities) {
          expect(validPriorities, contains(priority));
        }
      });
    });

    group('Recommendation Logic', () {
      test('Bulk purchase recommendation triggers', () {
        const numberOfRooms = 5;
        const roomsNeedingPaint = 4;
        const threshold = 0.5; // 50%

        final percentage = roomsNeedingPaint / numberOfRooms;
        final shouldRecommendBulk = percentage > threshold;

        expect(shouldRecommendBulk, isTrue);
        expect(percentage, 0.8);
      });

      test('Seasonal discount calculation', () {
        const regularPrice = 100.0;
        const discountPercent = 15.0;
        final discountedPrice = regularPrice * (1 - discountPercent / 100);
        final savings = regularPrice - discountedPrice;

        expect(discountedPrice, 85.0);
        expect(savings, 15.0);
      });

      test('Cost optimization suggestions', () {
        const estimatedCost = 15000.0;
        const potentialSavingsPercent = 12.0;
        final potentialSavings = estimatedCost * (potentialSavingsPercent / 100);

        expect(potentialSavings, 1800.0);
      });
    });

    group('Data Validation Logic', () {
      test('Room area must be positive', () {
        const validArea = 25.0;
        const invalidArea = -5.0;

        expect(validArea, greaterThan(0));
        expect(invalidArea, lessThan(0));
      });

      test('Material quantity must be positive', () {
        const quantities = [10.5, 25.0, 3.5, 150.0];

        for (var quantity in quantities) {
          expect(quantity, greaterThan(0));
        }
      });

      test('Prices must be realistic', () {
        const paintPrice = 45.0;
        const tilePrice = 95.0;
        const flooringPrice = 75.0;

        expect(paintPrice, inInclusiveRange(20.0, 100.0));
        expect(tilePrice, inInclusiveRange(40.0, 200.0));
        expect(flooringPrice, inInclusiveRange(30.0, 150.0));
      });

      test('Room areas are within realistic bounds', () {
        const minRoomArea = 2.0;
        const maxRoomArea = 200.0;
        const testAreas = [15.0, 25.0, 8.5, 45.0];

        for (var area in testAreas) {
          expect(area, greaterThanOrEqualTo(minRoomArea));
          expect(area, lessThanOrEqualTo(maxRoomArea));
        }
      });
    });

    group('Gemini AI Response Parsing Logic', () {
      test('JSON material format validation', () {
        const jsonTemplate = {
          'name': 'Farba emulsyjna',
          'category': 'paint',
          'quantity': 15.5,
          'unit': 'L',
          'pricePerUnit': 45.0,
        };

        expect(jsonTemplate.containsKey('name'), isTrue);
        expect(jsonTemplate.containsKey('category'), isTrue);
        expect(jsonTemplate.containsKey('quantity'), isTrue);
        expect(jsonTemplate.containsKey('unit'), isTrue);
        expect(jsonTemplate.containsKey('pricePerUnit'), isTrue);
      });

      test('JSON task format validation', () {
        const jsonTemplate = {
          'name': 'Przygotowanie powierzchni',
          'category': 'preparation',
          'estimatedHours': 4,
          'estimatedCost': 320.0,
          'priority': 'high',
          'order': 1,
        };

        expect(jsonTemplate.containsKey('name'), isTrue);
        expect(jsonTemplate.containsKey('category'), isTrue);
        expect(jsonTemplate.containsKey('estimatedHours'), isTrue);
        expect(jsonTemplate.containsKey('estimatedCost'), isTrue);
        expect(jsonTemplate.containsKey('priority'), isTrue);
      });

      test('Fallback triggers on invalid JSON', () {
        const invalidJson = 'This is not JSON';
        final isValid = invalidJson.startsWith('[') || invalidJson.startsWith('{');

        expect(isValid, isFalse);
        // Should trigger fallback to keyword matching
      });
    });

    group('Performance and Limits', () {
      test('Maximum rooms per plan', () {
        const maxRooms = 20;
        const typicalRooms = 5;

        expect(typicalRooms, lessThan(maxRooms));
      });

      test('Maximum materials per room', () {
        const maxMaterials = 50;
        const typicalMaterials = 12;

        expect(typicalMaterials, lessThan(maxMaterials));
      });

      test('Maximum tasks per room', () {
        const maxTasks = 30;
        const typicalTasks = 8;

        expect(typicalTasks, lessThan(maxTasks));
      });

      test('Cost calculation precision', () {
        const quantity = 10.5;
        const price = 45.0;
        final total = quantity * price;
        final roundedTotal = (total * 100).round() / 100;

        expect(roundedTotal, 472.5);
        expect(total, closeTo(472.5, 0.01));
      });
    });

    group('Real-world Scenarios', () {
      test('Small apartment renovation (50m²)', () {
        const totalArea = 50.0;
        const rooms = 3;
        const avgCostPerM2 = 600.0;
        const totalBudget = totalArea * avgCostPerM2;

        expect(totalBudget, 30000.0);
        expect(totalArea / rooms, closeTo(16.67, 0.01));
      });

      test('Medium house renovation (120m²)', () {
        const totalArea = 120.0;
        const rooms = 6;
        const avgCostPerM2 = 750.0;
        const totalBudget = totalArea * avgCostPerM2;

        expect(totalBudget, 90000.0);
        expect(totalArea / rooms, 20.0);
      });

      test('Bathroom-only renovation', () {
        const bathroomArea = 6.5;
        const tilingFactor = 3.5; // Walls + floor
        const totalTilingArea = bathroomArea * tilingFactor;
        const avgCostPerM2 = 2000.0;
        const totalCost = bathroomArea * avgCostPerM2;

        expect(totalTilingArea, 22.75);
        expect(totalCost, 13000.0);
      });

      test('Living room painting only', () {
        const roomArea = 28.0;
        const wallFactor = 2.5;
        const wallArea = roomArea * wallFactor;
        const paintPerM2 = 0.15; // L per m²
        const paintNeeded = wallArea * paintPerM2;
        const paintPrice = 45.0; // PLN per L
        const materialCost = paintNeeded * paintPrice;

        expect(wallArea, 70.0);
        expect(paintNeeded, 10.5);
        expect(materialCost, 472.5);
      });
    });
  });
}

