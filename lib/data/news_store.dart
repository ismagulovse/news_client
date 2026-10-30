import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

// Храним только последнюю ленту и отдельно избранное.
class NewsStore {
  Future<List<Article>> read(String key) 
  async {
    final storage = await SharedPreferences.getInstance();
    final text = storage.getString(key);
  
    if (text == null) return [];
    
    final data = jsonDecode(text) as List;
    final news = <Article>[];
    for (final item in data) 
    {
      news.add(Article.fromJson(item));
    }
    return news;
  }

  Future<void> save(String key, List<Article> news) async {
    final storage = await SharedPreferences.getInstance();
    final data = <Map<String, dynamic>>[];
    for (final article in news) {
      data.add(article.toJson());
    }
    final saved = await storage.setString(key, jsonEncode(data));
    if (!saved) throw Exception('Данные не сохранились');
  }

  Future<List<Article>> readCache(String category, String searchText) async 
  {
    final storage = await SharedPreferences.getInstance();
    if (storage.getString('cache_filter') != jsonEncode([category, searchText])) 
    {
      return [];
    }
    return read('cache');
  }

  Future<void> saveCache(
    List<Article> news,
    String category,
    String searchText,
  ) async 
  {
    final storage = await SharedPreferences.getInstance();
    await storage.remove('cache_filter');
    await save('cache', news);
    await storage.setString('cache_filter', jsonEncode([category, searchText]));
  }
}
