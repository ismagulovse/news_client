import 'package:flutter/foundation.dart';

import '../data/news_store.dart';
import '../models/article.dart';

class FavoritesState extends ChangeNotifier {
  final NewsStore store;
  List<Article> news = [];
  bool busy = true;
  bool closed = false;
  String error = '';

  FavoritesState(this.store);

  bool contains(Article article) {
    for (final item in news) {
      if (item.url == article.url) return true;
    }
    return false;
  }

  Future<void> load() async {
    try {
      news = await store.read('favorites');
    } catch (e) {
      error = 'Не удалось открыть избранное';
    }
    busy = false;
    if (!closed) notifyListeners();
  }

  Future<void> toggle(Article article) async {
    if (busy || article.url.isEmpty) return;
    busy = true;
    error = '';
    notifyListeners();
    final newNews = List<Article>.from(news);
    if (contains(article)) {
      newNews.removeWhere((item) => item.url == article.url);
    } else {
      newNews.add(article);
    }
    try {
      await store.save('favorites', newNews);
      news = newNews;
    } catch (e) {
      error = 'Не удалось сохранить';
    }
    busy = false;
    if (!closed) notifyListeners();
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }
}
