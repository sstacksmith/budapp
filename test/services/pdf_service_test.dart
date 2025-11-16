import 'package:flutter_test/flutter_test.dart';
import 'package:budapp/services/pdf_service.dart';
import 'package:budapp/models/renovation_plan.dart';
import 'dart:io';

void main() {
  group('PdfService Tests', () {
    late PdfService pdfService;

    setUp(() {
      pdfService = PdfService();
    });

    test('PdfService should be instantiated', () {
      expect(pdfService, isNotNull);
      expect(pdfService, isA<PdfService>());
    });

    test('generateRenovationPdf should create PDF file', () async {
      // Arrange
      final plan = _createTestPlan();

      // Act
      final file = await pdfService.generateRenovationPdf(plan);

      // Assert
      expect(file, isNotNull);
      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.pdf'), isTrue);

      // Cleanup
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('generateCostEstimatePdf should create PDF file', () async {
      // Arrange
      final plan = _createTestPlan();

      // Act
      final file = await pdfService.generateCostEstimatePdf(plan);

      // Assert
      expect(file, isNotNull);
      expect(file.existsSync(), isTrue);
      expect(file.path.contains('kosztorys'), isTrue);

      // Cleanup
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('generateInvoicePdf should create PDF file', () async {
      // Arrange
      final items = [
        InvoiceItem(
          name: 'Test Item',
          quantity: 10,
          unit: 'm²',
          unitPrice: 100,
          netAmount: 1000,
        ),
      ];

      // Act
      final file = await pdfService.generateInvoicePdf(
        invoiceNumber: 'TEST/001',
        issueDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 30)),
        sellerName: 'Test Seller',
        sellerAddress: 'Test Address',
        sellerNip: '1234567890',
        buyerName: 'Test Buyer',
        buyerAddress: 'Buyer Address',
        buyerNip: '0987654321',
        items: items,
        vatRate: 23,
      );

      // Assert
      expect(file, isNotNull);
      expect(file.existsSync(), isTrue);
      expect(file.path.contains('faktura'), isTrue);

      // Cleanup
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}

// Helper function to create test renovation plan
RenovationPlan _createTestPlan() {
  return RenovationPlan(
    id: 'test_${DateTime.now().millisecondsSinceEpoch}',
    userId: 'test_user',
    name: 'Test Renovation Plan',
    description: 'Test description',
    rooms: [
      Room(
        id: 'room1',
        name: 'Test Room',
        area: 20.0,
        type: 'living_room',
        workDescription: 'Test work',
        materials: [
          Material(
            id: 'mat1',
            name: 'Test Material',
            category: 'paint',
            quantity: 10,
            unit: 'L',
            pricePerUnit: 50,
            totalPrice: 500,
            supplier: 'Test Supplier',
            supplierUrl: '',
            imageUrl: '',
            description: 'Test material description',
          ),
        ],
        tasks: [
          Task(
            id: 'task1',
            name: 'Test Task',
            description: 'Test task description',
            category: 'painting',
            estimatedHours: 8,
            estimatedCost: 400,
            priority: 'high',
            status: 'pending',
            dependencies: [],
          ),
        ],
        estimatedCost: 900,
      ),
    ],
    totalBudget: 10000,
    estimatedCost: 900,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'draft',
    materialPrices: [],
    recommendations: [
      Recommendation(
        id: 'rec1',
        type: 'cost_saving',
        title: 'Test Recommendation',
        description: 'Test recommendation description',
        potentialSavings: 100,
        priority: 'medium',
        relatedMaterials: [],
      ),
    ],
  );
}






