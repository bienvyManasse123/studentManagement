class Student {

  int numEt;
  String nomEt;
  double noteMath;
  double notePhys;

  Student({
    required this.numEt,
    required this.nomEt,
    required this.noteMath,
    required this.notePhys
  });

  double get moyenne => (noteMath + notePhys)/2;

  factory Student.fromJson(Map<String,dynamic> json){

    return Student(
      numEt: json["numEt"],
      nomEt: json["nomEt"],
      noteMath: json["note_math"].toDouble(),
      notePhys: json["note_phys"].toDouble(),
    );
  }

  Map<String,dynamic> toJson(){

    return {
      "numEt":numEt,
      "nomEt":nomEt,
      "note_math":noteMath,
      "note_phys":notePhys
    };
  }
}