import 'package:flutter/material.dart';
import '../models/etudiant.dart';
import '../services/api_service.dart';
 
class AddEditScreen extends StatefulWidget {
  final Etudiant? etudiant;
  const AddEditScreen({super.key, this.etudiant});
 
  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}
 
class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl, _mathCtrl, _physCtrl;
  bool _saving = false;
 
  @override
  void initState() {
    super.initState();
    _nomCtrl  = TextEditingController(text: widget.etudiant?.nomEt ?? '');
    _mathCtrl = TextEditingController(
        text: widget.etudiant?.noteMath.toString() ?? '');
    _physCtrl = TextEditingController(
        text: widget.etudiant?.notePhys.toString() ?? '');
  }
 
  @override
  void dispose() {
    _nomCtrl.dispose();
    _mathCtrl.dispose();
    _physCtrl.dispose();
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
        if (mounted) Navigator.pop(context, 'ajoute');
      } else {
        await ApiService.updateEtudiant(widget.etudiant!.numEt, data);
        if (mounted) Navigator.pop(context, 'modifie');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      setState(() => _saving = false);
    }
  }
 
  String? _validateNote(String? val) {
    if (val == null || val.isEmpty) return 'Ce champ est obligatoire';
    final n = double.tryParse(val);
    if (n == null) return 'Veuillez entrer un nombre valide';
    if (n < 0 || n > 20) return 'La note doit être entre 0 et 20';
    return null;
  }
 
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.etudiant != null;
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header identique à HomeScreen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(60, 60, 60, 60),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  Text(
                    isEdit ? 'Modifier étudiant' : 'Ajouter étudiant',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
 
            // Formulaire
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildLabel('Nom de l\'étudiant'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nomCtrl,
                        hint: 'Ex: Ramarokoto Bienvenu',
                        icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ce champ est obligatoire'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Note Mathématiques'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _mathCtrl,
                        hint: 'Entre 0 et 20',
                        icon: Icons.calculate_outlined,
                        keyboardType: TextInputType.number,
                        validator: _validateNote,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Note Physique'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _physCtrl,
                        hint: 'Entre 0 et 20',
                        icon: Icons.science_outlined,
                        keyboardType: TextInputType.number,
                        validator: _validateNote,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A2E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  isEdit ? 'Enregistrer les modifications' : 'Ajouter l\'étudiant',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
 
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF1A1A2E), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        errorStyle: TextStyle(color: Colors.red.shade400, fontSize: 12),
      ),
    );
  }
}