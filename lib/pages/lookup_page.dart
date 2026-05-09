import 'package:flutter/material.dart';
import 'package:scam_tap/widgets/miniprofile.dart';
import 'package:scam_tap/widgets/scoregauge.dart';

class LookupPage extends StatelessWidget {
  const LookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "Lookup",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
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
                backgroundColor: const Color.fromARGB(255, 44, 106, 46),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.8],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: kToolbarHeight + 55,
              bottom: 100,
            ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Verify Number / Link", style: TextStyle(fontSize: 15, color: Colors.white,)),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "+60113223413",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 2, color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 209, 235, 44),
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
                        padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [

                                Icon(
                                  Icons.warning,
                                  color: const Color.fromARGB(255, 0, 0, 0),
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

                            Text("High risk! No interact!"),

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

                                SizedBox(width: 8),
                                
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("clicked!");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Icon(Icons.report, size: 18),
                                  ),
                                ),
                              ],
                            ),

                            // SizedBox(width: 10),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Scoregauge(score: 85),
                      ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Recent Lookup",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 15, 15),
                    child: SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print("clicked!");
                        },
                        icon: Icon(Icons.call_sharp),
                        label: Text("Call"),
                      ),
                    ),
                  ),

                  // SizedBox(width: 15),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 15),
                    child: SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print("clicked!");
                        },
                        icon: Icon(Icons.link),
                        label: Text("Link"),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: Container(
                        width: double.infinity,
                        height: 120,
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
                    ),
                  ),
                
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        width: double.infinity,
                        height: 120,
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
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 25),
                  //     child: Container(
                  //       width: double.infinity,
                  //       height: 120,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey[400],
                  //         borderRadius: BorderRadius.circular(20),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black26,
                  //             blurRadius: 10,
                  //             offset: Offset(0, 4),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
