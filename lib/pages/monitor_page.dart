import 'package:flutter/material.dart';

class MonitorPage extends StatelessWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Monitor",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Show filter options
                _showFilterDialog(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Record Period Selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: '30 days',
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: ['7 days', '30 days', '90 days', '1 year']
                        .map((String period) {
                      return DropdownMenuItem<String>(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Update the chart data based on selected period
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chart Section
            Text(
              "Chart",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // Chart Container
            Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(16),
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
                  // Chart Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildLegendItem(Colors.red, "Scams Detected"),
                      const SizedBox(width: 16),
                      _buildLegendItem(Colors.green, "Blocked"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Bar Chart
                  Expanded(
                    child: _buildBarChart(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // All Insights Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Insights",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showAllInsights(context);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Insights List
            _buildInsightCard(
              icon: Icons.warning,
              iconColor: Colors.red,
              title: "SMS Phishing Attempts",
              value: "12",
              change: "+3 this week",
              changeColor: Colors.red,
              onTap: () {
                _showInsightDetails(context, "SMS Phishing Attempts");
              },
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.phone,
              iconColor: Colors.orange,
              title: "Suspicious Calls",
              value: "8",
              change: "-2 this week",
              changeColor: Colors.green,
              onTap: () {
                _showInsightDetails(context, "Suspicious Calls");
              },
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.qr_code,
              iconColor: Colors.blue,
              title: "QR Code Scams",
              value: "3",
              change: "Same as last week",
              changeColor: Colors.grey,
              onTap: () {
                _showInsightDetails(context, "QR Code Scams");
              },
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.email,
              iconColor: Colors.purple,
              title: "Email Scams",
              value: "5",
              change: "+2 this week",
              changeColor: Colors.red,
              onTap: () {
                _showInsightDetails(context, "Email Scams");
              },
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.shopping_cart,
              iconColor: Colors.teal,
              title: "E-commerce Scams",
              value: "2",
              change: "Decreased",
              changeColor: Colors.green,
              onTap: () {
                _showInsightDetails(context, "E-commerce Scams");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    // Sample data for the bar chart
    final List<Map<String, dynamic>> weeklyData = [
      {'day': 'Mon', 'scams': 4, 'blocked': 3},
      {'day': 'Tue', 'scams': 6, 'blocked': 5},
      {'day': 'Wed', 'scams': 3, 'blocked': 2},
      {'day': 'Thu', 'scams': 7, 'blocked': 6},
      {'day': 'Fri', 'scams': 5, 'blocked': 4},
      {'day': 'Sat', 'scams': 2, 'blocked': 2},
      {'day': 'Sun', 'scams': 1, 'blocked': 1},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weeklyData.map((data) {
        return _buildBar(data['day'], data['scams'], data['blocked']);
      }).toList(),
    );
  }

  Widget _buildBar(String day, int scams, int blocked) {
    final maxHeight = 150.0;
    final scamsHeight = (scams / 8) * maxHeight;
    final blockedHeight = (blocked / 8) * maxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Scams bar
            Container(
              width: 20,
              height: scamsHeight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            // Blocked bar
            Container(
              width: 20,
              height: blockedHeight,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required Color changeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          change,
                          style: TextStyle(
                            fontSize: 10,
                            color: changeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filter Insights"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Last 7 days"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Last 30 days"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text("High Risk Only"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAllInsights(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("All Insights"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: const [
                ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text("SMS Phishing Attempts"),
                  subtitle: Text("12 attempts this month"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.orange),
                  title: Text("Suspicious Calls"),
                  subtitle: Text("8 calls detected"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.qr_code, color: Colors.blue),
                  title: Text("QR Code Scams"),
                  subtitle: Text("3 incidents reported"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showInsightDetails(BuildContext context, String insightType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(insightType),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detailed statistics for $insightType",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text("• Total incidents: 12"),
              const Text("• This week: 3"),
              const Text("• Previous week: 2"),
              const SizedBox(height: 16),
              const Text(
                "Recommendations:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text("• Be cautious of unknown messages"),
              const Text("• Never share personal information"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}