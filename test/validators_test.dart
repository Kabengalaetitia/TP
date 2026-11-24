import 'package:flutter_test/flutter_test.dart';
import 'package:laetitia/utils/validators.dart';

void main() {
  group('Validators (mêmes règles que l\'API)', () {
    test('mot de passe : 6 caractères minimum', () {
      expect(Validators.motDePasse('12345'), isNotNull);
      expect(Validators.motDePasse('123456'), isNull);
    });

    test('email invalide refusé', () {
      expect(Validators.email('laetitia'), isNotNull);
      expect(Validators.email('laetitia@exemple.com'), isNull);
    });

    test('nom : obligatoire et 50 caractères maximum', () {
      final v = Validators.obligatoire('nom', 50);
      expect(v(''), isNotNull);
      expect(v('a' * 51), isNotNull);
      expect(v('a' * 50), isNull);
    });

    test('date de naissance au format AAAA-MM-JJ, pas dans le futur', () {
      final auj = DateTime(2026, 11, 24);
      expect(Validators.dateNaissance('12/05/1970', aujourdhui: auj), isNotNull);
      expect(Validators.dateNaissance('1970-02-30', aujourdhui: auj), isNotNull);
      expect(Validators.dateNaissance('2026-11-25', aujourdhui: auj), isNotNull);
      expect(Validators.dateNaissance('2026-11-24', aujourdhui: auj), isNull);
      expect(Validators.dateNaissance('1970-05-12', aujourdhui: auj), isNull);
    });
  });
}
