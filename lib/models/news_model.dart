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
}