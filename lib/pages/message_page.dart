import 'package:ScamTap/widgets/scamdetectedcolorcontainer.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/widgets/miniprofile.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            "Messages",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Miniprofile()),
                );
              },
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 44, 51, 106),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body:
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 76, 102, 175), const Color.fromARGB(255, 199, 199, 199)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Verify Message", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 255, 255, 255))),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 233, 247, 235),
                      hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 109, 109, 109)),
                      hintText: "Enter text to verify",
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Icon(Icons.search),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 76, 87, 175)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 76, 87, 175)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 76, 87, 175)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            ScamDetectedColorContainer(),
            
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 25),
            //   child: Container(
            //     width: double.infinity,
            //     height: 170,
            //     decoration: BoxDecoration(
            //       color: Colors.grey[400],
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           blurRadius: 10,
            //           offset: Offset(0, 4),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             children: [
            //               Row(
            //                 children: [

            //                   Icon(
            //                     Icons.warning,
            //                     color: Colors.yellow.shade400,
            //                     size: 20.0,
            //                     semanticLabel: 'Text to announce in acce',
            //                     ),
                              
            //                   SizedBox(width: 10),

            //                   Text(
            //                     "Scam Detected",
            //                     style: TextStyle(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ],
            //               ),

            //               SizedBox(height: 10),

            //               Text("High risk! No interact!"),

            //               SizedBox(height: 5),

            //               Row(
            //                 children: [
            //                   Padding(
            //                     padding: EdgeInsets.symmetric(
            //                       horizontal: 0,
            //                       vertical: 10,
            //                     ),
            //                     child: SizedBox(
            //                       width: 130,
            //                       height: 35,
            //                       child: ElevatedButton(
            //                         onPressed: () {
            //                           print("clicked!");
            //                         },
            //                         child: Text(
            //                           "Check Report",
            //                           style: TextStyle(fontSize: 12),
            //                         ),
            //                       ),
            //                     ),
                                
            //                   ),

            //                   SizedBox(width: 8),
                              
            //                   SizedBox(
            //                     width: 35,
            //                     height: 35,
            //                     child: ElevatedButton(
            //                       onPressed: () {
            //                         print("clicked!");
            //                       },
            //                       style: ElevatedButton.styleFrom(
            //                         padding: EdgeInsets.zero,
            //                         shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(30),
            //                         ),
            //                       ),
            //                       child: Icon(Icons.report, size: 18),
            //                     ),
            //                   ),
            //                 ],
            //               ),

            //               // SizedBox(width: 10),
            //             ],
            //           ),
            //         ),

            //         Padding(
            //           padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //           child: Container(
            //             width: 120,
            //             height: 120,
            //             decoration: BoxDecoration(
            //               color: const Color.fromARGB(255, 255, 255, 255),
            //               borderRadius: BorderRadius.circular(20),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.black26,
            //                   blurRadius: 10,
            //                   offset: Offset(0, 2),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Recent Message",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

        
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }
}