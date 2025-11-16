import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'history_manager.dart';

class VatTaxCalcPage extends StatefulWidget {
  const VatTaxCalcPage({super.key});

  @override
  State<VatTaxCalcPage> createState() => _VatTaxCalcPageState();
}

class _VatTaxCalcPageState extends State<VatTaxCalcPage> {
  final TextEditingController _netController = TextEditingController();
  final TextEditingController _customVatController = TextEditingController();
  final TextEditingController _customTaxController = TextEditingController();
  double _vatRate = 0.23;
  double _taxRate = 0.19;
  bool _taxOnGross = false;
  double? _vatAmount;
  double? _grossAmount;
  double? _taxAmount;
  double? _totalAfterTax;

  final List<double> vatRates = [0.23, 0.08, 0.05, 0.0];
  final List<double> taxRates = [0.17, 0.19];

  Future<void> _calculate() async {
    final net = double.tryParse(_netController.text) ?? 0;
    final vat = _vatRate == -1 ? (double.tryParse(_customVatController.text) ?? 0) / 100 : _vatRate;
    final tax = _taxRate == -1 ? (double.tryParse(_customTaxController.text) ?? 0) / 100 : _taxRate;
    final vatAmount = net * vat;
    final gross = net + vatAmount;
    final taxBase = _taxOnGross ? gross : net;
    final taxAmount = taxBase * tax;
    final total = gross - taxAmount;
    setState(() {
      _vatAmount = vatAmount;
      _grossAmount = gross;
      _taxAmount = taxAmount;
      _totalAfterTax = total;
    });
    if (net > 0) {
      await HistoryManager().addVatTaxHistory({
        'net': net,
        'vatRate': vat,
        'taxRate': tax,
        'taxOnGross': _taxOnGross,
        'vatAmount': vatAmount,
        'gross': gross,
        'taxAmount': taxAmount,
        'total': total,
        'timestamp': DateTime.now(),
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final vatTaxHistory = HistoryManager().getVatTaxHistory();
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.vatTaxCalculator ?? 'VAT & Tax Calculator'),
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
                      controller: _netController,
                      decoration: InputDecoration(
                        labelText: loc.netAmount ?? 'Net amount (PLN)',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<double>(
                            value: vatRates.contains(_vatRate) ? _vatRate : -1,
                            items: [
                              ...vatRates.map((rate) => DropdownMenuItem(
                                value: rate,
                                child: Text('${(rate * 100).toStringAsFixed(0)}%'),
                              )),
                              const DropdownMenuItem(
                                value: -1.0,
                                child: Text('Custom'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _vatRate = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: loc.vatRate ?? 'VAT rate',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        if (_vatRate == -1)
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _customVatController,
                              decoration: const InputDecoration(
                                labelText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<double>(
                            value: taxRates.contains(_taxRate) ? _taxRate : -1,
                            items: [
                              ...taxRates.map((rate) => DropdownMenuItem(
                                value: rate,
                                child: Text('${(rate * 100).toStringAsFixed(0)}%'),
                              )),
                              const DropdownMenuItem(
                                value: -1.0,
                                child: Text('Custom'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _taxRate = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: loc.taxRate ?? 'Tax rate',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        if (_taxRate == -1)
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _customTaxController,
                              decoration: const InputDecoration(
                                labelText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _taxOnGross,
                          onChanged: (val) {
                            setState(() {
                              _taxOnGross = val!;
                            });
                          },
                        ),
                        Text(loc.taxOnGross ?? 'Tax on gross amount'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculate,
                      child: Text(loc.calculate ?? 'Calculate'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_vatAmount != null && _grossAmount != null && _taxAmount != null && _totalAfterTax != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${loc.vatAmount ?? 'VAT amount'}: ${_vatAmount!.toStringAsFixed(2)} PLN', style: const TextStyle(fontSize: 14)),
                      Text('${loc.grossAmount ?? 'Gross amount'}: ${_grossAmount!.toStringAsFixed(2)} PLN', style: const TextStyle(fontSize: 14)),
                      Text('${loc.taxAmount ?? 'Tax amount'}: ${_taxAmount!.toStringAsFixed(2)} PLN', style: const TextStyle(fontSize: 14)),
                      Text('${loc.totalAfterTax ?? 'Total after tax'}: ${_totalAfterTax!.toStringAsFixed(2)} PLN', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (vatTaxHistory.isNotEmpty) ...[
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
                  itemCount: vatTaxHistory.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = vatTaxHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('${loc.netAmount ?? 'Net'}: ${entry['net']} PLN, ${loc.vatRate ?? 'VAT'}: ${(entry['vatRate'] * 100).toStringAsFixed(0)}%, ${loc.taxRate ?? 'Tax'}: ${(entry['taxRate'] * 100).toStringAsFixed(0)}%'),
                      subtitle: Text('${loc.grossAmount ?? 'Gross'}: ${entry['gross'].toStringAsFixed(2)} PLN, ${loc.taxAmount ?? 'Tax'}: ${entry['taxAmount'].toStringAsFixed(2)} PLN, ${loc.totalAfterTax ?? 'Total'}: ${entry['total'].toStringAsFixed(2)} PLN'),
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
    _netController.dispose();
    _customVatController.dispose();
    _customTaxController.dispose();
    super.dispose();
  }
} 