import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/renovation_plan.dart';

class PdfService {
  /// Generate PDF report from renovation plan
  Future<File> generateRenovationPdf(RenovationPlan plan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(plan),
            pw.SizedBox(height: 20),
            _buildSummary(plan),
            pw.SizedBox(height: 20),
            _buildRoomsSection(plan.rooms),
            pw.SizedBox(height: 20),
            _buildRecommendations(plan.recommendations),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/remont_${plan.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Generate cost estimate PDF
  Future<File> generateCostEstimatePdf(RenovationPlan plan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'KOSZTORYS BUDOWLANY',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              plan.name,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            pw.SizedBox(height: 20),
            _buildDetailedCostTable(plan),
            pw.SizedBox(height: 20),
            _buildCostSummaryTable(plan),
            pw.SizedBox(height: 20),
            _buildPaymentTerms(),
            pw.SizedBox(height: 30),
            _buildSignatureSection(),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/kosztorys_${plan.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Generate invoice PDF
  Future<File> generateInvoicePdf({
    required String invoiceNumber,
    required DateTime issueDate,
    required DateTime dueDate,
    required String sellerName,
    required String sellerAddress,
    required String sellerNip,
    required String buyerName,
    required String buyerAddress,
    required String buyerNip,
    required List<InvoiceItem> items,
    required double vatRate,
  }) async {
    final pdf = pw.Document();

    double netTotal = items.fold(0.0, (sum, item) => sum + item.netAmount);
    double vatAmount = netTotal * (vatRate / 100);
    double grossTotal = netTotal + vatAmount;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FAKTURA VAT',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Nr $invoiceNumber',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Data wystawienia: ${_formatDate(issueDate)}'),
                      pw.Text('Termin płatności: ${_formatDate(dueDate)}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _buildPartyInfo('SPRZEDAWCA', sellerName, sellerAddress, sellerNip),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: _buildPartyInfo('NABYWCA', buyerName, buyerAddress, buyerNip),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              _buildInvoiceTable(items),
              pw.SizedBox(height: 20),

              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 250,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Wartość netto:'),
                          pw.Text('${netTotal.toStringAsFixed(2)} PLN'),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('VAT ($vatRate%):'),
                          pw.Text('${vatAmount.toStringAsFixed(2)} PLN'),
                        ],
                      ),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Wartość brutto:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            '${grossTotal.toStringAsFixed(2)} PLN',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 30),

              pw.Text(
                'Sposób płatności: Przelew bankowy',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Numer konta: XX XXXX XXXX XXXX XXXX XXXX XXXX',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Spacer(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        height: 50,
                        width: 150,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.black),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Podpis sprzedawcy', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        height: 50,
                        width: 150,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.black),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Podpis nabywcy', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/faktura_$invoiceNumber.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Share PDF file
  Future<void> sharePdf(File file, String title) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: title,
    );
  }

