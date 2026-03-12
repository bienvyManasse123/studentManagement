import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/etudiant.dart';
import '../services/api_service.dart';
import 'add_edit_screen.dart';
import 'stats_screen.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  List<Etudiant> _etudiants = [];
  Map<String, dynamic>? _stats;
  bool _loading = true;
  int _currentIndex = 0;
 
  @override
  void initState() {
    super.initState();
    _load();
  }
 
  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final e = await ApiService.getEtudiants();
      Map<String, dynamic>? s;
      if (e.isNotEmpty) s = await ApiService.getStats();
      setState(() {
        _etudiants = e;
        _stats = s;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur de connexion au serveur')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }
 
  Future<void> _delete(Etudiant e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer ${e.nomEt} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ApiService.deleteEtudiant(e.numEt);
      _load();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          // ── Contenu principal ──
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(),
              _buildAddTab(),
              _stats != null
                  ? StatsScreen(stats: _stats!)
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
 
          // ── Bottom nav flottante par-dessus le contenu ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }
 
  Widget _buildHomeTab() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_stats != null) _buildStatsCards(_stats!),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Liste étudiants :',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _etudiants.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun étudiant enregistré',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: _etudiants.length,
                          itemBuilder: (ctx, i) =>
                              _buildSwipeableCard(_etudiants[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: const Text(
        'Student Management',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
 
  Widget _buildStatsCards(Map<String, dynamic> s) {
    final admis = s['admis'] as int;
    final redoublants = s['redoublants'] as int;
    final total = s['total'] as int;
    final moyMin = (s['moyenne_min'] as num).toStringAsFixed(0);
    final moyMoy = (s['moyenne_classe'] as num).toStringAsFixed(0);
    final moyMax = (s['moyenne_max'] as num).toStringAsFixed(0);
 
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              _statCard('$admis', 'Total Elève Admis', Color(0xFF1A1A2E)),
              const SizedBox(width: 10),
              _statCard('$redoublants', 'Total Elève Redoublant', Color(0xFF1A1A2E)),
              const SizedBox(width: 10),
              _statCard('$total', 'Total Elève', Color(0xFF1A1A2E)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statCard(moyMin, 'Moyenne . Min', Color(0xFF1A1A2E)),
              const SizedBox(width: 10),
              _statCard(moyMoy, 'Moyenne . Moyen', Color(0xFF1A1A2E)),
              const SizedBox(width: 10),
              _statCard(moyMax, 'Moyenne . Max', Color(0xFF1A1A2E)),
            ],
          ),
        ],
      ),
    );
  }
 
  Widget _statCard(String value, String label, Color valueColor,
      {Color? border}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: border != null
              ? Border.all(color: border, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildSwipeableCard(Etudiant e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key('etudiant_${e.numEt}'),
        // Glisse gauche → Supprimer
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Glisse gauche = supprimer
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Text('Confirmer'),
                content: Text('Supprimer ${e.nomEt} ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Supprimer',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
            if (ok == true) {
              await ApiService.deleteEtudiant(e.numEt);
              _load();
            }
            return false; // on gère nous-mêmes via _load()
          } else {
            // Glisse droite = modifier
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddEditScreen(etudiant: e)),
            );
            _load();
            return false;
          }
        },
        // Fond rouge (gauche → suppression)
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Row(
            children: [
              Icon(Icons.edit, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text('Modifier',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Fond vert (droite → modification)
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Supprimer',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.delete, color: Colors.white, size: 28),
            ],
          ),
        ),
        child: _buildStudentCard(e),
      ),
    );
  }
 
  Widget _buildStudentCard(Etudiant e) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.nomEt,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Note Math: ${e.noteMath}, Note Physique: ${e.notePhys}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Moyenne: ${e.moyenne.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13,
                color: e.isAdmis ? Colors.green.shade600 : Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: e.isAdmis
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: e.isAdmis
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                  width: 1,
                ),
              ),
              child: Text(
                e.isAdmis ? '✓ Admis' : '✗ Redoublant',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: e.isAdmis
                      ? Colors.green.shade700
                      : Colors.red.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildAddTab() {
    // Redirige immédiatement vers AddEditScreen et revient sur Home
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_currentIndex == 1) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScreen()),
        );
        _load();
        setState(() => _currentIndex = 0);
      }
    });
    return const Center(child: CircularProgressIndicator());
  }
 
  Widget _buildBottomNav() {
    final activeIndex = _currentIndex == 1 ? 0 : _currentIndex;
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.add_circle_outline, 'activeIcon': Icons.add_circle, 'label': 'Ajouter'},
      {'icon': Icons.bar_chart_outlined, 'activeIcon': Icons.bar_chart, 'label': 'Stats'},
    ];
 
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 95, right: 95),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.22),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isActive = activeIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddEditScreen()),
                        ).then((_) => _load());
                      } else if (index == 2 && _stats == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Aucune donnée disponible')),
                        );
                      } else {
                        setState(() => _currentIndex = index);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive
                                ? items[index]['activeIcon'] as IconData
                                : items[index]['icon'] as IconData,
                            color: isActive ? Colors.white : Colors.white38,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            items[index]['label'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isActive ? Colors.white : Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
      );
  }
}