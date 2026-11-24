import 'package:material_ui/material_ui.dart';

import '../../config/app_colors.dart';
import '../../models/famille_membre.dart';
import '../../services/api_exception.dart';
import '../../services/famille_service.dart';
import '../../widgets/membre_avatar.dart';
import 'family_page.dart' show confirmDelete;
import 'member_form_page.dart';

/// Fiche d'un membre : GET /famille-membres/{id}.
/// Renvoie `true` si le membre a été modifié ou supprimé.
class MemberDetailPage extends StatefulWidget {
  final int memberId;

  const MemberDetailPage({super.key, required this.memberId});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  FamilleMembre? member;
  String? error;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final m = await FamilleService.afficher(widget.memberId);
      if (mounted) setState(() => member = m);
    } on ApiException catch (e) {
      if (mounted) setState(() => error = e.detail);
    }
  }

  Future<void> edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemberFormPage(member: member)),
    );
    if (saved == true) {
      changed = true;
      load();
    }
  }

  Future<void> delete() async {
    final m = member!;
    if (!await confirmDelete(context, m)) return;
    try {
      await FamilleService.supprimer(m.id!);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.detail)));
    }
  }

  Widget line(IconData icon, String title, String value) => Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: bleuNuit, child: Icon(icon, color: dore)),
          title: Text(title),
          subtitle: Text(value),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final m = member;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, changed);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fiche du membre'),
          actions: m == null
              ? null
              : [
                  IconButton(tooltip: 'Modifier', icon: const Icon(Icons.edit), onPressed: edit),
                  IconButton(tooltip: 'Supprimer', icon: const Icon(Icons.delete), onPressed: delete),
                ],
        ),
        body: error != null
            ? Center(child: Text(error!, textAlign: TextAlign.center))
            : m == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(18),
                    children: [
                      const SizedBox(height: 10),
                      Center(child: MembreAvatar(membre: m, rayon: 60)),
                      const SizedBox(height: 15),
                      Text(
                        m.nomComplet.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: bleuNuit,
                        ),
                      ),
                      Text(
                        m.parente,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: dore, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      line(Icons.badge, 'Nom', m.nom),
                      line(Icons.badge_outlined, 'Postnom', m.postnom),
                      line(Icons.person, 'Prénom', m.prenom),
                      line(Icons.location_on, 'Lieu de naissance', m.lieuNaissance),
                      line(Icons.cake, 'Date de naissance', () {
                        final age = m.ageAu(DateTime.now());
                        return age == null ? m.dateNaissance : '${m.dateNaissance} ($age ans)';
                      }()),
                    ],
                  ),
      ),
    );
  }
}