  pw.Widget _buildHeader(RenovationPlan plan) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PLAN REMONTU',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          plan.name,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          plan.description,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Data utworzenia: ${_formatDate(plan.createdAt)}'),
            pw.Text('Status: ${_translateStatus(plan.status)}'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSummary(RenovationPlan plan) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Liczba pokoi', '${plan.rooms.length}'),
          _buildSummaryItem('Budżet', '${plan.totalBudget.toStringAsFixed(2)} PLN'),
          _buildSummaryItem('Szacowany koszt', '${plan.estimatedCost.toStringAsFixed(2)} PLN'),
          _buildSummaryItem(
            'Różnica',
            '${(plan.totalBudget - plan.estimatedCost).toStringAsFixed(2)} PLN',
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildRoomsSection(List<Room> rooms) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'POMIESZCZENIA',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        ...rooms.map((room) => _buildRoomSection(room)).toList(),
      ],
    );
  }

  pw.Widget _buildRoomSection(Room room) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                room.name,
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${room.area.toStringAsFixed(2)} m²',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            room.workDescription,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Materiały: ${room.materials.length} poz. | Zadania: ${room.tasks.length} poz.',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Koszt: ${room.estimatedCost.toStringAsFixed(2)} PLN',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildRecommendations(List<Recommendation> recommendations) {
    if (recommendations.isEmpty) return pw.Container();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'REKOMENDACJE AI',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        ...recommendations.take(5).map((rec) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: _getRecommendationColor(rec.type),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  rec.title,
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  rec.description.split('\n').first,
                  style: const pw.TextStyle(fontSize: 10),
                  maxLines: 2,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildDetailedCostTable(RenovationPlan plan) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            _buildTableCell('Pomieszczenie', isHeader: true),
            _buildTableCell('Materiały', isHeader: true),
            _buildTableCell('Robocizna', isHeader: true),
            _buildTableCell('Razem', isHeader: true),
          ],
        ),
        ...plan.rooms.map((room) {
          double materialsTotal = room.materials.fold(0.0, (sum, m) => sum + m.totalPrice);
          double tasksTotal = room.tasks.fold(0.0, (sum, t) => sum + t.estimatedCost);
          return pw.TableRow(
            children: [
              _buildTableCell(room.name),
              _buildTableCell('${materialsTotal.toStringAsFixed(2)} PLN'),
              _buildTableCell('${tasksTotal.toStringAsFixed(2)} PLN'),
              _buildTableCell('${room.estimatedCost.toStringAsFixed(2)} PLN'),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildCostSummaryTable(RenovationPlan plan) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 300,
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          color: PdfColors.grey50,
        ),
        child: pw.Column(
          children: [
            _buildSummaryRow('Budżet planowany:', '${plan.totalBudget.toStringAsFixed(2)} PLN'),
            _buildSummaryRow('Koszt szacowany:', '${plan.estimatedCost.toStringAsFixed(2)} PLN'),
            pw.Divider(),
            _buildSummaryRow(
              'Różnica:',
              '${(plan.totalBudget - plan.estimatedCost).toStringAsFixed(2)} PLN',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentTerms() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'WARUNKI PŁATNOŚCI',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('• Zaliczka: 30% wartości przed rozpoczęciem prac', style: const pw.TextStyle(fontSize: 10)),
        pw.Text('• Etap I: 30% po zakończeniu prac przygotowawczych', style: const pw.TextStyle(fontSize: 10)),
        pw.Text('• Etap II: 30% po zakończeniu prac zasadniczych', style: const pw.TextStyle(fontSize: 10)),
        pw.Text('• Końcowa: 10% po odbiorze końcowym', style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildSignatureSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          children: [
            pw.Container(
              height: 50,
              width: 150,
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide()),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('Podpis Wykonawcy', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          children: [
            pw.Container(
              height: 50,
              width: 150,
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide()),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('Podpis Inwestora', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildPartyInfo(String title, String name, String address, String nip) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(name, style: const pw.TextStyle(fontSize: 11)),
        pw.Text(address, style: const pw.TextStyle(fontSize: 10)),
        pw.Text('NIP: $nip', style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildInvoiceTable(List<InvoiceItem> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            _buildTableCell('Lp.', isHeader: true),
            _buildTableCell('Nazwa', isHeader: true),
            _buildTableCell('Ilość', isHeader: true),
            _buildTableCell('Cena jedn.', isHeader: true),
            _buildTableCell('Wartość', isHeader: true),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          int idx = entry.key;
          InvoiceItem item = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell('${idx + 1}'),
              _buildTableCell(item.name),
              _buildTableCell('${item.quantity} ${item.unit}'),
              _buildTableCell('${item.unitPrice.toStringAsFixed(2)} PLN'),
              _buildTableCell('${item.netAmount.toStringAsFixed(2)} PLN'),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Wygenerowano przez BudApp',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            'Data: ${_formatDate(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'draft':
        return 'Projekt';
      case 'in_progress':
        return 'W trakcie';
      case 'completed':
        return 'Zakończony';
      default:
        return status;
    }
  }

  PdfColor _getRecommendationColor(String type) {
    switch (type) {
      case 'cost_saving':
        return PdfColors.green50;
      case 'quality_improvement':
        return PdfColors.blue50;
      case 'time_saving':
        return PdfColors.orange50;
      default:
        return PdfColors.grey50;
    }
  }
}

/// Invoice item model
class InvoiceItem {
  final String name;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double netAmount;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.netAmount,
  });
}



