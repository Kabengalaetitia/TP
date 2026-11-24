import 'package:material_ui/material_ui.dart';

import '../config/app_colors.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import 'main_page.dart';
import 'register_page.dart';

/// Connexion réelle : l'email et le mot de passe sont vérifiés par l'API
/// (POST /accounts/login) dans la table `account` de la base de données.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(
  text: 'laetitia@example.com',
);
  final passwordController = TextEditingController();

  bool obscure = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final user = await AuthService.connecter(
        emailController.text,
        passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage(user: user)),
      );
    } on ApiException catch (e) {
      // 401 = email ou mot de passe incorrect, ou serveur injoignable
      message(e.detail);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openRegister() async {
    final email = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
    if (email != null && mounted) {
      emailController.text = email;
      passwordController.clear();
      message('Compte créé ! Connectez-vous maintenant.');
    }
  }

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bleuNuit, bleu],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: bleuNuit,
                          child: Icon(Icons.person, color: dore, size: 50),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'BIENVENUE',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: bleuNuit,
                          ),
                        ),
                        const Text(
                          'Espace personnel de Laetitia Kabenga',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Adresse e-mail',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Le mot de passe est obligatoire' : null,
                          onFieldSubmitted: (_) => connect(),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bleuNuit,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: loading ? null : connect,
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : const Text(
                                    'SE CONNECTER',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: loading ? null : openRegister,
                          child: const Text(
                            'Créer un nouveau compte',
                            style: TextStyle(color: bleuNuit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
