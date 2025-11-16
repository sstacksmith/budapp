import 'package:flutter/material.dart';
import 'history_manager.dart';

class AreaCalcPage extends StatefulWidget {
  const AreaCalcPage({super.key});

  @override
  State<AreaCalcPage> createState() => _AreaCalcPageState();
}

class _AreaCalcPageState extends State<AreaCalcPage> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  double _result = 0.0;

  Future<void> _calculateArea() async {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    final result = length * width;
    setState(() {
      _result = result;
    });
    if (length > 0 && width > 0) {
      await HistoryManager().addAreaHistory({
        'length': length,
        'width': width,
        'result': result,
        'timestamp': DateTime.now(),
      });
      setState(() {});
    }
  }

  @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final areaHistory = HistoryManager().getAreaHistory();
  return Scaffold(
    appBar: AppBar(
      title: const Text('Kalkulator Powierzchni'),
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
                    controller: _lengthController,
                    decoration: const InputDecoration(
                      labelText: 'Długość (m)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(
                      labelText: 'Szerokość (m)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calculateArea,
                    child: const Text('Oblicz powierzchnię'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Powierzchnia:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_result.toStringAsFixed(2)} m²',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (areaHistory.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historia obliczeń',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: areaHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = areaHistory[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('Długość: ${entry['length']} m, Szerokość: ${entry['width']} m'),
                    subtitle: Text('Wynik: ${entry['result'].toStringAsFixed(2)} m²'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay),
                          tooltip: 'Użyj ponownie',
                          onPressed: () {
                            setState(() {
                              _lengthController.text = entry['length'].toString();
                              _widthController.text = entry['width'].toString();
                              _result = entry['result'];
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Usuń',
                          onPressed: () async {
                            await HistoryManager().removeAreaHistoryItem(index);
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
}