import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(20),

      padding: EdgeInsets.symmetric(vertical:10),

      decoration: BoxDecoration(

        color: Color(0xFF3E3A39),

        borderRadius: BorderRadius.circular(40),

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          Icon(Icons.home,color: Colors.white),

          Icon(Icons.location_on,color: Colors.white),

          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.calendar_today,color: Colors.black),
          ),

        ],

      ),

    );
  }
}