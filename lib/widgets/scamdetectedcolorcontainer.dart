import 'package:ScamTap/models/scam_model.dart';
import 'package:ScamTap/pages/scamreport_page.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:flutter/material.dart';

class ScamDetectedColorContainer extends StatefulWidget {
  final Map<String, dynamic>? result;
  const ScamDetectedColorContainer({super.key, this.result});

  @override
  State<ScamDetectedColorContainer> createState() => _ScamDetectedColorContainerState();
}

class _ScamDetectedColorContainerState extends State<ScamDetectedColorContainer> {
  final IndicatorColor = {
    "Dangerous": const Color.fromARGB(255, 247, 116, 116),
    "Warning": Color.fromRGBO(252, 220, 114, 1),
    "Safe": const Color.fromARGB(255, 96, 224, 107),
  };
  
  @override
  Widget build(BuildContext context) {
    final bool isScam = widget.result?['is_scam'] ?? false;
    final double riskScore = (widget.result?['risk_score'] as num?)?.toDouble() ?? 0;
    final String verdict = widget.result?['verdict'] ?? 'UNKNOWN';
    final String reason = widget.result?['ai_analysis']?['reason'] ?? '';
    
    String currentStatus = riskScore >= 60 ? "Dangerous" : riskScore >= 30 ? "Warning": "Safe";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: IndicatorColor[currentStatus],
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
                        isScam ? Icons.warning : Icons.check_circle,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: 20.0,
                        semanticLabel: 'Text to announce in acce',
                        ),
                      
                      SizedBox(width: 10),

                      Text(
                        isScam ? "Scam Detected" : "Looks Safe",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    isScam ? "Avoid interaction immediately" : "No threats detected",
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
                                MaterialPageRoute(builder: (context) => ScamreportPage(
                                  result    : widget.result,
                                  inputText : widget.result?['value'] ?? '',
                                )),
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
              child: Scoregauge(score: riskScore),
            ),
            ),
          ],
        ),
      ),
    );
  }
}