import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ScamTap/services/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/services/premium_service.dart';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';

class ScamreportPage extends StatefulWidget {
  const ScamreportPage({super.key, this.result, this.inputText = ''});

  final Map<String, dynamic>? result;
  final String inputText;

  @override
  State<ScamreportPage> createState() => _ScamreportPageState();
}

class _ScamreportPageState extends State<ScamreportPage> {
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  Future<void> _checkPremium() async {
    final isPremium = await PremiumService.isPremium();
    setState(() {
      _isPremium = isPremium;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> detail = Map<String, dynamic>.from(widget.result?['detail'] ?? widget.result ?? {});
    final bool isScam = widget.result?['is_scam'] ?? detail['is_scam'] ?? false;
    final double riskScore = (widget.result?['risk_score'] as num?)?.toDouble() ?? (widget.result?['riskScore'] as num?)?.toDouble() ?? 0;
    final String verdict = widget.result?['verdict'] ?? detail['verdict'] ?? 'UNKNOWN';
    final String type = widget.result?['type'] ?? detail['type'] ?? 'unknown';
    final String aiAdvice = widget.result?['ai_analysis']?['advice'] ?? detail['ai_analysis']?['advice'] ?? '';
    final String confidence = widget.result?['ai_analysis']?['confidence'] ?? detail['ai_analysis']?['confidence'] ?? 'low';
    final int policeCount = widget.result?['penipumy']?['police_report_count'] ?? detail['penipumy']?['police_report_count'] ?? 0;
    final bool isFraud = widget.result?['penipumy']?['fraud'] ?? detail['penipumy']?['fraud'] ?? false;
    final double spamScore = (widget.result?['huggingface']?['spam_score'] as num?)?.toDouble() ?? (detail['huggingface']?['spam_score'] as num?)?.toDouble() ?? 0.0;
    final int malicious = widget.result?['virustotal']?['malicious'] ?? detail['virustotal']?['malicious'] ?? 0;
    final Map<String, dynamic> numverify = widget.result?['numverify'] ?? detail['numverify'] ?? {};

    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Risk Score and Status
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
                                Text(
                                  isScam ? "Scam Detected" : "Looks Safe",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isScam ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isScam ? "High risk! Do not interact!" : "No threats detected",
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (_isPremium)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 10, color: Colors.amber),
                                    SizedBox(width: 4),
                                    Text(
                                      'Premium Analysis',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // AI ADVICE SECTION - ONLY FOR PREMIUM USERS
                  if (_isPremium && aiAdvice.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 249, 202, 246),
                            Color.fromARGB(255, 208, 199, 247),
                            Color.fromRGBO(227, 222, 251, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "AI Safety Advice",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              aiAdvice,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            if (confidence.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.trending_up, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Confidence: ${confidence.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: confidence == 'high' ? Colors.green : confidence == 'medium' ? Colors.orange : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Upgrade prompt for free users
                  if (!_isPremium) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PremiumPurchasePage()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.lock, size: 14, color: Colors.amber),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Upgrade to Premium to see AI safety advice',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFC940), Color(0xFFFF9500)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'UPGRADE',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Phone Details (for phone numbers)
                  if (type == 'phone' && numverify.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.sim_card_rounded, size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 6),
                              Text("Phone Details",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blue.shade700)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _PhoneDetailRow(label: 'Number',   value: numverify['international_format'] ?? widget.inputText),
                          _PhoneDetailRow(label: 'Country',  value: numverify['country_name']         ?? '-'),
                          _PhoneDetailRow(label: 'Carrier',  value: numverify['carrier']              ?? '-'),
                          _PhoneDetailRow(label: 'Line Type',value: numverify['line_type']            ?? '-'),
                          _PhoneDetailRow(label: 'Valid',    value: numverify['valid'] == true ? 'Yes' : 'No'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Message Content (for messages)
                  if (type == 'message') ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 223, 223),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.message_rounded, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 6),
                              Text(
                                'Message Content',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.inputText,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A), height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 24),

                  // Evidence Items
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
                      count: widget.result?['virustotal']?['suspicious'] ?? 0,
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

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                                        child: Icon(Icons.report_rounded, color: Colors.red.shade600, size: 36),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Report this?',
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                                      const SizedBox(height: 8),
                                      Text(
                                        'You are about to report "${widget.inputText}" as a scam. This will help protect other users.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.45),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(dialogContext),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(color: Colors.grey.shade300),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              child: const Text('Cancel',
                                                style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600)),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(dialogContext);
                                                final success = await ReportService.submitReport(
                                                  value     : widget.inputText,
                                                  result    : widget.result,
                                                  riskScore : riskScore,
                                                  verdict   : verdict,
                                                  reason    : aiAdvice.isNotEmpty ? aiAdvice : 'No reason provided',
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
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade600,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                              ),
                                              child: const Text('Report', style: TextStyle(fontWeight: FontWeight.w700)),
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
                        icon: const Icon(Icons.report_gmailerrorred_outlined, size: 18),
                        label: const Text("Report"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                            ShareParams(text: 'Risk Score: $riskScore/100\nVerdict: $verdict\n\n${aiAdvice.isNotEmpty ? "AI Advice: $aiAdvice" : ""}')
                          );
                        },
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text("Share"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          side: BorderSide(color: Colors.grey[400]!),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 82, 152, 208),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

class _PhoneDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _PhoneDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }
}