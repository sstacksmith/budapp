import 'package:flutter/material.dart';
import 'history_manager.dart';

class MaterialCalcPage extends StatefulWidget {
  const MaterialCalcPage({super.key});

  @override
  State<MaterialCalcPage> createState() => _MaterialCalcPageState();
}

class _MaterialCalcPageState extends State<MaterialCalcPage> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  double? _result;

  Future<void> _calculateMaterial() async {
    final area = double.tryParse(_areaController.text) ?? 0;
    final usage = double.tryParse(_usageController.text) ?? 0;
    final result = area * usage;
    setState(() {
      _result = result;
    });
    if (area > 0 && usage > 0) {
      await HistoryManager().addMaterialHistory({
        'area': area,
        'usage': usage,
        'result': result,
        'timestamp': DateTime.now(),
      });
      setState(() {});
    }
  }

  @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final materialHistory = HistoryManager().getMaterialHistory();
  return Scaffold(
    appBar: AppBar(
      title: const Text('Kalkulator Materiałów'),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 0,
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary.withOpacity(0.1), colorScheme.secondary.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(Icons.construction, size: 48, color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Oblicz ilość materiału',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _areaController,
                          decoration: InputDecoration(
                            labelText: 'Powierzchnia (m²)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.square_foot),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _usageController,
                          decoration: InputDecoration(
                            labelText: 'Zużycie na m²',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.format_list_numbered),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _calculateMaterial,
                            icon: const Icon(Icons.calculate),
                            label: const Text('Oblicz'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _result != null
                      ? Card(
                          key: ValueKey(_result),
                          color: colorScheme.primaryContainer,
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Potrzebna ilość materiału:',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${_result!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),
                if (materialHistory.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historia obliczeń',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: materialHistory.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = materialHistory[index];
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text('Powierzchnia: ${entry['area']} m², Zużycie: ${entry['usage']} na m²'),
                        subtitle: Text('Wynik: ${entry['result'].toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay),
                              tooltip: 'Użyj ponownie',
                              onPressed: () {
                                setState(() {
                                  _areaController.text = entry['area'].toString();
                                  _usageController.text = entry['usage'].toString();
                                  _result = entry['result'];
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Usuń',
                              onPressed: () async {
                                await HistoryManager().removeMaterialHistoryItem(index);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  @override
  void dispose() {
    _areaController.dispose();
    _usageController.dispose();
    super.dispose();
  }
}