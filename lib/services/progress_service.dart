import 'package:fitto/models/progress_entry.dart';
import 'package:fitto/services/storage_service.dart';

class ProgressService {
  final StorageService _storage = StorageService();
  List<ProgressEntry> _entries = [];

  Future<void> initialize() async {
    await _loadEntries();
    if (_entries.isEmpty) {
      await _createSampleEntries();
    }
  }

  Future<void> _loadEntries() async {
    final list = await _storage.getList(StorageService.progressKey);
    _entries = list.map((json) => ProgressEntry.fromJson(json)).toList();
  }

  Future<void> _createSampleEntries() async {
    final now = DateTime.now();
    _entries = [
      ProgressEntry(id: '1', userId: 'user_1', date: now.subtract(Duration(days: 30)), type: 'weight', value: 78.0, createdAt: now, updatedAt: now),
      ProgressEntry(id: '2', userId: 'user_1', date: now.subtract(Duration(days: 20)), type: 'weight', value: 76.5, createdAt: now, updatedAt: now),
      ProgressEntry(id: '3', userId: 'user_1', date: now.subtract(Duration(days: 10)), type: 'weight', value: 75.8, createdAt: now, updatedAt: now),
      ProgressEntry(id: '4', userId: 'user_1', date: now, type: 'weight', value: 75.0, createdAt: now, updatedAt: now),
      ProgressEntry(id: '5', userId: 'user_1', date: now, type: 'water', value: 6.0, createdAt: now, updatedAt: now),
      ProgressEntry(id: '6', userId: 'user_1', date: now.subtract(Duration(days: 1)), type: 'water', value: 8.0, createdAt: now, updatedAt: now),
      ProgressEntry(id: '7', userId: 'user_1', date: now, type: 'steps', value: 8450.0, createdAt: now, updatedAt: now),
      ProgressEntry(id: '8', userId: 'user_1', date: now.subtract(Duration(days: 1)), type: 'steps', value: 12300.0, createdAt: now, updatedAt: now),
    ];
    await _saveEntries();
  }

  Future<void> _saveEntries() async {
    await _storage.saveList(StorageService.progressKey, _entries.map((e) => e.toJson()).toList());
  }

  List<ProgressEntry> get entries => _entries;

  List<ProgressEntry> getEntriesByType(String type) => _entries.where((e) => e.type == type).toList();

  List<ProgressEntry> getEntriesByTypeAndDateRange(String type, DateTime start, DateTime end) => _entries.where((e) => e.type == type && e.date.isAfter(start.subtract(Duration(days: 1))) && e.date.isBefore(end.add(Duration(days: 1)))).toList();

  ProgressEntry? getLatestEntryByType(String type) {
    final typeEntries = getEntriesByType(type);
    if (typeEntries.isEmpty) return null;
    typeEntries.sort((a, b) => b.date.compareTo(a.date));
    return typeEntries.first;
  }

  Future<void> addEntry(ProgressEntry entry) async {
    _entries.add(entry);
    await _saveEntries();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _saveEntries();
  }
}
