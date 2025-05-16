// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/models/user.dart';
import 'locator.dart';

class SharedPreferencesRepository {
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";

  final loginKey = 'loginKey';

  SharedPreferences? _preferences;

  static final SharedPreferencesRepository _instance =
      SharedPreferencesRepository._internal();

  factory SharedPreferencesRepository() => _instance;

  SharedPreferencesRepository._internal() {
    _preferences = locator<SharedPreferences>();
  }

  dynamic getData({
    required String key,
  }) {
    return _preferences!.get(key);
  }

  Future<bool> savedata({required String key, required dynamic value}) async {
    if (value is bool) {
      return await _preferences!.setBool(key, value);
    }
    if (value is int) {
      return await _preferences!.setInt(key, value);
    }
    if (value is double) {
      return await _preferences!.setDouble(key, value);
    }

    return await _preferences!.setString(key, value);
  }

  void logout() {
    _setPreference(
        prefName: loginKey, prefValue: false, prefType: PREF_TYPE_BOOL);
    _preferences!.remove('"PREF_USER"');
  }

  void setLoggedIn({required bool isLoggedIn}) => _setPreference(
      prefName: loginKey, prefValue: isLoggedIn, prefType: PREF_TYPE_BOOL);

  bool getLoggedIn() {
    if (_preferences!.containsKey(loginKey)) {
      return _preferences!.getBool(loginKey)!;
    } else {
      return false;
    }
  }

  /// Save and Get Logged User Info
  void saveUserInfo({required User user}) {
    String strUser = jsonEncode(user.toJson());
    _setPreference(
        prefName: "PREF_USER", prefValue: strUser, prefType: PREF_TYPE_STRING);
  }

  User getUserInfo() {
    User user =
        User.fromJson(jsonDecode(_preferences!.getString("PREF_USER")!));
    return user;
  }

  Future<void> clear() async {
    _preferences!.clear();
    locator.reset();
    await setupLocator();
  }

  //--------------------------------------------------- Private Preference Methods ----------------------------------------------------

  void _setPreference(
      {required String prefName,
      required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      // prefType is bool
      case PREF_TYPE_BOOL:
        {
          _preferences!.setBool(prefName, prefValue);
          break;
        }
      // prefType is int
      case PREF_TYPE_INTEGER:
        {
          _preferences!.setInt(prefName, prefValue);
          break;
        }
      // prefType is double
      case PREF_TYPE_DOUBLE:
        {
          _preferences!.setDouble(prefName, prefValue);
          break;
        }
      // prefType is String
      case PREF_TYPE_STRING:
        {
          _preferences!.setString(prefName, prefValue);
          break;
        }
    }
  }

  // dynamic _getPreference({@required prefName}) => _preferences.get(prefName);
}
