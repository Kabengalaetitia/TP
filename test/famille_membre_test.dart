import 'package:flutter_test/flutter_test.dart';
import 'package:laetitia/models/famille_membre.dart';

void main() {
  group('FamilleMembre', () {
    test('lit le JSON renvoyé par l\'API', () {
      final m = FamilleMembre.fromJson({
        'id': 3,
        'nom': 'Kabenga',
        'postnom': 'Wakubenga',
        'prenom': 'Ramazani',
        'lieu_naissance': 'Goma',
        'date_naissance': '1970-05-12',
        'image': null,
        'parente': 'Père',
        'image_url': null,
      });
      expect(m.id, 3);
      expect(m.lieuNaissance, 'Goma');
      expect(m.parente, 'Père');
      expect(m.imageUrl, isNull);
    });

    test('accepte un id envoyé sous forme de texte', () {
      final m = FamilleMembre.fromJson({'id': '7', 'nom': 'A'});
      expect(m.id, 7);
    });

    test('envoie les champs avec les noms attendus par l\'API', () {
      const m = FamilleMembre(
        nom: ' Kabenga ',
        postnom: 'Wakubenga',
        prenom: 'Zawadi',
        lieuNaissance: 'Bukavu',
        dateNaissance: '2005-02-14',
        parente: 'Sœur',
      );
      expect(m.toJson(), {
        'nom': 'Kabenga',
        'postnom': 'Wakubenga',
        'prenom': 'Zawadi',
        'lieu_naissance': 'Bukavu',
        'date_naissance': '2005-02-14',
        'parente': 'Sœur',
      });
    });

    test('calcule l\'âge (anniversaire pas encore passé)', () {
      const m = FamilleMembre(
        nom: 'K', postnom: 'W', prenom: 'R',
        lieuNaissance: 'Goma', dateNaissance: '1970-05-12', parente: 'Père',
      );
      expect(m.ageAu(DateTime(2026, 5, 11)), 55);
      expect(m.ageAu(DateTime(2026, 5, 12)), 56);
    });
  });
}
