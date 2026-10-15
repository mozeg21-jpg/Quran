import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isDarkMode = false;
  int _lastSurahId = 1;
  String _lastSurahName = 'سورة الفاتحة';
  int _lastAyahNumber = 1;
  int _lastPageNumber = 1;

  bool get isDarkMode => _isDarkMode;
  int get lastSurahId => _lastSurahId;
  String get lastSurahName => _lastSurahName;
  int get lastAyahNumber => _lastAyahNumber;
  int get lastPageNumber => _lastPageNumber;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _lastSurahId = _prefs.getInt('lastSurahId') ?? 1;
    _lastSurahName = _prefs.getString('lastSurahName') ?? 'سورة الفاتحة';
    _lastAyahNumber = _prefs.getInt('lastAyahNumber') ?? 1;
    _lastPageNumber = _prefs.getInt('lastPageNumber') ?? 1;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool val) async {
    _isDarkMode = val;
    await _prefs.setBool('isDarkMode', val);
    notifyListeners();
  }

  Future<void> saveLastPosition({
    required int surahId,
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
  }) async {
    _lastSurahId = surahId;
    _lastSurahName = surahName;
    _lastAyahNumber = ayahNumber;
    _lastPageNumber = pageNumber;

    await _prefs.setInt('lastSurahId', surahId);
    await _prefs.setString('lastSurahName', surahName);
    await _prefs.setInt('lastAyahNumber', ayahNumber);
    await _prefs.setInt('lastPageNumber', pageNumber);
    notifyListeners();
  }
}
