import 'package:flutter/material.dart';

import '../config/app_colors.dart';

/// Page CV du TP1 (contenu inchangé).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget section(String title, List<String> items, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: dore),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: bleuNuit,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('• $item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: bleuNuit,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: dore,
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: bleuNuit,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'LAETITIA WAKUBENGA KABENGA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'INFORMATICIENNE',
                style: TextStyle(
                  color: dore,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Réseaux, collecte de données et appui humanitaire',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        section('PROFIL', [
          'Étudiante en Informatique, option Réseaux et Télécommunications.',
          'Compétences en outils informatiques, collecte et gestion de données.',
          'Expérience de terrain dans les activités humanitaires.',
          'Organisée, polyvalente et capable de travailler en équipe.',
        ], Icons.person_outline),

        section('INFORMATIONS PERSONNELLES', [
          'Date de naissance : 01/04/2001',
          'Lieu : Goma, Nord-Kivu',
          'Adresse : Commune de Karisimbi',
          'Téléphone : +243 971 159 317',
          'E-mail : kabengalaetitia@gmail.com',
        ], Icons.info_outline),

        section('FORMATION ACADÉMIQUE', [
          'Depuis 2023 : Réseaux et Télécommunications, ISIG/GOMA.',
          '2012 - 2021 : Diplôme d’État, CS Michel Edouard.',
          '2006 - 2012 : Certificat d’études primaires, EP Sainte Famille.',
        ], Icons.school),

        section('FORMATIONS COMPLÉMENTAIRES', [
          '2023 : Formation en anglais, First Level, YIM CENTER.',
          '2024 : Formation en ligne en logistique, UNICEF.',
          '2024 : Master Class en logistique humanitaire, CDI et ASNK.',
          '2025 : Protection contre l’exploitation et les abus sexuels (PSEA), UNICEF.',
        ], Icons.workspace_premium),

        section('EXPÉRIENCES PROFESSIONNELLES', [
          '2021 - 2022 : Enquêtrice, FESCO/ASNK.',
          'Identification et dénombrement des personnes déplacées à Nyiragongo.',
          'Collecte, saisie et transmission des données.',
          'Depuis 2023 : Réceptionniste et comptable, Garage Fikiri.',
          'Tenue de la comptabilité et suivi des paiements.',
          'Depuis 2023 : Marqueteuse et commerçante, GRACIA/Goma.',
        ], Icons.work),

        section('STAGE ACADÉMIQUE', [
          '2026 : MD Engineering SARL, Goma.',
          'Observation des infrastructures GSM, BTS/BBU, fibre optique, Microwave et VSAT.',
          'Participation à une installation de parc informatique.',
        ], Icons.engineering),

        section('COMPÉTENCES INFORMATIQUES', [
          'Microsoft Word',
          'Microsoft Excel',
          'PowerPoint',
          'Internet',
          'KoboCollect',
          'Programmation',
        ], Icons.computer),

        section('COMPÉTENCES PERSONNELLES', [
          'Organisation et rigueur',
          'Esprit d’équipe et communication',
          'Adaptabilité et autonomie',
          'Aptitude au travail de terrain',
          'Polyvalence professionnelle',
        ], Icons.stars),

        section('LANGUES', [
          'Français',
          'Anglais',
          'Swahili',
        ], Icons.language),

        section('RÉFÉRENCE', [
          'SAFARI Joseph',
          'Secrétaire administratif, FESCO/ASNK',
          'Téléphone : +243 977 461 262',
        ], Icons.people),
      ],
    );
  }
}
