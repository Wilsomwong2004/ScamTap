import 'dart:convert';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';
import 'package:ScamTap/pages/free_users/bulk_scan_page.dart';
import 'package:ScamTap/widgets/scamdetectedcolorcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ScamTap/widgets/animatedhinttextfield.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/pages/free_users/scanning_page.dart';
import 'package:ScamTap/services/premium_service.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _showResult = false;
  Map<String, dynamic>? _resultData;
  bool _isInitialized = false;
  bool _isPremium = false;
  int _remainingScans = 0;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastResult();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final isPremium = await PremiumService.isPremium();
    final remaining = await PremiumService.getRemainingScans();
    setState(() {
      _isPremium = isPremium;
      _remainingScans = remaining;
    });
  }

  Future<void> _loadLastResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('last_result_message');
    if (saved != null) {
      setState(() {
        _resultData = jsonDecode(saved);
        _showResult = true;
      });
    }
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _saveResult(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_result_message', jsonEncode(data));
  }

  void _showPremiumLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: const Text('You have used your 5 free message scans today. Upgrade to Premium for unlimited scans.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Maybe Later')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage()));
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndStartScan(String inputText) async {
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a message to scan')));
      return;
    }
    
    final isPremium = await PremiumService.isPremium();
    final remaining = await PremiumService.getRemainingScans();
    
    if (!isPremium && remaining <= 0) {
      _showPremiumLimitDialog();
      return;
    }
    
    await PremiumService.incrementScanCount();
    
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanningPage(inputText: inputText, inputType: "Message")),
    );
    
    await _loadPremiumStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 8), child: Text("Message", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white))),
            if (_isPremium) Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)), child: const Text('PREMIUM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))),
          ],
        ),
        actions: [
          if (_isPremium)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BulkScanPage(scanType: 'message'))),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Row(children: [Icon(Icons.queue, color: Colors.white, size: 14), SizedBox(width: 4), Text('Bulk', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))]),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFC940), Color(0xFFFF9500)]), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15), const SizedBox(width: 4), Text(_isPremium ? 'PREMIUM' : 'PRO', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Miniprofile())),
              child: const CircleAvatar(backgroundColor: Color.fromARGB(255, 44, 51, 106), child: Icon(Icons.person, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color.fromARGB(255, 76, 102, 175), const Color.fromARGB(255, 199, 199, 199)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: kToolbarHeight + 55, bottom: 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Verify Message", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    AnimatedHintTextField(
                      isMessage: true,
                      controller: _inputController,
                      onRefreshRequired: () {
                        _loadPremiumStatus();
                      },
                      onResultRecieved: (bool hasResult, Map<String, dynamic>? data) async {
                        if (hasResult && data != null) await _saveResult(data);
                        setState(() {
                          _showResult = hasResult;
                          _resultData = data;
                        });
                      },
                    ),
                    
                    if (!_isPremium) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: _remainingScans <= 0 ? Colors.red.shade100 : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Message scans remaining today',
                              style: TextStyle(
                                fontSize: 13,
                                color: _remainingScans <= 0 ? Colors.red.shade800 : Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              '$_remainingScans',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _remainingScans <= 0 ? Colors.red.shade800 : Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_remainingScans <= 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.red, size: 16),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'You have reached your daily limit',
                                  style: TextStyle(fontSize: 12, color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage()));
                                },
                                child: const Text('Upgrade', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    
                    if (_isPremium) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Premium Plan',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.blue),
                            ),
                            Text(
                              'Unlimited Scans',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 15),
                    
                    if (_isPremium) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BulkScanPage(scanType: 'message'))),
                          icon: const Icon(Icons.queue),
                          label: const Text('Bulk Scan (Multiple Messages)'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: const Color.fromARGB(255, 76, 102, 175),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 15),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: !_isInitialized
                    ? const SizedBox.shrink(key: ValueKey('loading'))
                    : _showResult                        ? ScamDetectedColorContainer(key: const ValueKey('result'), result: _resultData)
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              SizedBox(height: _showResult ? 25 : 10),

            
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(width: double.infinity, child: const Text("Recent Message", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white))),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<SearchRecordModel>>(
                stream: FirestoreService().getSearchHistory(),
                builder: (context, snapshot) {
                  final allRecords = snapshot.data ?? [];
                  final records = allRecords.where((r) => r.type == 'message').toList();

                  if (snapshot.connectionState == ConnectionState.waiting && allRecords.isEmpty) {
                    return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: Colors.white)));
                  }

                  if (allRecords.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(children: [Icon(Icons.warning_rounded, color: Colors.red, size: 30), SizedBox(height: 5), Text("No record found", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))]),
                    );
                  }

                  if (records.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(children: [Icon(Icons.search_off_rounded, color: Colors.white70, size: 30), SizedBox(height: 5), Text("No message records found", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))]),
                    );
                  }

                  return Column(
                    children: records.map((record) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Material(
                          color: const Color.fromARGB(255, 233, 247, 235),
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScamreportPage(result: record.rawData ?? {}, inputText: record.value))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(backgroundColor: Color.fromARGB(255, 44, 51, 106), child: Icon(Icons.message, color: Colors.white)),
                                      const SizedBox(width: 12),
                                      SizedBox(width: 160, child: Text(record.value, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: record.riskLevel == 'Dangerous' ? Colors.red.shade700 : record.riskLevel == 'Warning' ? Colors.orange.shade700 : const Color.fromARGB(255, 78, 114, 84),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Text(record.riskLevel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}