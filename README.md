# 📱 CV Laetitia Kabenga — TP2 Flutter (API REST)

Application mobile Flutter qui présente mon **CV**, ma **famille** et mes **coordonnées**.
Dans ce TP2, la page *Famille* est reliée à une **API REST** et à une **base de données MySQL** :
on peut **ajouter, consulter, modifier et supprimer** les membres de la famille.
La **connexion est réelle** : les comptes sont enregistrés dans la base de données.

> Cours de Développement mobile — ISIG Goma — 2026
> Étudiante : **Laetitia WAKUBENGA KABENGA**



## 🎬 Vidéo de démonstration



https://github.com/user-attachments/assets/db609ebc-70d3-4a8a-89ae-f05e84e46c24





## ✅ Fonctionnalités

| Fonction | Détail | Endpoint de l'API |
|---|---|---|
| Inscription | Création d'un compte (email + mot de passe ≥ 6 caractères) | POST /accounts/register |
| Connexion | Vérification réelle de l'email et du mot de passe | POST /accounts/login |
| Session | L'utilisatrice reste connectée après fermeture de l'application | *(shared_preferences)* |
| Déconnexion | Bouton dans la barre du haut et dans le menu | — |
| Liste de la famille | Chargée depuis la base de données | GET /famille-membres |
| Fiche d'un membre | Détails + âge calculé | GET /famille-membres/{id} |
| Ajout | Formulaire avec photo facultative et calendrier | POST /famille-membres |
| Modification | Avec ou sans changement de photo | PUT ou POST /famille-membres/{id} |
| Suppression | Avec confirmation | DELETE /famille-membres/{id} |

---

## 🛠️ Technologies

- **Flutter / Dart** — application (testée sur Chrome)
- **http** — appels à l'API REST
- **shared_preferences** — mémorisation de la session
- **image_picker** — choix de la photo d'un membre
- **API PHP** : [espoirbaraka/api-test](https://github.com/espoirbaraka/api-test)
- **XAMPP** : Apache + MySQL (MariaDB)

---

## 🗂️ Organisation du code


lib/
├── main.dart                      # Démarrage de l'application et thème
├── config/
│   ├── api_config.dart            # Adresse de l'API
│   └── app_colors.dart            # Couleurs (bleu nuit, doré…)
├── models/
│   ├── user.dart                  # Compte utilisateur
│   └── famille_membre.dart        # Membre de la famille
├── services/
│   ├── api_client.dart            # Envoi des requêtes + gestion des erreurs
│   ├── api_exception.dart         # Erreur lisible pour l'utilisateur
│   ├── auth_service.dart          # Inscription / connexion / déconnexion
│   ├── famille_service.dart       # CRUD des membres de la famille
│   └── session_service.dart       # Session enregistrée sur l'appareil
├── utils/validators.dart          # Règles de validation (identiques à l'API)
├── widgets/membre_avatar.dart     # Photo ronde d'un membre
└── pages/
    ├── auth_gate.dart             # Connexion ou application selon la session
    ├── login_page.dart            # Connexion
    ├── register_page.dart         # Création de compte
    ├── main_page.dart             # Menu + barre de navigation
    ├── home_page.dart             # Mon CV
    ├── contact_page.dart          # Mes contacts
    └── famille/
        ├── family_page.dart       # Liste des membres
        ├── member_detail_page.dart# Fiche d'un membre
     └── member_form_page.dart  # Ajout / modification



## 🚀 Installation et lancement

### 1. API et base de données (XAMPP)

1. Démarrer **Apache** et **MySQL** dans le *XAMPP Control Panel*.
2. Copier l'API dans `C:\xampp\htdocs\api-test` :
   bash
   cd C:\xampp\htdocs
   git clone https://github.com/espoirbaraka/api-test.git
   
3. Ouvrir <http://localhost/phpmyadmin>, créer la base **api** (interclassement utf8mb4_unicode_ci), puis **Importer** le fichier C:\xampp\htdocs\api-test\api.sql.
4. Vérifier que l'API répond : <http://localhost/api-test/public/famille-membres> doit afficher {"success":true,"data":[]}.

### 2. Application Flutter

bash
flutter pub get
flutter run -d chrome --web-port=5000


L'adresse de l'API se règle dans lib/config/api_config.dart
(Chrome : http://localhost/api-test/public).

### 3. Tests

bash
flutter test



## 📸 Captures d'écran

Ajoute tes nouvelles captures dans un dossier "captures" puis décommente les lignes ci-dessous.

| Connexion | Cv | Famille | Contact |
|---|---|---|
| ![Connexion](captures/connexion.png) | ![Cv](captures/cv.png) | ![Famille](captures/famille.png) | ![Contact](captures/contact.png) |



## ⚠️ Limites connues

- L'API ne relie pas les membres de la famille à un compte : tous les comptes voient la même liste.
- L'API ne renvoie pas de jeton (token) : la session est mémorisée sur l'appareil après une connexion réussie.
