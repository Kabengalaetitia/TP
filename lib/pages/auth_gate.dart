import 'package:material_ui/material_ui.dart';

import '../models/user.dart';
import '../services/session_service.dart';
import 'login_page.dart';
import 'main_page.dart';

/// Premier écran : si un compte est déjà connecté, on ouvre l'application,
/// sinon on affiche la page de connexion.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: SessionService.utilisateurActuel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        return user == null ? const LoginPage() : MainPage(user: user);
      },
    );
  }
}
