import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';

class StorageService {
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/events.json');
  }

  Future<List<Event>> loadEvents() async {
    try {
      final file = await _getLocalFile();
      if (!file.existsSync()) return [];
      final jsonStr = await file.readAsString();
      final data = jsonDecode(jsonStr) as List;
      return data.map((e) => Event.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveEvents(List<Event> events) async {
    final file = await _getLocalFile();
    final data = events.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> exportToDownloads(List<Event> events) async {
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/events_export.json');
    final data = events.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(data));
  }
}
