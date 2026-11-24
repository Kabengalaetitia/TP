import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:laetitia/config/api_config.dart';
import '../models/famille_membre.dart';
import 'api_client.dart';

/// Opérations CRUD sur les membres de la famille (table `famille_membre`).
class FamilleService {
  /// GET /famille-membres -> liste de tous les membres.
  static Future<List<FamilleMembre>> lister() async {
    final body = await ApiClient.send(() => http.get(ApiConfig.uri('/famille-membres')));
    final liste = body['data'] as List<dynamic>;
    return liste.map((e) => FamilleMembre.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /famille-membres/{id} -> un seul membre.
  static Future<FamilleMembre> afficher(int id) async {
    final body = await ApiClient.send(() => http.get(ApiConfig.uri('/famille-membres/$id')));
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// POST /famille-membres -> ajoute un membre (avec ou sans photo).
  static Future<FamilleMembre> creer(FamilleMembre membre, {XFile? photo}) async {
    final body = await ApiClient.send(() async {
      if (photo != null) return _envoyerFormData('/famille-membres', membre, photo);
      return http.post(
        ApiConfig.uri('/famille-membres'),
        headers: ApiClient.jsonHeaders,
        body: jsonEncode(membre.toJson()),
      );
    });
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Modifie un membre :
  /// - sans nouvelle photo : PUT  /famille-membres/{id} en JSON (la photo est gardée)
  /// - avec nouvelle photo : POST /famille-membres/{id} en form-data
  static Future<FamilleMembre> modifier(FamilleMembre membre, {XFile? photo}) async {
    final id = membre.id!;
    final body = await ApiClient.send(() async {
      if (photo != null) return _envoyerFormData('/famille-membres/$id', membre, photo);
      return http.put(
        ApiConfig.uri('/famille-membres/$id'),
        headers: ApiClient.jsonHeaders,
        body: jsonEncode(membre.toJson()),
      );
    });
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// DELETE /famille-membres/{id} -> supprime le membre et sa photo.
  static Future<void> supprimer(int id) async {
    await ApiClient.send(() => http.delete(ApiConfig.uri('/famille-membres/$id')));
  }

  /// Envoie les champs + le fichier image en multipart/form-data.
  static Future<http.Response> _envoyerFormData(
    String chemin,
    FamilleMembre membre,
    XFile photo,
  ) async {
    final requete = http.MultipartRequest('POST', ApiConfig.uri(chemin))
      ..headers['Accept'] = 'application/json'
      ..fields.addAll(membre.toJson())
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        await photo.readAsBytes(),
        // Sans nom de fichier, PHP considère qu'aucune image n'a été envoyée.
        filename: photo.name.isNotEmpty ? photo.name : 'photo.jpg',
      ));
    final flux = await requete.send();
    return http.Response.fromStream(flux);
  }
}
