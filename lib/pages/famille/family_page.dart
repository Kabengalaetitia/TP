import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../models/famille_membre.dart';
import '../../services/api_exception.dart';
import '../../services/famille_service.dart';
import '../../widgets/membre_avatar.dart';
import 'member_detail_page.dart';
import 'member_form_page.dart';

/// Page Famille : CRUD complet via l'API REST.
///   READ   -> GET    /famille-membres
///   CREATE -> POST   /famille-membres          (page MemberFormPage)
///   UPDATE -> PUT    /famille-membres/{id}     (ou POST si nouvelle photo)
///   DELETE -> DELETE /famille-membres/{id}
class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<FamilleMembre> members = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadFamily();
  }

  Future<void> loadFamily() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final result = await FamilleService.lister();
      if (!mounted) return;
      setState(() => members = result);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => error = e.detail);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> openForm({FamilleMembre? member}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemberFormPage(member: member)),
    );
    if (saved == true) {
      showMessage(member == null ? 'Membre ajouté' : 'Membre modifié');
      loadFamily();
    }
  }

  Future<void> openDetail(FamilleMembre member) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemberDetailPage(memberId: member.id!)),
    );
    if (changed == true) loadFamily();
  }

  Future<void> removeMember(FamilleMembre member) async {
    if (!await confirmDelete(context, member)) return;
    try {
      await FamilleService.supprimer(member.id!);
      showMessage('Membre supprimé');
      loadFamily();
    } on ApiException catch (e) {
      showMessage(e.detail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: bleuNuit,
        foregroundColor: Colors.white,
        onPressed: () => openForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(onRefresh: loadFamily, child: content()),
    );
  }

  Widget content() {
    if (loading && members.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return ListView(
        padding: const EdgeInsets.all(30),
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.cloud_off, size: 70, color: bleu),
          const SizedBox(height: 15),
          Text(error!, textAlign: TextAlign.center),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton.icon(
              onPressed: loadFamily,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ),
        ],
      );
    }
    if (members.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 150),
          Icon(Icons.family_restroom, size: 80, color: bleu),
          SizedBox(height: 10),
          Center(child: Text('Aucun membre enregistré')),
          Center(child: Text('Appuyez sur « Ajouter » pour commencer.')),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final m = members[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: MembreAvatar(membre: m),
            title: Text(
              m.nomComplet,
              style: const TextStyle(fontWeight: FontWeight.bold, color: bleuNuit),
            ),
            subtitle: Text('${m.parente}\nNaissance : ${m.dateNaissance}'),
            isThreeLine: true,
            onTap: () => openDetail(m),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') openForm(member: m);
                if (value == 'delete') removeMember(m);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Modifier')),
                PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Boîte de confirmation avant suppression (utilisée aussi par la fiche détail).
Future<bool> confirmDelete(BuildContext context, FamilleMembre member) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmation'),
      content: Text('Voulez-vous vraiment supprimer ${member.nomComplet} ?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  return confirmed == true;
}
