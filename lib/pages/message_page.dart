import 'package:flutter/material.dart';
import 'package:scam_tap/widgets/miniprofile.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "Message",
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

      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Verify Message", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter text to verify",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        
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
                      padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

            SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Recent Message",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

        
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
    );
  }
}