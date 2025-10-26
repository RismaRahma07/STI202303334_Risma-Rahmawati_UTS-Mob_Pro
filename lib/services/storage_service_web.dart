import 'dart:convert';
import 'dart:html' as html;
import '../models/event.dart';

class StorageService {
  static const _key = 'event_planner_storage';

  /// 🔹 Load dari localStorage browser
  static Future<List<Event>> loadEventsList() async {
    final data = html.window.localStorage[_key];
    if (data == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Event.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// 🔹 Simpan ke localStorage browser
  static Future<void> saveEventsList(List<Event> events) async {
    try {
      final jsonStr = jsonEncode(events.map((e) => e.toJson()).toList());
      html.window.localStorage[_key] = jsonStr;
    } catch (e) {
      print('❌ Gagal simpan localStorage: $e');
    }
  }

  /// 🔹 Ekspor JSON ke file download (Web)
  static Future<String?> exportJsonToFile(
      String filename, String jsonString) async {
    try {
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
      return 'downloaded';
    } catch (e) {
      print('❌ Gagal ekspor web: $e');
      return null;
    }
  }
}
