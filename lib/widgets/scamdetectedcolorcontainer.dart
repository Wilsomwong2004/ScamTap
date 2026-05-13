import 'package:ScamTap/pages/scamreport_page.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:flutter/material.dart';

class ScamDetectedColorContainer extends StatefulWidget {
  const ScamDetectedColorContainer({super.key});

  @override
  State<ScamDetectedColorContainer> createState() => _ScamDetectedColorContainerState();
}

class _ScamDetectedColorContainerState extends State<ScamDetectedColorContainer> {
  final IndicatorColor = {
    "Dangerous": Colors.redAccent,
    "Warning": Color.fromRGBO(252, 220, 114, 1),
    "Safe": Colors.greenAccent,
  };
  
  String _currentStatus = "Warning";
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: IndicatorColor[_currentStatus],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromARGB(255, 248, 195, 72), width: 1),
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

                  Text(
                    "Avoid interaction immediately",
                    style: TextStyle(fontSize: 13),
                  ),

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ScamreportPage()),
                              );
                            },
                            child: Text(
                              "Check Report",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 94, 94, 94)),
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
                          child: Icon(Icons.report, size: 18, color: const Color.fromRGBO(180, 29, 29, 1)),
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
    );
  }
}