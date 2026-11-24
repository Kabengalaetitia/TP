import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/// Garde l'utilisateur connecté en mémoire sur le téléphone,
/// pour qu'il reste connecté même après avoir fermé l'application.
class SessionService {
  static const _cle = 'utilisateur_connecte';

  static Future<void> sauvegarder(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cle, jsonEncode(user.toJson()));
  }

  static Future<User?> utilisateurActuel() async {
    final prefs = await SharedPreferences.getInstance();
    final texte = prefs.getString(_cle);
    if (texte == null) return null;
    try {
      return User.fromJson(jsonDecode(texte) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(_cle);
      return null;
    }
  }

  static Future<void> effacer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cle);
  }
}
