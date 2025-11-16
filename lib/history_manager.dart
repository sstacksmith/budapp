import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HistoryManager {
  static final HistoryManager _instance = HistoryManager._internal();
  factory HistoryManager() => _instance;
  HistoryManager._internal();

  static const int maxHistoryItems = 10;

  static const String _areaKey = 'history_area';
  static const String _workKey = 'history_work';
  static const String _materialKey = 'history_material';
  static const String _dimensionsKey = 'history_dimensions';
  static const String _volumeMassKey = 'history_volume_mass';
  static const String _vatTaxKey = 'history_vat_tax';

  final List<Map<String, dynamic>> _areaHistory = [];
  final List<Map<String, dynamic>> _workHistory = [];
  final List<Map<String, dynamic>> _materialHistory = [];
  final List<Map<String, dynamic>> _dimensionsHistory = [];
  final List<Map<String, dynamic>> _volumeMassHistory = [];
  final List<Map<String, dynamic>> _vatTaxHistory = [];

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();

    _areaHistory.addAll(_loadHistory(_areaKey));
    _workHistory.addAll(_loadHistory(_workKey));
    _materialHistory.addAll(_loadHistory(_materialKey));
    _dimensionsHistory.addAll(_loadHistory(_dimensionsKey));
    _volumeMassHistory.addAll(_loadHistory(_volumeMassKey));
    _vatTaxHistory.addAll(_loadHistory(_vatTaxKey));

    _isInitialized = true;
  }

  List<Map<String, dynamic>> _loadHistory(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded.map((item) {
        final Map<String, dynamic> map =
            Map<String, dynamic>.from(item as Map<String, dynamic>);
        if (map.containsKey('timestamp') && map['timestamp'] is String) {
          final parsed = DateTime.tryParse(map['timestamp'] as String);
          if (parsed != null) {
            map['timestamp'] = parsed;
          }
        }
        return map;
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveHistory(String key, List<Map<String, dynamic>> data) async {
    final serializable = data
        .map((entry) => entry.map((key, value) {
              if (value is DateTime) {
                return MapEntry(key, value.toIso8601String());
              }
              return MapEntry(key, value);
            }))
        .toList();
    await _prefs?.setString(key, jsonEncode(serializable));
  }

  Future<void> addAreaHistory(Map<String, dynamic> entry) async {
    _areaHistory.insert(0, entry);
    if (_areaHistory.length > maxHistoryItems) {
      _areaHistory.removeLast();
    }
    await _saveHistory(_areaKey, _areaHistory);
  }

  Future<void> addWorkHistory(Map<String, dynamic> entry) async {
    _workHistory.insert(0, entry);
    if (_workHistory.length > maxHistoryItems) {
      _workHistory.removeLast();
    }
    await _saveHistory(_workKey, _workHistory);
  }

  Future<void> addMaterialHistory(Map<String, dynamic> entry) async {
    _materialHistory.insert(0, entry);
    if (_materialHistory.length > maxHistoryItems) {
      _materialHistory.removeLast();
    }
    await _saveHistory(_materialKey, _materialHistory);
  }

  Future<void> addDimensionsHistory(Map<String, dynamic> entry) async {
    _dimensionsHistory.insert(0, entry);
    if (_dimensionsHistory.length > maxHistoryItems) {
      _dimensionsHistory.removeLast();
    }
    await _saveHistory(_dimensionsKey, _dimensionsHistory);
  }

  Future<void> addVolumeMassHistory(Map<String, dynamic> entry) async {
    _volumeMassHistory.insert(0, entry);
    if (_volumeMassHistory.length > maxHistoryItems) {
      _volumeMassHistory.removeLast();
    }
    await _saveHistory(_volumeMassKey, _volumeMassHistory);
  }

  Future<void> addVatTaxHistory(Map<String, dynamic> entry) async {
    _vatTaxHistory.insert(0, entry);
    if (_vatTaxHistory.length > maxHistoryItems) {
      _vatTaxHistory.removeLast();
    }
    await _saveHistory(_vatTaxKey, _vatTaxHistory);
  }

  List<Map<String, dynamic>> getAreaHistory() => List.from(_areaHistory);
  List<Map<String, dynamic>> getWorkHistory() => List.from(_workHistory);
  List<Map<String, dynamic>> getMaterialHistory() => List.from(_materialHistory);
  List<Map<String, dynamic>> getDimensionsHistory() =>
      List.from(_dimensionsHistory);
  List<Map<String, dynamic>> getVolumeMassHistory() =>
      List.from(_volumeMassHistory);
  List<Map<String, dynamic>> getVatTaxHistory() => List.from(_vatTaxHistory);

  Future<void> clearAreaHistory() async {
    _areaHistory.clear();
    await _saveHistory(_areaKey, _areaHistory);
  }

  Future<void> clearWorkHistory() async {
    _workHistory.clear();
    await _saveHistory(_workKey, _workHistory);
  }

  Future<void> clearMaterialHistory() async {
    _materialHistory.clear();
    await _saveHistory(_materialKey, _materialHistory);
  }

  Future<void> clearDimensionsHistory() async {
    _dimensionsHistory.clear();
    await _saveHistory(_dimensionsKey, _dimensionsHistory);
  }

  Future<void> clearVolumeMassHistory() async {
    _volumeMassHistory.clear();
    await _saveHistory(_volumeMassKey, _volumeMassHistory);
  }

  Future<void> clearVatTaxHistory() async {
    _vatTaxHistory.clear();
    await _saveHistory(_vatTaxKey, _vatTaxHistory);
  }

  Future<void> removeAreaHistoryItem(int index) async {
    if (index >= 0 && index < _areaHistory.length) {
      _areaHistory.removeAt(index);
      await _saveHistory(_areaKey, _areaHistory);
    }
  }

  Future<void> removeWorkHistoryItem(int index) async {
    if (index >= 0 && index < _workHistory.length) {
      _workHistory.removeAt(index);
      await _saveHistory(_workKey, _workHistory);
    }
  }

  Future<void> removeMaterialHistoryItem(int index) async {
    if (index >= 0 && index < _materialHistory.length) {
      _materialHistory.removeAt(index);
      await _saveHistory(_materialKey, _materialHistory);
    }
  }

  Future<void> removeDimensionsHistoryItem(int index) async {
    if (index >= 0 && index < _dimensionsHistory.length) {
      _dimensionsHistory.removeAt(index);
      await _saveHistory(_dimensionsKey, _dimensionsHistory);
    }
  }

  Future<void> removeVolumeMassHistoryItem(int index) async {
    if (index >= 0 && index < _volumeMassHistory.length) {
      _volumeMassHistory.removeAt(index);
      await _saveHistory(_volumeMassKey, _volumeMassHistory);
    }
  }

  Future<void> removeVatTaxHistoryItem(int index) async {
    if (index >= 0 && index < _vatTaxHistory.length) {
      _vatTaxHistory.removeAt(index);
      await _saveHistory(_vatTaxKey, _vatTaxHistory);
    }
  }
}