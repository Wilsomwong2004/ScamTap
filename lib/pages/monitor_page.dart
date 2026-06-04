import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/search_record_model.dart';
import '../services/firestore_service.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  String _selectedPeriod = '30 days';

  int _daysFromPeriod() {
    switch (_selectedPeriod) {
      case '7 days': return 7;
      case '30 days': return 30;
      case '90 days': return 90;
      case '1 year': return 365;
      default: return 30;
    }
  }

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
            "Monitor",
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
      body: StreamBuilder<List<SearchRecordModel>>(
        stream: FirestoreService().getSearchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allRecords = snapshot.data ?? [];
          final cutoff = DateTime.now().subtract(Duration(days: _daysFromPeriod()));
          final records = allRecords.where((r) => r.timestamp.isAfter(cutoff)).toList();

          // STATS
          final totalScans = records.length;
          final totalScams = records.where((r) {
            final detail = r.detail;
            return detail['is_scam'] == true || detail['verdict'] == 'SCAM';
          }).length;
          final totalSafe = totalScans - totalScams;
          final phoneScams = records.where((r) => r.type == 'phone' && (r.detail['is_scam'] == true)).length;
          final linkScams = records.where((r) => r.type == 'link' && (r.detail['is_scam'] == true)).length;
          final msgScams = records.where((r) => r.type == 'message' && (r.detail['is_scam'] == true)).length;
          final dangerous = records.where((r) => r.riskLevel == 'Dangerous').length;
          final warning = records.where((r) => r.riskLevel == 'Warning').length;

          // CHART DATA
          final chartData = _buildChartData(records);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20,120,20,120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CHART
                Text("Scam Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PERIOD SELECTOR beside title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Last 7 days",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey.shade100,
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   child: DropdownButton<String>(
                          //     value: _selectedPeriod,
                          //     underline: const SizedBox(),
                          //     isDense: true,
                          //     icon: const Icon(Icons.arrow_drop_down, size: 18),
                          //     items: ['7 days', '30 days', '90 days', '1 year'].map((p) {
                          //       return DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)));
                          //     }).toList(),
                          //     onChanged: (val) => setState(() => _selectedPeriod = val!),
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // BAR CHART
                      SizedBox(
                        height: 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: chartData.map((data) {
                            return _buildBar(data['day'], data['scam'], data['safe']);
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // LEGEND BELOW CHART
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem(Colors.red, "Scam"),
                          const SizedBox(width: 24),
                          _legendItem(Colors.green, "Safe"),
                          const SizedBox(width: 24),
                          _legendItem(Colors.orange, "Warning"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                 // SUMMARY CARDS
                Row(
                  children: [
                    _summaryCard("Total Scans", totalScans.toString(), Colors.blue, Icons.search),
                    const SizedBox(width: 12),
                    _summaryCard("Scams Found", totalScams.toString(), Colors.red, Icons.warning),
                    const SizedBox(width: 12),
                    _summaryCard("Safe", totalSafe.toString(), Colors.green, Icons.check_circle),
                  ],
                ),

                const SizedBox(height: 24),

                // INSIGHTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Insights",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildInsightCard(
                  icon: Icons.phone,
                  iconColor: Colors.orange,
                  title: "Phone Scams",
                  value: phoneScams.toString(),
                  subtitle: "Scam calls detected",
                  onTap: () => _showInsightDetails(context, "Phone Scams",
                    records.where((r) => r.type == 'phone').toList()),
                ),
                const SizedBox(height: 12),
                _buildInsightCard(
                  icon: Icons.link,
                  iconColor: Colors.blue,
                  title: "Malicious Links",
                  value: linkScams.toString(),
                  subtitle: "Dangerous URLs found",
                  onTap: () => _showInsightDetails(context, "Malicious Links",
                    records.where((r) => r.type == 'link').toList()),
                ),
                const SizedBox(height: 12),
                _buildInsightCard(
                  icon: Icons.message,
                  iconColor: Colors.purple,
                  title: "Scam Messages",
                  value: msgScams.toString(),
                  subtitle: "Spam messages detected",
                  onTap: () => _showInsightDetails(context, "Scam Messages",
                    records.where((r) => r.type == 'message').toList()),
                ),
                const SizedBox(height: 12),
                _buildInsightCard(
                  icon: Icons.warning_amber,
                  iconColor: Colors.red,
                  title: "High Risk",
                  value: dangerous.toString(),
                  subtitle: "Dangerous risk level",
                  onTap: () => _showInsightDetails(context, "High Risk",
                    records.where((r) => r.riskLevel == 'Dangerous').toList()),
                ),
                const SizedBox(height: 12),
                _buildInsightCard(
                  icon: Icons.error_outline,
                  iconColor: Colors.orange,
                  title: "Warning",
                  value: warning.toString(),
                  subtitle: "Medium risk level",
                  onTap: () => _showInsightDetails(context, "Warning",
                    records.where((r) => r.riskLevel == 'Warning').toList()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _buildChartData(List<SearchRecordModel> records) {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final dayRecords = records.where((r) =>
        r.timestamp.year == day.year &&
        r.timestamp.month == day.month &&
        r.timestamp.day == day.day
      ).toList();

      final scam = dayRecords.where((r) => r.detail['is_scam'] == true || r.detail['verdict'] == 'SCAM').length;
      final safe = dayRecords.length - scam;

      return {
        'day': _dayLabel(day.weekday),
        'scam': scam,
        'safe': safe,
      };
    });
  }

  String _dayLabel(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  Widget _summaryCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildBar(String day, int scam, int safe) {
    const maxHeight = 130.0;
    final maxVal = (scam + safe) == 0 ? 1 : (scam + safe);
    final scamH = (scam / maxVal) * maxHeight;
    final safeH = (safe / maxVal) * maxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 18,
              height: scamH.clamp(2.0, maxHeight),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 4),
            Container(
              width: 18,
              height: safeH.clamp(2.0, maxHeight),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showInsightDetails(BuildContext context, String title, List<SearchRecordModel> records) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsightDetailPage(
          title: title,
          records: records,
        ),
      ),
    );
  }
}

class InsightDetailPage extends StatelessWidget {
  final String title;
  final List<SearchRecordModel> records;

  const InsightDetailPage({
    super.key,
    required this.title,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    "No records found",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                final isScam = r.detail['is_scam'] == true || r.detail['verdict'] == 'SCAM';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isScam ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            r.type == 'phone' ? Icons.phone
                              : r.type == 'link' ? Icons.link
                              : Icons.message,
                            color: isScam ? Colors.red : Colors.green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.value,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: r.riskLevel == 'Dangerous'
                                          ? Colors.red.withOpacity(0.1)
                                          : r.riskLevel == 'Warning'
                                              ? Colors.orange.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      r.riskLevel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: r.riskLevel == 'Dangerous'
                                            ? Colors.red
                                            : r.riskLevel == 'Warning'
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Risk: ${r.riskScore}",
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${r.timestamp.day}/${r.timestamp.month}/${r.timestamp.year}",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isScam ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isScam ? "SCAM" : "SAFE",
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}