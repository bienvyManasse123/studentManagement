class Etudiant {
  final int numEt;
  final String nomEt;
  final double noteMath;
  final double notePhys;
  final double moyenne;

  Etudiant({
    required this.numEt, required this.nomEt,
    required this.noteMath, required this.notePhys,
    required this.moyenne,
  });

  factory Etudiant.fromJson(Map<String, dynamic> j) => Etudiant(
    numEt: j['numEt'], nomEt: j['nomEt'],
    noteMath: (j['note_math'] as num).toDouble(),
    notePhys: (j['note_phys'] as num).toDouble(),
    moyenne: (j['moyenne'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'nomEt': nomEt, 'note_math': noteMath, 'note_phys': notePhys,
  };

  bool get isAdmis => moyenne >= 10;
}
