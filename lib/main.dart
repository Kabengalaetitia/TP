import 'package:material_ui/material_ui.dart';

import 'config/app_colors.dart';
import 'pages/auth_gate.dart';

void main() {
  runApp(const MyCVApp());
}

class MyCVApp extends StatelessWidget {
  const MyCVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Laetitia Kabenga',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fond,
        colorScheme: ColorScheme.fromSeed(seedColor: bleuNuit),
        appBarTheme: const AppBarTheme(
          backgroundColor: bleuNuit,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      // AuthGate choisit : page de connexion, ou application si déjà connecté(e).
      home: const AuthGate(),
    );
  }
}
