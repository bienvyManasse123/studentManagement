import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {

  final Student student;

  StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.symmetric(horizontal:20, vertical:10),

      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0,5))
        ],

      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            student.nomEt,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),

          SizedBox(height:5),

          Text(
              "Note Math: ${student.noteMath}, Note Physique: ${student.notePhys}"
          ),

          SizedBox(height:5),

          Text(
              "Moyenne: ${student.moyenne.toStringAsFixed(2)}"
          ),

        ],
      ),

    );
  }
}