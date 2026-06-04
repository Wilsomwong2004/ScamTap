import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static Future<List<NewsModel>> fetchNews() async {
    String newsDataAPI = dotenv.env['NEWS_DATA_API_KEY'] ?? '';

    try {
      final uri = Uri.parse(
        'https://newsdata.io/api/1/news?apikey=$newsDataAPI&q=scam+malaysia&language=en&category=crime',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
