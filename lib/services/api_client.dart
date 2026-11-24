
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laetitia/config/api_config.dart';

import 'api_exception.dart';

class ApiClient {
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> send(
    Future<http.Response> Function() requete,
  ) async {
    try {
      final reponse = await requete().timeout(ApiConfig.timeout);
      return decode(reponse);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(
        'Le serveur ne répond pas. Vérifie Apache et MySQL dans XAMPP.',
      );
    }
  }

  static Map<String, dynamic> decode(http.Response reponse) {
    final Map<String, dynamic> body;

    try {
      body = jsonDecode(
        utf8.decode(reponse.bodyBytes),
      ) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Réponse inattendue du serveur (code ${reponse.statusCode}).',
        statusCode: reponse.statusCode,
      );
    }

    final ok = reponse.statusCode >= 200 &&
        reponse.statusCode < 300;

    if (ok && body['success'] == true) {
      return body;
    }

    final errors = <String, String>{};
    final brut = body['errors'];

    if (brut is Map) {
      brut.forEach(
        (cle, valeur) => errors[cle.toString()] = valeur.toString(),
      );
    }

    throw ApiException(
      body['message']?.toString() ?? 'Erreur ${reponse.statusCode}',
      statusCode: reponse.statusCode,
      errors: errors,
    );
  }
}
