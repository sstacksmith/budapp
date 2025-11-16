import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'history_manager.dart';

class VolumeMassCalcPage extends StatefulWidget {
  const VolumeMassCalcPage({super.key});

  @override
  State<VolumeMassCalcPage> createState() => _VolumeMassCalcPageState();
}

class _VolumeMassCalcPageState extends State<VolumeMassCalcPage> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _densityController = TextEditingController();
  double? _volume;
  double? _mass;

  Future<void> _calculate() async {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    final density = double.tryParse(_densityController.text) ?? 0;
    final volume = length * width * height;
    final mass = volume * density;
    setState(() {
      _volume = volume;
      _mass = mass;
    });
    if (length > 0 && width > 0 && height > 0 && density > 0) {
      await HistoryManager().addVolumeMassHistory({
        'length': length,
        'width': width,
        'height': height,
        'density': density,
        'volume': volume,
        'mass': mass,
        'timestamp': DateTime.now(),
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final history = HistoryManager().getVolumeMassHistory();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.volumeMassCalculator),
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
                      decoration: InputDecoration(
                        labelText: loc.length,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _widthController,
                      decoration: InputDecoration(
                        labelText: loc.width,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: loc.height,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _densityController,
                      decoration: InputDecoration(
                        labelText: loc.density,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculate,
                      child: Text(loc.calculateVolumeMass),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_volume != null && _mass != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(loc.volume, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('${_volume!.toStringAsFixed(3)} m³', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(loc.mass, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('${_mass!.toStringAsFixed(2)} kg', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (history.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.history,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('${loc.length}: ${entry['length']} m, ${loc.width}: ${entry['width']} m, ${loc.height}: ${entry['height']} m, ${loc.density}: ${entry['density']} kg/m³'),
                      subtitle: Text('${entry['volume'].toStringAsFixed(3)} m³, ${entry['mass'].toStringAsFixed(2)} kg'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: loc.delete,
                        onPressed: () async {
                          await HistoryManager().removeVolumeMassHistoryItem(index);
                          setState(() {});
                        },
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
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _densityController.dispose();
    super.dispose();
  }
} 