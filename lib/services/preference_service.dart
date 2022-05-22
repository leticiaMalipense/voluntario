import 'package:queroservoluntario/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static final USER_ID = 'userId';
  static final USER_NAME = 'userName';
  static final USER_DOCUMENT = 'userDocument';
  static final USER_PROFILE = 'userProfile';
  static final USER_TOKEN = 'userToken';
  static final USER_CITY = 'userCity';
  static final USER_STATE = 'userState';

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  void savePreference(TokenModel token) {
    _prefsInstance.setString(USER_ID, token.id.toString());
    _prefsInstance.setString(USER_NAME, token.name);
    _prefsInstance.setString(USER_DOCUMENT, token.document);
    _prefsInstance.setString(USER_PROFILE, token.type);
    _prefsInstance.setString(USER_TOKEN, token.token);
  }

  Set<String> getAllPreference() {
    return _prefsInstance.getKeys();
  }

  String getPreferenceByKey(String key) {
    return _prefsInstance.getString(key) ?? "";
  }

  void removeAllPreference() {
    _prefsInstance.clear();
  }
}
