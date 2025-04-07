import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> savePreferredTemperature(double temperature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('preferred_temperature', temperature);
  }

  static Future<double?> getPreferredTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('preferred_temperature');
  }
}
