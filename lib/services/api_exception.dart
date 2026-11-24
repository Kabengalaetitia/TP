/// Erreur renvoyée par l'API ou par le réseau, avec un message lisible.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  /// Erreurs de validation par champ (code 422), ex. {"nom": "Le champ nom est obligatoire"}.
  final Map<String, String> errors;

  ApiException(this.message, {this.statusCode, this.errors = const {}});

  /// Message complet à afficher à l'utilisateur.
  String get detail => errors.isEmpty ? message : errors.values.join('\n');

  @override
  String toString() => detail;
}
