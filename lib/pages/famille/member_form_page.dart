import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/app_colors.dart';
import '../../models/famille_membre.dart';
import '../../services/api_exception.dart';
import '../../services/famille_service.dart';
import '../../utils/validators.dart';
import '../../widgets/membre_avatar.dart';

/// Formulaire d'ajout (member == null) ou de modification d'un membre.
/// Renvoie `true` si l'enregistrement a réussi.
class MemberFormPage extends StatefulWidget {
  final FamilleMembre? member;

  const MemberFormPage({super.key, this.member});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  static const liens = [
    'Père', 'Mère', 'Frère', 'Sœur', 'Fils', 'Fille', 'Époux', 'Épouse',
    'Grand-père', 'Grand-mère', 'Oncle', 'Tante', 'Cousin', 'Cousine',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nom;
  late final TextEditingController postnom;
  late final TextEditingController prenom;
  late final TextEditingController lieu;
  late final TextEditingController date;
  late final TextEditingController parente;

  XFile? photo; // nouvelle photo choisie (facultatif)
  Uint8List? preview; // aperçu de la photo (fonctionne aussi sur Chrome)
  bool saving = false;
  Map<String, String> serverErrors = {}; // erreurs 422 renvoyées par l'API

  bool get isEdit => widget.member != null;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    nom = TextEditingController(text: m?.nom);
    postnom = TextEditingController(text: m?.postnom);
    prenom = TextEditingController(text: m?.prenom);
    lieu = TextEditingController(text: m?.lieuNaissance ?? 'Goma');
    date = TextEditingController(text: m?.dateNaissance);
    parente = TextEditingController(text: m?.parente);
  }

  @override
  void dispose() {
    for (final c in [nom, postnom, prenom, lieu, date, parente]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> pickPhoto() async {
    // Image réduite pour respecter la limite de 2 Mo de l'API.
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      photo = picked;
      preview = bytes;
    });
  }

  Future<void> pickDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(date.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // pas de date dans le futur
      helpText: 'Date de naissance',
    );
    if (chosen != null) date.text = Validators.formatDate(chosen);
  }

  Future<void> save() async {
    setState(() => serverErrors = {});
    if (!_formKey.currentState!.validate()) return;

    final member = FamilleMembre(
      id: widget.member?.id,
      nom: nom.text,
      postnom: postnom.text,
      prenom: prenom.text,
      lieuNaissance: lieu.text,
      dateNaissance: date.text.trim(),
      parente: parente.text,
    );

    setState(() => saving = true);
    try {
      if (isEdit) {
        await FamilleService.modifier(member, photo: photo);
      } else {
        await FamilleService.creer(member, photo: photo);
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => serverErrors = e.errors);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.detail)));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Widget field(TextEditingController c, String label, String apiKey, int max, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLength: max,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          errorText: serverErrors[apiKey],
          counterText: '',
        ),
        validator: Validators.obligatoire(label.toLowerCase(), max),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Modifier un membre' : 'Ajouter un membre')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Stack(
                children: [
                  preview != null
                      ? CircleAvatar(radius: 55, backgroundImage: MemoryImage(preview!))
                      : m != null
                          ? MembreAvatar(membre: m, rayon: 55)
                          : const CircleAvatar(
                              radius: 55,
                              backgroundColor: bleuNuit,
                              child: Icon(Icons.person, size: 55, color: dore),
                            ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: dore),
                      tooltip: 'Choisir une photo',
                      onPressed: saving ? null : pickPhoto,
                      icon: const Icon(Icons.photo_camera, color: bleuNuit),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              serverErrors['image'] ?? 'Photo facultative (jpg, png, gif, webp — 2 Mo max)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: serverErrors['image'] != null ? Colors.red : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            field(nom, 'Nom', 'nom', 50, Icons.badge),
            field(postnom, 'Postnom', 'postnom', 50, Icons.badge_outlined),
            field(prenom, 'Prénom', 'prenom', 50, Icons.person),
            field(lieu, 'Lieu de naissance', 'lieu_naissance', 100, Icons.location_on),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: date,
                readOnly: true,
                onTap: pickDate,
                decoration: InputDecoration(
                  labelText: 'Date de naissance',
                  hintText: 'AAAA-MM-JJ',
                  prefixIcon: const Icon(Icons.cake),
                  suffixIcon: const Icon(Icons.calendar_month),
                  errorText: serverErrors['date_naissance'],
                ),
                validator: (v) => Validators.dateNaissance(v),
              ),
            ),
            TextFormField(
              controller: parente,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Lien de parenté',
                hintText: 'Père, Mère, Frère...',
                prefixIcon: const Icon(Icons.favorite),
                errorText: serverErrors['parente'],
                counterText: '',
                suffixIcon: PopupMenuButton<String>(
                  tooltip: 'Choisir',
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (v) => parente.text = v,
                  itemBuilder: (_) => [for (final l in liens) PopupMenuItem(value: l, child: Text(l))],
                ),
              ),
              validator: Validators.obligatoire('lien de parenté', 50),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bleuNuit,
                  foregroundColor: Colors.white,
                ),
                onPressed: saving ? null : save,
                icon: saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(isEdit ? 'ENREGISTRER LES MODIFICATIONS' : 'ENREGISTRER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
