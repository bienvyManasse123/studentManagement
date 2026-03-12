import 'package:flutter/material.dart';
import '../models/etudiant.dart';
import '../services/api_service.dart';
import 'add_edit_page.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Etudiant> _etudiants = [];
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  // Load data from BD through our API service
  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final e = await ApiService.getEtudiants();
      Map<String, dynamic>? s;
      if (e.isNotEmpty) s = await ApiService.getStats();
      setState(() { _etudiants = e; _stats = s; });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion au serveur')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(Etudiant e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text('Supprimer ${e.nomEt} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
    if (ok == true) { await ApiService.deleteEtudiant(e.numEt); _load(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Étudiants'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _stats == null ? null : () =>
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => StatsPage(stats: _stats!))),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Expanded(
              child: _etudiants.isEmpty
                ? const Center(child: Text('Aucun étudiant enregistré'))
                : ListView.builder(
                  itemCount: _etudiants.length,
                  itemBuilder: (ctx, i) {
                    final e = _etudiants[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: e.isAdmis ? Colors.green : Colors.red,
                          child: Text('${e.numEt}',
                            style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        title: Text(e.nomEt, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Math: ${e.noteMath} | Phys: ${e.notePhys} | Moy: ${e.moyenne.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(e.isAdmis ? 'Admis' : 'Redoublant',
                                style: const TextStyle(color: Colors.white, fontSize: 11)),
                              backgroundColor: e.isAdmis ? Colors.green : Colors.orange,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => AddEditPage(etudiant: e)));
                                _load();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _delete(e),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
            if (_stats != null) _buildStatsBar(_stats!),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const AddEditPage()));
          _load();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsBar(Map<String, dynamic> s) {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Divider(thickness: 2, color: Colors.blue),
          Text('Statistiques de la classe',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Total', '${s['total']}', Colors.blue),
              _stat('Admis', '${s['admis']}', Colors.green),
              _stat('Redoublants', '${s['redoublants']}', Colors.orange),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Moy. Classe', (s['moyenne_classe'] as num).toStringAsFixed(2), Colors.purple),
              _stat('Moy. Min', (s['moyenne_min'] as num).toStringAsFixed(2), Colors.red),
              _stat('Moy. Max', (s['moyenne_max'] as num).toStringAsFixed(2), Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
