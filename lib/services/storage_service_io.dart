import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';

class StorageService {
  static const _fileName = 'events_data.json';

  static Future<Directory> _getAppDir() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> _getFile() async {
    final dir = await _getAppDir();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) {
      await file.writeAsString('[]');
    }
    return file;
  }

  /// 🔹 Load semua event dari file
  static Future<List<Event>> loadEventsList() async {
    try {
      final file = await _getFile();
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((e) => Event.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// 🔹 Simpan semua event ke file
  static Future<void> saveEventsList(List<Event> events) async {
    try {
      final file = await _getFile();
      final jsonStr = jsonEncode(events.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonStr);
    } catch (e) {
      print('❌ Gagal menyimpan data: $e');
    }
  }

  /// 🔹 Ekspor file JSON ke dokumen pengguna
  static Future<String?> exportJsonToFile(
      String filename, String jsonString) async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(jsonString);
      return file.path;
    } catch (e) {
      print('❌ Gagal ekspor: $e');
      return null;
    }
  }
}
