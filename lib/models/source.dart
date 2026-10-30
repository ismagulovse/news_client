class Source {
  final String name;
  final String url;

  Source({required this.name, required this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(name: json['name'] ?? '', url: json['url'] ?? '');
  }
}
