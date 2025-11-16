import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'history_manager.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class WorkCalcPage extends StatefulWidget {
  const WorkCalcPage({super.key});

  @override
  State<WorkCalcPage> createState() => _WorkCalcPageState();
}

class _WorkCalcPageState extends State<WorkCalcPage> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  double _result = 0.0;
  double _totalUsage = 0.0;

  Future<void> _calculateWorkCost() async {
    final area = double.tryParse(_areaController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    final usage = double.tryParse(_usageController.text) ?? 0;
    final result = area * price;
    final totalUsage = area * usage;
    setState(() {
      _result = result;
      _totalUsage = totalUsage;
    });
    if (area > 0 && price > 0 && usage > 0) {
      await HistoryManager().addWorkHistory({
        'area': area,
        'price': price,
        'usage': usage,
        'result': result,
        'totalUsage': totalUsage,
        'timestamp': DateTime.now(),
      });
      setState(() {});
    }
  }

  Future<void> _exportHistoryToPDF() async {
    final loc = AppLocalizations.of(context)!;
    final pdf = pw.Document();
    final workHistory = HistoryManager().getWorkHistory();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(loc.workCalculator, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              if (workHistory.isEmpty)
                pw.Text(loc.history + ': ' + loc.noData)
              else
                pw.Table.fromTextArray(
                  headers: [
                    loc.area,
                    loc.price,
                    loc.usage,
                    loc.workCost,
                    loc.materialAmount,
                    'Date'
                  ],
                  data: workHistory.map((entry) => [
                    '${entry['area']} m²',
                    '${entry['price']} PLN/m²',
                    '${entry['usage']}',
                    '${entry['result'].toStringAsFixed(2)} PLN',
                    '${entry['totalUsage'].toStringAsFixed(2)}',
                    (entry['timestamp'] as DateTime).toLocal().toString().split('.')[0],
                  ]).toList(),
                ),
            ],
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/work_calculation_history.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: loc.workCalculator + ' ' + loc.history);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final workHistory = HistoryManager().getWorkHistory();
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.workCalculator),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _areaController,
                      decoration: InputDecoration(
                        labelText: loc.area,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: loc.price,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usageController,
                      decoration: InputDecoration(
                        labelText: loc.usage,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateWorkCost,
                      child: Text(loc.calculateWork),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_result > 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.workCost,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_result.toStringAsFixed(2)} PLN',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.materialAmount,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_totalUsage.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            if (workHistory.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.history,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      tooltip: loc.exportPDF ?? 'Export PDF',
                      onPressed: _exportHistoryToPDF,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: workHistory.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = workHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('${loc.area}: ${entry['area']} m², ${loc.price}: ${entry['price']} PLN/m², ${loc.usage}: ${entry['usage']}'),
                      subtitle: Text('${loc.workCost} ${entry['result'].toStringAsFixed(2)} PLN, ${loc.materialAmount} ${entry['totalUsage'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay),
                            tooltip: loc.useAgain,
                            onPressed: () {
                              setState(() {
                                _areaController.text = entry['area'].toString();
                                _priceController.text = entry['price'].toString();
                                _usageController.text = entry['usage'].toString();
                                _result = entry['result'];
                                _totalUsage = entry['totalUsage'];
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: loc.delete,
                            onPressed: () async {
                              await HistoryManager().removeWorkHistoryItem(index);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    _priceController.dispose();
    _usageController.dispose();
    super.dispose();
  }
}