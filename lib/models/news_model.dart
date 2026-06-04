import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsModel {
  final String title;
  final String source;
  final String pubDate;
  final String link;
  final String description;

  const NewsModel({
    required this.title,
    required this.source,
    required this.pubDate,
    required this.link,
    required this.description,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title       : map['title']       ?? '',
      source      : map['source_id']   ?? '',
      pubDate     : map['pubDate']     ?? '',
      link        : map['link']        ?? '',
      description : map['description'] ?? '',
    );
  }

  static Future<List<NewsModel>> fetchNews() async {
    String NewsDataAPI= dotenv.env['NEWS_DATA_API_KEY'] ?? '';

    try {
      final uri = Uri.parse(
        'https://newsdata.io/api/1/news?apikey=$NewsDataAPI&q=scam+malaysia&language=en&category=crime',
      );
      final response = await http.get(uri);
      // print('STATUS: ${response.statusCode}');
      // print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('STATUS FIELD: ${data['status']}');
        // print('RESULTS: ${data['results']}');

        final List articles = data['results'] ?? [];
        return articles.take(5).map((a) => NewsModel.fromMap(a)).toList();
      }
      return [];
    } catch (e) {
      print('ERROR: $e');
      return [];
    }
  }
}