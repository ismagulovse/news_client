import 'source.dart';

class Article {
  final String title;
  final String text;
  final String content;
  final String image;
  final String url;
  final DateTime? date;
  final Source source;

  Article({
    required this.title,
    required this.text,
    this.content = '',
    required this.image,
    required this.url,
    required this.date,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) 
  {
    return Article(
      title: json['title'] ?? '',
      text: json['description'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      date: DateTime.tryParse(json['publishedAt'] ?? ''),
      source: Source.fromJson(json['source'] ?? {}),
    );
  }

  String get dateText 
  {
    final localDate = date?.toLocal();
    if (localDate == null) return '';
    return '${localDate.day}.${localDate.month}.${localDate.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': text,
      'content': content,
      'image': image,
      'url': url,
      'publishedAt': date?.toIso8601String(),
      'source': {'name': source.name, 'url': source.url},
    };
  }
}
