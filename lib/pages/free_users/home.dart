import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/services/user_service.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';
import 'package:ScamTap/pages/free_users/all_scam_alert_page.dart';
import 'package:ScamTap/widgets/news_section.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onTabChange;
  const HomePage({super.key, this.onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await UserService.getUsername();
    if (mounted) setState(() => _username = name);
  }

  void _launchNewsUrl() async {
    final uri = Uri.parse('https://www.google.com/search?q=scam+news+malaysia');
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      print('Could not launch URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text("ScamTap", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFC940), Color(0xFFFF9500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFFFFC940).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15),
                    SizedBox(width: 4),
                    Text('PRO', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Miniprofile())),
              child: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<SearchRecordModel>>(
        stream: FirestoreService().getSearchHistory(),
        builder: (context, snapshot) {
          final records = snapshot.data ?? [];
          final now = DateTime.now();
          final weekRecords = records.where((r) => r.timestamp.isAfter(now.subtract(const Duration(days: 7)))).toList();
          final scamsThisWeek = weekRecords.where((r) {
            return r.rawData?['is_scam'] == true
                || r.detail['is_scam'] == true
                || r.detail['verdict'] == 'SCAM'
                || r.riskLevel == 'Dangerous';
          }).length;
          final progress = records.isEmpty ? 0.0 : (scamsThisWeek / records.length).clamp(0.0, 1.0);
          final latestScams = records.where((r) => r.detail['ai_analysis'] != null).take(4).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.only(top: kToolbarHeight + 50, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WELCOME
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome back,", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(
                        _username != null ? "$_username!" : "...",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),

                // SCAM PROTECTION CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red.shade50, Colors.orange.shade50],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.shield, color: Colors.red.shade700, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Scam Protection", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                                  Text("Active", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "$scamsThisWeek scam${scamsThisWeek == 1 ? '' : 's'} detected this week",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade300,
                            color: scamsThisWeek > 0 ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // QUICK ACTIONS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: _buildQuickActionCard(context, icon: Icons.search, label: "Verify\nMessage", color: Colors.blue.shade600, onTap: () => widget.onTabChange?.call(2))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildQuickActionCard(context, icon: Icons.call, label: "Lookup\nNumber", color: Colors.green.shade600, onTap: () => widget.onTabChange?.call(1))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildQuickActionCard(context, icon: Icons.bar_chart, label: "Monitor\nScams", color: Colors.orange.shade600, onTap: () => widget.onTabChange?.call(3))),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // LATEST SCAM ALERTS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Latest Scam Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllScamAlertsPage(records: records))),
                        child: Text("See All", style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))
                else if (latestScams.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Center(
                      child: Text(
                        "No scam records yet.\nStart scanning to see alerts here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: latestScams.map((record) {
                        final aiAnalysis = record.detail['ai_analysis'] as Map<String, dynamic>? ?? {};
                        final reason     = aiAnalysis['reason']     ?? 'No reason provided';
                        final confidence = aiAnalysis['confidence'] ?? 'low';

                        final Color riskColor = record.riskLevel == 'Dangerous'
                            ? Colors.red
                            : record.riskLevel == 'Warning' ? Colors.orange : Colors.green;

                        final IconData typeIcon = record.type == 'phone'
                            ? Icons.phone
                            : record.type == 'link' ? Icons.link : Icons.message;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ScamreportPage(result: record.rawData ?? {}, inputText: record.value),
                            )),
                            child: Container(
                              width: double.infinity,
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
                                      Expanded(
                                        child: Row(children: [
                                          Icon(typeIcon, size: 16, color: riskColor),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              record.value,
                                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: riskColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                        child: Text(record.riskLevel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: riskColor)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.grey.shade500),
                                      const SizedBox(width: 4),
                                      Expanded(child: Text(reason, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4))),
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
                                        child: Text("Confidence: $confidence", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
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
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 24),

                // SCAM NEWS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Latest Scam News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      TextButton(
                        onPressed: _launchNewsUrl,
                        child: Text("More", style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const NewsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700, height: 1.2)),
          ],
        ),
      ),
    );
  }
}