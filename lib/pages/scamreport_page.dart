import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ScamreportPage extends StatelessWidget {
  const ScamreportPage({super.key});

  // int phonenumber = ;
  // String link = ;

  @override
  Widget build(BuildContext context) {
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
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Scoregauge(score: 85),
                      ),

                      const SizedBox(width: 40),

                      // Scam info text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.black, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Scam Detected",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "High risk ! No interact !",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Beware using the link,\nDon't share to anyone",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Message Highlight (For message)",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _EvidenceItem(
                    label: "Fake domain",
                    subtitle: "3 days ago",
                    count: 10,
                  ),
                  const SizedBox(height: 16),
                  _EvidenceItem(
                    label: "Sender proof message",
                    count: 20,
                  ),
                  const SizedBox(height: 16),
                  _EvidenceItem(
                    label: "Community Report",
                    count: 200,
                  ),

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
                            ShareParams(text: 'testing')
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

  const _EvidenceItem({
    required this.label,
    this.subtitle,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[300],
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
        Text(
          "$count",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}