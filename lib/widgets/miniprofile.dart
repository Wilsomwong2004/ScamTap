import 'package:flutter/material.dart';

class Miniprofile extends StatelessWidget {
  const Miniprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            
            CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
          
          ],
        )
      ),
    );
  }
}