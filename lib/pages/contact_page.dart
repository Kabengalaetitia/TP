import 'package:flutter/material.dart';

import '../config/app_colors.dart';

/// Page Contact du TP1 (contenu inchangé).
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Widget contactCard(
      IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bleuNuit,
          child: Icon(icon, color: dore),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 20),

        const CircleAvatar(
          radius: 55,
          backgroundColor: bleuNuit,
          child: Icon(
            Icons.contact_mail,
            size: 60,
            color: dore,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'MES COORDONNÉES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: bleuNuit,
          ),
        ),

        const SizedBox(height: 20),

        contactCard(
          Icons.person,
          'Nom complet',
          'WAKUBENGA KABENGA laetitia',
        ),

        contactCard(
          Icons.phone,
          'Téléphone',
          '+243 971 159 317',
        ),

        contactCard(
          Icons.email,
          'Adresse e-mail',
          'kabengalaetitia@gmail.com',
        ),

        contactCard(
          Icons.location_on,
          'Adresse',
          'Goma, Nord-Kivu, Commune de Karisimbi',
        ),

        contactCard(
          Icons.code,
          'GitHub',
          'À compléter avec ton profil GitHub',
        ),

        contactCard(
          Icons.language,
          'Langues',
          'Français, Anglais et Swahili',
        ),

        const SizedBox(height: 20),

        const Text(
          'Merci de visiter mon portfolio !',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: bleuNuit,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
