import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'contact_page.dart';
import 'famille/family_page.dart';
import 'home_page.dart';
import 'login_page.dart';

/// Navigation principale (menu latéral + barre du bas), comme au TP1.
class MainPage extends StatefulWidget {
  final User user; // compte connecté

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    FamilyPage(),
    ContactPage(),
  ];

  final titles = const [
    'Mon CV',
    'Ma famille',
    'Mes contacts',
  ];

  void select(int index) => setState(() => selectedIndex = index);

  Future<void> logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Se déconnecter')),
        ],
      ),
    );
    if (confirmed != true) return;

    await AuthService.deconnecter();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget menuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedIndex == index,
      onTap: () {
        select(index);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: bleuNuit),
              accountName: const Text('Laetitia WAKUBENGA KABENGA'),
              accountEmail: Text(widget.user.email), // email du compte connecté
              currentAccountPicture: const CircleAvatar(
                backgroundColor: dore,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            menuItem(Icons.home, 'Accueil / Mon CV', 0),
            menuItem(Icons.family_restroom, 'Ma famille', 1),
            menuItem(Icons.contact_mail, 'Mes contacts', 2),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
          ],
        ),
      ),
      // IndexedStack garde chaque page en mémoire quand on change d'onglet.
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: select,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Mon CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(icon: Icon(Icons.contact_phone), label: 'Contact'),
        ],
      ),
    );
  }
}
