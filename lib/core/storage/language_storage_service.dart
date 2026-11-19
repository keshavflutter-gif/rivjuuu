import 'package:shared_preferences/shared_preferences.dart';

class LanguageStorageService {
  static const String _keyLanguageCode = 'selected_language_code';
  static const String _keyHasSelectedLanguage = 'has_selected_language';

  static LanguageStorageService? _instance;
  final SharedPreferences? _prefs;

  LanguageStorageService._internal(this._prefs);

  static void resetForTesting() {
    _instance = null;
  }

  static Future<LanguageStorageService> getInstance({SharedPreferences? prefs}) async {
    if (prefs != null) {
      _instance = LanguageStorageService._internal(prefs);
      return _instance!;
    }
    if (_instance == null) {
      final sp = await SharedPreferences.getInstance();
      _instance = LanguageStorageService._internal(sp);
    }
    return _instance!;
  }

  Future<SharedPreferences> _getPrefs() async {
    final prefs = _prefs;
    if (prefs != null) return prefs;
    return SharedPreferences.getInstance();
  }

  Future<String> getLanguageCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyLanguageCode) ?? 'en';
  }

  Future<bool> saveLanguageCode(String code) async {
    final prefs = await _getPrefs();
    return prefs.setString(_keyLanguageCode, code);
  }

  Future<bool> hasSelectedLanguage() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyHasSelectedLanguage) ?? false;
  }

  Future<bool> setHasSelectedLanguage(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(_keyHasSelectedLanguage, value);
  }
}
