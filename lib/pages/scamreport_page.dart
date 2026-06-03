import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ScamreportPage extends StatelessWidget {
  const ScamreportPage({super.key, this.result, this.inputText = ''});

  final Map<String, dynamic>? result;
  final String inputText;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> detail =  Map<String, dynamic>.from(result?['detail'] ?? result ?? {});
    final bool isScam = result?['is_scam'] ?? detail['is_scam'] ?? false;
    final double riskScore = (result?['risk_score'] as num?)?.toDouble() ?? (result?['riskScore'] as num?)?.toDouble() ?? 0;
    final String verdict = result?['verdict'] ?? detail['verdict'] ?? 'UNKNOWN';
    final String type = result?['type'] ?? 'unknown';
    final String reason = result?['ai_analysis']?['reason'] ?? detail['ai_analysis']?['reason'] ?? 'No reason provided';
    final String confidence = result?['ai_analysis']?['confidence'] ?? detail['ai_analysis']?['confidence'] ?? 'low';
    final int policeCount = result?['penipumy']?['police_report_count'] ?? detail['penipumy']?['police_report_count'] ?? 0;
    final bool isFraud = result?['penipumy']?['fraud'] ?? detail['penipumy']?['fraud'] ?? false;
    final double spamScore = (result?['huggingface']?['spam_score'] as num?)?.toDouble() ?? (detail['huggingface']?['spam_score'] as num?)?.toDouble() ?? 0.0;
    final int malicious = result?['virustotal']?['malicious'] ?? detail['virustotal']?['malicious'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            "Scan Results",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
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
                backgroundColor: const Color.fromARGB(255, 44, 106, 46),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // Use a Column to pin buttons at the bottom
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
            
                      Container(
                        width: 140,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Scoregauge(score: riskScore),
                      ),

                      const SizedBox(width: 25),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(isScam ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                                    color: Colors.black, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  "Scam Detected",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isScam ? "Scam Detected" : "Looks Safe",
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isScam ? "High risk! Do not interact!" : "No threats detected",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 249, 202, 246),
                        Color.fromARGB(255, 208, 199, 247),
                        Color.fromRGBO(227, 222, 251, 1),
                      ],
                    ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.grey[800], fontWeight: FontWeight.bold,),
                              const SizedBox(width: 8),
                              Text(
                                "AI analysis:",
                                style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w500),
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            reason,
                            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: confidence == 'high' ? Colors.red[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Confidence: $confidence",
                      style: TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (type == 'phone') ...[
                  _EvidenceItem(
                    icon: Icons.phone_disabled_rounded,
                    label: "Fraud Reported",
                    subtitle: isFraud ? "Confirmed" : "Not reported",
                    count: policeCount,
                  ),
                  const SizedBox(height: 16),
                  _EvidenceItem(
                    icon: Icons.gavel_rounded,
                    label: "Police Reports",
                    count: policeCount,
                  ),
                ] else if (type == 'link') ...[
                  _EvidenceItem(
                    icon: Icons.dangerous_rounded,
                    label: "Malicious Engines",
                    count: malicious,
                  ),
                  const SizedBox(height: 16),
                  _EvidenceItem(
                    icon: Icons.warning_amber_rounded,
                    label: "Suspicious Engines",
                    count: result?['virustotal']?['suspicious'] ?? 0,
                  ),
                ] else if (type == 'message') ...[
                  _EvidenceItem(
                    icon: Icons.security,
                    label: "Spam Score",
                    subtitle: "${(spamScore * 100).toStringAsFixed(0)}%",
                    count: (spamScore * 100).toInt(),
                  ),
                ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.report_gmailerrorred_outlined,
                            size: 18),
                        label: const Text("Block / Report"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 225, 79, 76),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SharePlus.instance.share(
                            ShareParams(text: 'Risk Score: $riskScore/100\nVerdict: $verdict\nReason: $reason')
                          );
                        },
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text("Share"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 82, 152, 208),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 80, 185, 83),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _EvidenceItem extends StatelessWidget {
  final String label;
  final String? subtitle;
  final int count;
  final IconData icon;

  const _EvidenceItem({
    required this.label,
    this.subtitle,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[300],
          child: Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle != null ? "$label ($subtitle)" : label,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: Text(
            "$count",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}