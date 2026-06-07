import 'dart:convert';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';
import 'package:ScamTap/pages/free_users/bulk_scan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:ScamTap/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/widgets/animatedhinttextfield.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/pages/free_users/scanning_page.dart';
import 'package:ScamTap/services/premium_service.dart';

import '../../widgets/scamdetectedcolorcontainer.dart';

class LookupPage extends StatefulWidget {
  const LookupPage({super.key});

  @override
  State<LookupPage> createState() => _LookupPageState();
}

class _LookupPageState extends State<LookupPage> {
  bool _showResult = false;
  Map<String, dynamic>? _resultData;
  bool _isInitialized = false;
  String _selectedFilter = 'Call';
  final _cacheService = CacheService();
  bool _isPremium = false;
  int _remainingScans = 0;
  
  final TextEditingController _inputController = TextEditingController();
  String _currentInputType = 'Call';

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
    final resultData = await _cacheService.getResult('last_result_lookup');
    if (resultData != null) {
      setState(() {
        _resultData = resultData;
        _showResult = true;
      });
    }
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _saveResult(Map<String, dynamic> data) async {
    await _cacheService.saveResult('last_result_lookup', data);
  }

  void _showPremiumLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: const Text('You have used your 5 free scans today. Upgrade to Premium for unlimited scans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumPurchasePage()),
              );
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndStartScan(String inputText, String inputType) async {
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a number or link to scan')),
      );
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
      MaterialPageRoute(
        builder: (context) => ScanningPage(
          inputText: inputText,
          inputType: inputType,
        ),
      ),
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
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Lookup",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
              ),
            ),
            if (_isPremium)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                child: const Text('PREMIUM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
          ],
        ),
        actions: [
          if (_isPremium)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BulkScanPage()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.queue, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Bulk', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFC940), Color(0xFFFF9500)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15),
                    const SizedBox(width: 4),
                    Text(_isPremium ? 'PREMIUM' : 'PRO', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Miniprofile())),
              child: const CircleAvatar(backgroundColor: Color.fromARGB(255, 55, 126, 57), child: Icon(Icons.person, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, const Color.fromARGB(255, 199, 199, 199)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: kToolbarHeight + 55, bottom: 100),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Verify Number / Link", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    AnimatedHintTextField(
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
                              'Scans remaining today',
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
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.green),
                            ),
                            Text(
                              'Unlimited Scans',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BulkScanPage())),
                          icon: const Icon(Icons.queue),
                          label: const Text('Bulk Scan (Phone Numbers and Links)'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.green.shade700,
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
                    : _showResult
                        ? ScamDetectedColorContainer(key: const ValueKey('result'), result: _resultData)
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              SizedBox(height: _showResult ? 25 : 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: const Text("Recent Lookup", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilterSelection(
                  selected: _selectedFilter,
                  onChanged: (val) => setState(() {
                    _selectedFilter = val;
                    _currentInputType = val;
                  }),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<SearchRecordModel>>(
                stream: FirestoreService().getSearchHistory(),
                builder: (context, snapshot) {
                  final allRecords = snapshot.data ?? [];
                  final records = allRecords.where((r) {
                    if (_selectedFilter == 'Call') return r.type == 'phone';
                    if (_selectedFilter == 'Link') return r.type == 'link';
                    return true;
                  }).toList();

                  if (snapshot.connectionState == ConnectionState.waiting && allRecords.isEmpty) {
                    return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: Colors.white)));
                  }

                  if (records.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, color: Colors.white70, size: 30),
                          const SizedBox(height: 5),
                          Text(
                            allRecords.isEmpty ? "No record found" : "No ${_selectedFilter == 'Call' ? 'phone' : 'link'} records found",
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
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
                                      CircleAvatar(
                                        backgroundColor: const Color.fromARGB(255, 44, 106, 46),
                                        child: Icon(record.type == 'phone' ? Icons.phone : Icons.link, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(record.value, style: const TextStyle(fontSize: 14)),
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

class FilterSelection extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  const FilterSelection({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final icons = {"Call": Icons.phone, "Link": Icons.link};
    return Row(
      children: ["Call", "Link"].map((label) {
        final isActive = selected == label;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color.fromARGB(255, 44, 106, 46) : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(icons[label], size: 16, color: isActive ? Colors.white : const Color.fromARGB(255, 44, 106, 46)),
                  const SizedBox(width: 6),
                  Text(label, style: TextStyle(color: isActive ? Colors.white : const Color.fromARGB(255, 44, 106, 46), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}