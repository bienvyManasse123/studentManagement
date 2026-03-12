import 'package:flutter/material.dart';
import '../models/etudiant.dart';
import '../services/api_service.dart';

class AddEditPage extends StatefulWidget {
  final Etudiant? etudiant;
  const AddEditPage({super.key, this.etudiant});
  @override State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl, _mathCtrl, _physCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl  = TextEditingController(text: widget.etudiant?.nomEt ?? '');
    _mathCtrl = TextEditingController(text: widget.etudiant?.noteMath.toString() ?? '');
    _physCtrl = TextEditingController(text: widget.etudiant?.notePhys.toString() ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose(); _mathCtrl.dispose(); _physCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'nomEt': _nomCtrl.text.trim(),
      'note_math': double.parse(_mathCtrl.text),
      'note_phys': double.parse(_physCtrl.text),
    };
    try {
      if (widget.etudiant == null) {
        await ApiService.addEtudiant(data);
      } else {
        await ApiService.updateEtudiant(widget.etudiant!.numEt, data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  String? _validateNote(String? val) {
    if (val == null || val.isEmpty) return 'Obligatoire';
    final n = double.tryParse(val);
    if (n == null) return 'Nombre invalide';
    if (n < 0 || n > 20) return 'Note entre 0 et 20';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.etudiant != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier étudiant' : 'Ajouter étudiant'),
        backgroundColor: Colors.blue, foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'étudiant',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mathCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Note Mathématiques (0-20)',
                  prefixIcon: Icon(Icons.calculate),
                  border: OutlineInputBorder(),
                ),
                validator: _validateNote,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _physCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Note Physique (0-20)',
                  prefixIcon: Icon(Icons.science),
                  border: OutlineInputBorder(),
                ),
                validator: _validateNote,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                    ? const SizedBox(width:20,height:20,
                        child: CircularProgressIndicator(strokeWidth:2))
                    : const Icon(Icons.save),
                  label: Text(isEdit ? 'Modifier' : 'Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
