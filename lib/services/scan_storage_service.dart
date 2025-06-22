import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class ScanStorageService {
  static const String _key = 'saved_scans';

  Future<void> saveScan(ScanResult scan) async {
    final prefs = await SharedPreferences.getInstance();
    final scans = await getSavedScans();
    scans.add(scan);
    final scanJsonList = scans.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_key, scanJsonList);
  }

  Future<List<ScanResult>> getSavedScans() async {
    final prefs = await SharedPreferences.getInstance();
    final scanJsonList = prefs.getStringList(_key) ?? [];
    return scanJsonList.map((j) => ScanResult.fromJson(jsonDecode(j))).toList();
  }

  Future<void> clearScans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}