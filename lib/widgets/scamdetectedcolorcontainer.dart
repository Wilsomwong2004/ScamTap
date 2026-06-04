import 'package:ScamTap/models/scam_model.dart';
import 'package:ScamTap/pages/scamreport_page.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/services/report_service.dart';

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
  
  Future<void> _submitReport(BuildContext dialogContext) async {
    final String value     = widget.result?['value'] ?? '';
    final double riskScore = (widget.result?['risk_score'] as num?)?.toDouble() ?? 0;
    final String verdict   = widget.result?['verdict'] ?? 'UNKNOWN';
    final String reason    = widget.result?['ai_analysis']?['reason'] ?? '';

    final success = await ReportService.submitReport(
      value     : value,
      result    : widget.result,
      riskScore : riskScore,
      verdict   : verdict,
      reason    : reason,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
            ? 'Report submitted. Thank you!'
            : 'Failed to submit. Please try again.'),
          backgroundColor: success ? Colors.green.shade700 : Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
  
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
                          final String value = widget.result?['value'] ?? 'this number';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.report_rounded, color: Colors.red.shade600, size: 36),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                      widget.result?['type'] == 'phone'
                                          ? 'Report this number?'
                                          : widget.result?['type'] == 'link'
                                              ? 'Report this link?'
                                              : 'Report this message?',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'You are about to report as a ${widget.result?['type'] == 'phone' ? 'scam number' : widget.result?['type'] == 'link' ? 'malicious link' : 'scam message'}. This will help protect other users.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                          height: 1.45,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(color: Colors.grey.shade300),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Color(0xFF1A1A1A),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await _submitReport(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade600,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              child: const Text(
                                                'Report',
                                                style: TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
              padding: EdgeInsets.fromLTRB(15, 15, 25, 15),
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