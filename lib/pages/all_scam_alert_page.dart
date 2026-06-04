import 'package:flutter/material.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/scamreport_page.dart';

class AllScamAlertsPage extends StatelessWidget {
  final List<SearchRecordModel> records;
  const AllScamAlertsPage({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Scam Alerts", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: records.isEmpty
          ? const Center(child: Text("No scam records found."))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final aiAnalysis = record.detail['ai_analysis'] as Map<String, dynamic>? ?? {};
                final reason     = aiAnalysis['reason']     ?? 'No reason provided';
                final confidence = aiAnalysis['confidence'] ?? 'low';

                final Color riskColor = record.riskLevel == 'Dangerous'
                    ? Colors.red
                    : record.riskLevel == 'Warning'
                        ? Colors.orange
                        : Colors.green;

                final IconData typeIcon = record.type == 'phone'
                    ? Icons.phone
                    : record.type == 'link'
                        ? Icons.link
                        : Icons.message;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScamreportPage(
                            result: record.rawData ?? {},
                            inputText: record.value,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                        border: Border.all(color: riskColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(typeIcon, size: 16, color: riskColor),
                                  const SizedBox(width: 6),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      record.value,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: riskColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  record.riskLevel,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: riskColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  reason,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: confidence == 'high' ? Colors.red.shade50 : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Confidence: $confidence",
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                ),
                              ),
                              Text(
                                "${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year}",
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}