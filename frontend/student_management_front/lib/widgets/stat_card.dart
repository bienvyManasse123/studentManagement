import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {

  final double value;

  StatCard({required this.value});

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Color(0xFF1F2D3D),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        value.toStringAsFixed(2),
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),

    );
  }
}