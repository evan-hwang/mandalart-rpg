import 'package:shared_preferences/shared_preferences.dart';

/// 앱 설정 저장 서비스
class PreferencesService {
  static const _lastMandalartIdKey = 'last_mandalart_id';

  static PreferencesService? _instance;
  static SharedPreferences? _prefs;

  PreferencesService._();

  static Future<PreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = PreferencesService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// 마지막으로 선택한 만다라트 ID 저장
  Future<void> setLastMandalartId(String id) async {
    await _prefs?.setString(_lastMandalartIdKey, id);
  }

  /// 마지막으로 선택한 만다라트 ID 조회
  String? getLastMandalartId() {
    return _prefs?.getString(_lastMandalartIdKey);
  }

  /// 마지막 만다라트 ID 삭제
  Future<void> clearLastMandalartId() async {
    await _prefs?.remove(_lastMandalartIdKey);
  }
}
