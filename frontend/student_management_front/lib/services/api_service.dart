import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/etudiant.dart';

class ApiService {
  // Remplacer par l'IP de votre machine
  static const String baseUrl = 'http://192.168.0.100:8000';

  // GET tous les étudiants
  static Future<List<Etudiant>> getEtudiants() async {
    final r = await http.get(Uri.parse('$baseUrl/etudiants'));
    if (r.statusCode == 200) {
      final List data = json.decode(r.body);
      return data.map((e) => Etudiant.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement');
  }

  // POST ajouter
  static Future<Etudiant> addEtudiant(Map<String, dynamic> data) async {
    final r = await http.post(
      Uri.parse('$baseUrl/etudiants'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (r.statusCode == 201) return Etudiant.fromJson(json.decode(r.body));
    throw Exception('Erreur ajout');
  }

  // PUT modifier
  static Future<Etudiant> updateEtudiant(int id, Map<String, dynamic> data) async {
    final r = await http.put(
      Uri.parse('$baseUrl/etudiants/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (r.statusCode == 200) return Etudiant.fromJson(json.decode(r.body));
    throw Exception('Erreur modification');
  }

  // DELETE supprimer
  static Future<void> deleteEtudiant(int id) async {
    final r = await http.delete(Uri.parse('$baseUrl/etudiants/$id'));
    if (r.statusCode != 200) throw Exception('Erreur suppression');
  }

  // GET statistiques
  static Future<Map<String, dynamic>> getStats() async {
    final r = await http.get(Uri.parse('$baseUrl/statistiques'));
    if (r.statusCode == 200) return json.decode(r.body);
    throw Exception('Erreur statistiques');
  }
}