import 'package:ScamTap/models/scam_model.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';

class ScanningPage extends StatefulWidget {
  final String inputText;
  final String inputType;
  final Function(Map<String, dynamic>?)? onResult;

  const ScanningPage({
    super.key,
    required this.inputText,
    required this.inputType,
    this.onResult,
  });

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  List<ScanStep> scanSteps = [
    ScanStep(title: "Test Analysis", status: ScanStatus.pending),
    ScanStep(title: "Link extracted", status: ScanStatus.pending),
    ScanStep(title: "Scan line reputation", status: ScanStatus.pending),
    ScanStep(title: "Checking sender number", status: ScanStatus.pending),
    ScanStep(title: "Calculating risk score", status: ScanStatus.pending),
  ];

  int currentStep = 0;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() async {
    final fetchFuture = fetchData(widget.inputText);

    for (int i = 0; i < scanSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          scanSteps[i].status = ScanStatus.complete;
          currentStep = i + 1;
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => isComplete = true);

      final result = await fetchFuture;
      widget.onResult?.call(result);

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScamreportPage(
              result    : result,
              inputText : widget.inputText,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scanning",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.green.shade50,
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.inputType == "Call" 
                                  ? Icons.phone 
                                  : Icons.link,
                              color: Colors.green.shade700,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Analyzing ${widget.inputType}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  widget.inputText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Scanning Animation
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Analysis Content",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Around 20 seconds... please wait",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Scan Steps
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < scanSteps.length; i++)
                        _buildScanStep(scanSteps[i], i),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Please don't close this page while scanning is in progress",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanStep(ScanStep step, int index) {
    Color textColor;
    IconData? icon;
    Color iconColor;

    switch (step.status) {
      case ScanStatus.complete:
        textColor = Colors.green;
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case ScanStatus.pending:
        textColor = Colors.grey;
        icon = Icons.hourglass_empty;
        iconColor = Colors.grey;
        break;
      case ScanStatus.error:
        textColor = Colors.red;
        icon = Icons.error;
        iconColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: step.status == ScanStatus.complete
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ),
          if (step.status == ScanStatus.complete)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "done",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum ScanStatus {
  pending,
  complete,
  error,
}

class ScanStep {
  final String title;
  ScanStatus status;

  ScanStep({
    required this.title,
    required this.status,
  });
}