import 'package:flutter/material.dart';
import 'package:ScamTap/services/scam_service.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:share_plus/share_plus.dart';

class BulkScanPage extends StatefulWidget {
  final String? scanType;
  
  const BulkScanPage({super.key, this.scanType});

  @override
  State<BulkScanPage> createState() => _BulkScanPageState();
}

class _BulkScanPageState extends State<BulkScanPage> {
  final TextEditingController _inputController = TextEditingController();
  bool _isScanning = false;
  List<BulkItem> _items = [];
  int _currentIndex = 0;
  int _completedScans = 0;
  int _scamCount = 0;
  int _safeCount = 0;
  int _phoneCount = 0;
  int _linkCount = 0;
  int _messageCount = 0;

  String get _title {
    switch (widget.scanType) {
      case 'phone':
        return 'Bulk Scan - Phone Numbers';
      case 'link':
        return 'Bulk Scan - Links';
      case 'message':
        return 'Bulk Scan - Messages';
      default:
        return 'Bulk Scan';
    }
  }

  String get _hintText {
    switch (widget.scanType) {
      case 'phone':
        return '+60123456789\n0123456789\n+60111222333';
      case 'link':
        return 'https://example.com\nwww.suspicious-site.com\nhttp://fake-bank.com';
      case 'message':
        return 'Your account has been suspended\nYou won a prize\nYour parcel is stuck';
      default:
        return '+60123456789\nhttps://example.com\n0123456789\nYour account has been suspended';
    }
  }

