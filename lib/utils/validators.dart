/// Règles de validation identiques à celles de l'API,
/// pour prévenir l'utilisateur avant même d'envoyer la requête.
class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? valeur) {
    final v = valeur?.trim() ?? '';
    if (v.isEmpty) return "L'email est obligatoire";
    if (v.length > 100 || !_emailRegex.hasMatch(v)) return "L'email n'est pas valide";
    return null;
  }

  static String? motDePasse(String? valeur) {
    final v = valeur ?? '';
    if (v.isEmpty) return 'Le mot de passe est obligatoire';
    if (v.length < 6) return 'Au moins 6 caractères';
    return null;
  }

  /// Champ texte obligatoire avec une longueur maximum.
  static String? Function(String?) obligatoire(String champ, int max) {
    return (String? valeur) {
      final v = valeur?.trim() ?? '';
      if (v.isEmpty) return 'Le champ $champ est obligatoire';
      if (v.length > max) return '$max caractères maximum';
      return null;
    };
  }

  /// Date au format AAAA-MM-JJ, pas dans le futur.
  static String? dateNaissance(String? valeur, {DateTime? aujourdhui}) {
    final v = valeur?.trim() ?? '';
    if (v.isEmpty) return 'La date de naissance est obligatoire';
    final date = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(v) ? DateTime.tryParse(v) : null;
    if (date == null || formatDate(date) != v) return 'Format attendu : AAAA-MM-JJ';
    final now = aujourdhui ?? DateTime.now();
    if (date.isAfter(DateTime(now.year, now.month, now.day))) {
      return 'La date ne peut pas être dans le futur';
    }
    return null;
  }

  /// Formate une date en AAAA-MM-JJ (format demandé par l'API).
  static String formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
