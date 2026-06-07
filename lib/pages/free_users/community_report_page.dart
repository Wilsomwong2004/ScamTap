import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';

class CommunityReportPage extends StatelessWidget {
  const CommunityReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Reports',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () => _showReportDialog(context),
            tooltip: 'Report a Scam',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scam_reports')
            .where('reportStatus', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.report_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No approved reports yet'),
                  SizedBox(height: 8),
                  Text('Be the first to report a scam!'),
                ],
              ),
            );
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final data = report.data() as Map<String, dynamic>;
              return _buildReportCard(context, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, dynamic> data) {
    // Get the value from either reportedNumber or reportedLink
    String value = data['reportedNumber'] ?? data['reportedLink'] ?? '';
    if (value.isEmpty) {
      value = data['reportDescription'] ?? 'Unknown';
    }
    
    String scamType = data['scamType'] ?? 'Unknown';
    String description = data['reportDescription'] ?? 'No description';
    String reportedBy = data['reportBy'] ?? 'Anonymous';
    
    // Determine icon and color
    IconData typeIcon;
    Color riskColor;
    
    if (scamType.toLowerCase().contains('call') || scamType.toLowerCase().contains('phone')) {
      typeIcon = Icons.phone;
      riskColor = Colors.red;
    } else if (scamType.toLowerCase().contains('link')) {
      typeIcon = Icons.link;
      riskColor = Colors.orange;
    } else {
      typeIcon = Icons.message;
      riskColor = Colors.purple;
    }

    Timestamp? reportDate = data['reportDate'] as Timestamp?;
    DateTime date = reportDate?.toDate() ?? DateTime.now();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScamreportPage(
              result: {'is_scam': true, 'type': scamType},
              inputText: value,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: riskColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(typeIcon, size: 16, color: riskColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SCAM',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: riskColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      reportedBy,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final valueController = TextEditingController();
    String selectedType = 'phone';
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Scam'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'phone', child: Text('Phone Number')),
                  DropdownMenuItem(value: 'link', child: Text('Link / URL')),
                  DropdownMenuItem(value: 'message', child: Text('Message')),
                ],
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: selectedType == 'phone' ? 'Phone Number' : 
                             selectedType == 'link' ? 'Link / URL' : 
                             'Message Content',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (valueController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a value')),
                );
                return;
              }

              final user = FirebaseAuth.instance.currentUser;
              
              await FirebaseFirestore.instance.collection('scam_reports').add({
                'reportBy': user?.displayName ?? user?.email ?? 'Anonymous',
                'reportDate': FieldValue.serverTimestamp(),
                'reportDescription': descriptionController.text,
                'reportStatus': 'Pending',
                'reportedNumber': selectedType == 'phone' ? valueController.text : '',
                'reportedLink': selectedType == 'link' ? valueController.text : '',
                'riskLevel': 5,
                'scamType': selectedType == 'phone' ? 'Phone Call' : selectedType == 'link' ? 'Malicious Link' : 'Scam Message',
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report submitted! Pending admin approval.')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}