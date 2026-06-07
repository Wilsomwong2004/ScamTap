import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      String apiKey = dotenv.env['NEWS_DATA_API_KEY'] ?? '';
      
      if (apiKey.isEmpty) {
        setState(() {
          _error = 'API key not configured';
          _isLoading = false;
        });
        return;
      }

      final uri = Uri.parse(
        'https://newsdata.io/api/1/news?apikey=$apiKey&q=scam&language=en&country=my'
      );
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          final List articles = data['results'] ?? [];
          
          if (articles.isNotEmpty) {
            setState(() {
              _news = articles.take(5).cast<Map<String, dynamic>>().toList();
              _isLoading = false;
            });
            return;
          }
        }
      }
      
      setState(() {
        _error = 'No news available';
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _error = 'Failed to load news';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Recently';
    
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 7) {
        return '${date.day}/${date.month}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.grey.shade400, size: 40),
              const SizedBox(height: 8),
              Text(_error, style: TextStyle(color: Colors.grey.shade500)),
              const SizedBox(height: 8),
              TextButton(onPressed: _fetchNews, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    
    if (_news.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text('No scam news available', style: TextStyle(color: Colors.grey.shade500)),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25), // Same horizontal padding as scam alerts
      child: Column(
        children: _news.map((article) => _buildNewsCard(article)).toList(),
      ),
    );
  }
  
  Widget _buildNewsCard(Map<String, dynamic> article) {
    final String title = article['title'] ?? 'No title';
    final String description = article['description'] ?? 'No description';
    final String link = article['link'] ?? '';
    final String source = article['source_id'] ?? article['source_name'] ?? 'News Source';
    final String? pubDate = article['pubDate'];
    
    // Same risk color as scam alerts (red for scam news)
    final Color riskColor = Colors.red;
    
    return GestureDetector(
      onTap: () async {
        if (link.isNotEmpty) {
          final uri = Uri.parse(link);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // Same margin as scam alerts
        padding: const EdgeInsets.all(16), // Same padding as scam alerts
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Same border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: riskColor.withOpacity(0.2)), // Same border style
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row - same as scam alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.newspaper, size: 16, color: riskColor), // Same icon size
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 180, // Same width constraint
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
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
                    'SCAM NEWS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: riskColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Description row - same as scam alerts
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.article, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Footer row - same as scam alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    source,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatDate(pubDate),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}