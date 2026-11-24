/// Un membre de la famille, tel que stocké dans la table `famille_membre`.
class FamilleMembre {
  final int? id; // null tant que le membre n'est pas encore enregistré
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // format AAAA-MM-JJ, ex. 1970-05-12
  final String parente; // ex. Père, Mère, Frère
  final String? imageUrl; // adresse complète de la photo, ou null

  const FamilleMembre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  /// Transforme le JSON de l'API en objet Dart.
  factory FamilleMembre.fromJson(Map<String, dynamic> json) => FamilleMembre(
        id: json['id'] == null ? null : int.parse(json['id'].toString()),
        nom: (json['nom'] ?? '').toString(),
        postnom: (json['postnom'] ?? '').toString(),
        prenom: (json['prenom'] ?? '').toString(),
        lieuNaissance: (json['lieu_naissance'] ?? '').toString(),
        dateNaissance: (json['date_naissance'] ?? '').toString(),
        parente: (json['parente'] ?? '').toString(),
        imageUrl: json['image_url']?.toString(),
      );

  /// Corps envoyé à l'API (mêmes noms de champs que dans la base de données).
  Map<String, String> toJson() => {
        'nom': nom.trim(),
        'postnom': postnom.trim(),
        'prenom': prenom.trim(),
        'lieu_naissance': lieuNaissance.trim(),
        'date_naissance': dateNaissance,
        'parente': parente.trim(),
      };

  String get nomComplet => '$prenom $nom $postnom';

  /// Initiales affichées quand il n'y a pas de photo.
  String get initiales {
    final p = prenom.isNotEmpty ? prenom[0] : '';
    final n = nom.isNotEmpty ? nom[0] : '';
    return (p + n).toUpperCase();
  }

  /// Âge calculé à partir de la date de naissance (null si date invalide).
  int? ageAu(DateTime aujourdhui) {
    final naissance = DateTime.tryParse(dateNaissance);
    if (naissance == null) return null;
    var age = aujourdhui.year - naissance.year;
    final pasEncoreAnniversaire = aujourdhui.month < naissance.month ||
        (aujourdhui.month == naissance.month && aujourdhui.day < naissance.day);
    if (pasEncoreAnniversaire) age--;
    return age;
  }
}
