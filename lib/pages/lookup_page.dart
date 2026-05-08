import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scam_tap/widgets/miniprofile.dart';

class LookupPage extends StatelessWidget {
  const LookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "Lookup",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                Miniprofile();
              },
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verify Number / Link", style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "+60113223413",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [

                            Icon(
                              Icons.warning,
                              color: Colors.yellow.shade400,
                              size: 20.0,
                              semanticLabel: 'Text to announce in acce',
                              ),
                            
                            SizedBox(width: 10),

                            Text(
                              "Scam Detected",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        Text("Second line"),

                        SizedBox(height: 5),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              child: SizedBox(
                                width: 130,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("clicked!");
                                  },
                                  child: Text(
                                    "Check Report",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              
                            ),

                            SizedBox(width: 5),
                            
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  print("clicked!");
                                },
                                icon: Icon(Icons.report),
                                label: Text(""),
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(width: 10),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                "Recent Lookup",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  // ElevatedButton.icon(
                  //   onPressed: onPressed,
                  //   label: label
                  // ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
