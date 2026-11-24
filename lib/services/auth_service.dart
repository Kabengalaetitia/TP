import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laetitia/config/api_config.dart'; // Adaptez le dossier si différent
import '../models/user.dart';
import 'api_client.dart';
import 'session_service.dart';

/// Inscription, connexion et déconnexion via l'API.
class AuthService {
  /// POST /accounts/register -> crée le compte dans la table `account`.
  static Future<User> inscrire(String email, String motDePasse) async {
    final body = await ApiClient.send(() => http.post(
          ApiConfig.uri('/accounts/register'),
          headers: ApiClient.jsonHeaders,
          body: jsonEncode({'email': email.trim(), 'password': motDePasse}),
        ));
    return User.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// POST /accounts/login -> vérifie l'email et le mot de passe dans la base.
  /// En cas de succès, l'utilisateur est mémorisé sur le téléphone.
  static Future<User> connecter(String email, String motDePasse) async {
    final body = await ApiClient.send(() => http.post(
          ApiConfig.uri('/accounts/login'),
          headers: ApiClient.jsonHeaders,
          body: jsonEncode({'email': email.trim(), 'password': motDePasse}),
        ));
    final user = User.fromJson(body['data'] as Map<String, dynamic>);
    await SessionService.sauvegarder(user);
    return user;
  }

  static Future<void> deconnecter() => SessionService.effacer();
}
