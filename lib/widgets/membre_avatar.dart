import 'package:material_ui/material_ui.dart';

import '../config/app_colors.dart';
import '../models/famille_membre.dart';

/// Photo ronde du membre, ou une icône s'il n'a pas de photo.
class MembreAvatar extends StatelessWidget {
  final FamilleMembre membre;
  final double rayon;

  const MembreAvatar({super.key, required this.membre, this.rayon = 28});

  @override
  Widget build(BuildContext context) {
    final icone = Icon(Icons.person, size: rayon, color: dore);
    final url = membre.imageUrl;

    return CircleAvatar(
      radius: rayon,
      backgroundColor: bleuNuit,
      child: url == null || url.isEmpty
          ? icone
          : ClipOval(
              child: Image.network(
                url,
                width: rayon * 2,
                height: rayon * 2,
                fit: BoxFit.cover,
                // Sur Chrome : si le serveur bloque l'image (CORS), Flutter
                // l'affiche quand même avec une balise <img> classique.
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (_, _, _) => icone,
              ),
            ),
    );
  }
}
