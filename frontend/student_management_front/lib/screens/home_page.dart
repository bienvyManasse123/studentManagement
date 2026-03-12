import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  
  HomePage({super.key});

  final List<Student> students = [

    Student(numEt:1, nomEt:"Ramarokoto Bienvenu", noteMath:18.5, notePhys:17.5),

    Student(numEt:2, nomEt:"Jhon Doe", noteMath:15, notePhys:14.5),

    Student(numEt:3, nomEt:"Mickel B Jordan", noteMath:10, notePhys:12),
  ];

  @override
  Widget build(BuildContext context) {

    double moyenneClasse =
        students.map((e)=>e.moyenne).reduce((a,b)=>a+b)/students.length;

    double min =
        students.map((e)=>e.moyenne).reduce((a,b)=>a<b?a:b);

    double max =
        students.map((e)=>e.moyenne).reduce((a,b)=>a>b?a:b);

    return Scaffold(

      backgroundColor: Colors.grey[200],

      body: SafeArea(

        child: Column(

          children: [

            /// HEADER
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF1F2D3D),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)
                ),
              ),

              child: Center(
                child: Text(
                  "Student Management",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),

            /// STATISTIQUES

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                StatCard(value: moyenneClasse),

                StatCard(value: min),

                StatCard(value: max),

              ],
            ),

            SizedBox(height: 20),

            /// TITRE

            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Liste étudiants :",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height:10),

            /// LISTE

            Expanded(

              child: ListView.builder(

                itemCount: students.length,

                itemBuilder: (context,index){

                  return StudentCard(student: students[index]);

                },

              ),

            ),

          ],

        ),

      ),

      bottomNavigationBar: BottomNav(),

    );
  }
}