  String get _infoText {
    switch (widget.scanType) {
      case 'phone':
        return 'Enter phone numbers, one per line. Each number will be scanned for scam indicators.';
      case 'link':
        return 'Enter website links or URLs, one per line. Each link will be checked for malicious activity.';
      case 'message':
        return 'Enter text messages, one per line. Each message will be analyzed for scam patterns.';
      default:
        return 'Enter phone numbers and links, one per line. Each item will be scanned automatically.';
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _parseAndStart() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter ${widget.scanType == 'message' ? 'messages' : 'items'} to scan')),
      );
      return;
    }

    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No valid entries found')));
      return;
    }

    final items = <BulkItem>[];
    for (var line in lines) {
      final trimmed = line.trim();
      
      if (widget.scanType == 'message') {
        items.add(BulkItem(value: trimmed, type: 'message', status: BulkStatus.pending));
      } else if (widget.scanType == 'phone') {
        items.add(BulkItem(value: trimmed, type: 'phone', status: BulkStatus.pending));
      } else if (widget.scanType == 'link') {
        items.add(BulkItem(value: trimmed, type: 'link', status: BulkStatus.pending));
      } else {
        final isPhone = RegExp(r'^[0-9+\-\s().]{7,}$').hasMatch(trimmed);
        final isLink = trimmed.startsWith('http') || trimmed.startsWith('www') || trimmed.contains('.');
        
        if (isPhone) {
          items.add(BulkItem(value: trimmed, type: 'phone', status: BulkStatus.pending));
        } else if (isLink) {
          items.add(BulkItem(value: trimmed, type: 'link', status: BulkStatus.pending));
        }
      }
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No valid ${widget.scanType == 'message' ? 'messages' : 'items'} found')),
      );
      return;
    }

    setState(() {
      _items = items;
      _isScanning = true;
      _currentIndex = 0;
      _completedScans = 0;
      _scamCount = 0;
      _safeCount = 0;
      _phoneCount = items.where((i) => i.type == 'phone').length;
      _linkCount = items.where((i) => i.type == 'link').length;
      _messageCount = items.where((i) => i.type == 'message').length;
    });
    _startBatchScan();
  }

  Future<void> _startBatchScan() async {
    for (int i = 0; i < _items.length; i++) {
      setState(() {
        _currentIndex = i;
        _items[i].status = BulkStatus.scanning;
      });
      try {
        final result = await fetchData(_items[i].value);
        final isScam = result['is_scam'] ?? false;
        setState(() {
          _items[i].result = result;
          _items[i].status = BulkStatus.complete;
          _completedScans++;
          isScam ? _scamCount++ : _safeCount++;
        });
      } catch (e) {
        setState(() {
          _items[i].status = BulkStatus.error;
          _completedScans++;
        });
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() => _isScanning = false);
  }

  void _viewResult(BulkItem item) {
    if (item.result != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScamreportPage(result: item.result, inputText: item.value)));
    }
  }

  void _exportResults() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('BULK SCAN RESULTS');
      buffer.writeln('Date: ${DateTime.now()}');
      buffer.writeln('Scan Type: $_title');
      buffer.writeln('');
      buffer.writeln('SUMMARY:');
      buffer.writeln('Total Items: ${_items.length}');
      if (_phoneCount > 0) buffer.writeln('Phone Numbers: $_phoneCount');
      if (_linkCount > 0) buffer.writeln('Links: $_linkCount');
      if (_messageCount > 0) buffer.writeln('Messages: $_messageCount');
      buffer.writeln('Scams Detected: $_scamCount');
      buffer.writeln('Safe Items: $_safeCount');
      buffer.writeln('');
      buffer.writeln('DETAILS:');
      buffer.writeln('Value,Type,Risk Level');
      
      for (var item in _items) {
        if (item.status == BulkStatus.complete && item.result != null) {
          final isScam = item.result!['is_scam'] ?? false;
          buffer.writeln('"${item.value}",${item.type},${isScam ? "SCAM" : "SAFE"}');
        }
      }
      await Share.share(buffer.toString());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to export results')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMessageMode = widget.scanType == 'message';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: isMessageMode ? const Color.fromARGB(255, 76, 102, 175) : Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (!_isScanning && _items.isNotEmpty)
            TextButton.icon(
              onPressed: () => setState(() { _items.clear(); _inputController.clear(); _phoneCount = 0; _linkCount = 0; _messageCount = 0; }),
              icon: const Icon(Icons.clear, color: Colors.white),
              label: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: (!_isScanning && _items.isEmpty)
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMessageMode ? Colors.blue.shade50 : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isMessageMode ? Colors.blue.shade200 : Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(isMessageMode ? Icons.message : Icons.info, color: isMessageMode ? Colors.blue : Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_infoText, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Enter ${widget.scanType == 'message' ? 'Messages' : 'Items'} to Scan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _inputController,
                      maxLines: 12,
                      decoration: InputDecoration(
                        hintText: _hintText,
                        hintStyle: TextStyle(fontSize: isMessageMode ? 12 : 13, color: Colors.grey.shade400),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _parseAndStart,
                      icon: const Icon(Icons.play_arrow),
                      label: Text('Start Bulk Scan', style: const TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMessageMode ? const Color.fromARGB(255, 76, 102, 175) : Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isMessageMode 
                        ? const LinearGradient(colors: [Color.fromARGB(255, 76, 102, 175), Color.fromARGB(255, 100, 130, 200)])
                        : const LinearGradient(colors: [Colors.green, Colors.teal]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Total', _items.length.toString(), Colors.white),
                          _buildStatCard('Done', _completedScans.toString(), Colors.white.withOpacity(0.2)),
                          _buildStatCard('Scams', _scamCount.toString(), Colors.red.shade100),
                          _buildStatCard('Safe', _safeCount.toString(), Colors.green.shade100),
                        ],
                      ),
                      if (!isMessageMode && (_phoneCount > 0 || _linkCount > 0)) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_phoneCount > 0) _buildTypeBadge('Phone', _phoneCount),
                            if (_phoneCount > 0 && _linkCount > 0) const SizedBox(width: 16),
                            if (_linkCount > 0) _buildTypeBadge('Link', _linkCount),
                          ],
                        ),
                      ],
                      if (_isScanning) ...[
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: _completedScans / _items.length,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text('Scanning ${_currentIndex + 1} of ${_items.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) => _buildResultCard(_items[index], index, isMessageMode),
                  ),
                ),
                if (!_isScanning && _items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _exportResults,
                        icon: const Icon(Icons.share),
                        label: const Text('Share Results'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bgColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Text(label, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)), const SizedBox(width: 4), Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildResultCard(BulkItem item, int index, bool isMessageMode) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (item.status) {
      case BulkStatus.pending:
        statusColor = Colors.grey;
        statusIcon = Icons.pending;
        statusText = 'Pending';
        break;
      case BulkStatus.scanning:
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        statusText = 'Scanning';
        break;
      case BulkStatus.complete:
        final isScam = item.result?['is_scam'] ?? false;
        statusColor = isScam ? Colors.red : Colors.green;
        statusIcon = isScam ? Icons.warning : Icons.check_circle;
        statusText = isScam ? 'Scam' : 'Safe';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.error;
        statusText = 'Error';
    }
    
    IconData typeIcon;
    Color typeColor;
    switch (item.type) {
      case 'phone':
        typeIcon = Icons.phone;
        typeColor = Colors.green;
        break;
      case 'link':
        typeIcon = Icons.link;
        typeColor = Colors.blue;
        break;
      default:
        typeIcon = Icons.message;
        typeColor = Colors.purple;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: item.status == BulkStatus.complete ? () => _viewResult(item) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: typeColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(typeIcon, color: typeColor, size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${index + 1}. ${item.value}', style: const TextStyle(fontWeight: FontWeight.w500), maxLines: isMessageMode ? 2 : 1, overflow: TextOverflow.ellipsis),
                Text(item.type == 'phone' ? 'Phone Number' : item.type == 'link' ? 'Website Link' : 'Text Message', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(statusIcon, color: statusColor, size: 12), const SizedBox(width: 4), Text(statusText, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w500))]),
              ),
              if (item.status == BulkStatus.complete) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class BulkItem {
  final String value;
  final String type;
  BulkStatus status;
  Map<String, dynamic>? result;
  BulkItem({required this.value, required this.type, required this.status, this.result});
}

enum BulkStatus { pending, scanning, complete, error }