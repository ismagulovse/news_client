import 'package:flutter/foundation.dart';

import '../data/news_repository.dart';
import '../data/news_error.dart';
import '../data/news_store.dart';
import '../models/article.dart';

class NewsState extends ChangeNotifier {
  final NewsRepository newsRepo;
  final store = NewsStore();
  List<Article> news = [];
  bool loading = false;
  bool hasMore = true;
  bool cached = false;
  bool closed = false;
  int page = 1;
  String category = 'general';
  String searchText = '';
  String error = '';
  String moreError = '';

  NewsState(this.newsRepo);

  void update() {
    if (!closed) notifyListeners();
  }

  Future<void> filter(String newCategory, String newSearch) async {
    if (loading) return;
    category = newCategory;
    searchText = newSearch.trim();
    news = [];
    cached = false;
    page = 1;
    hasMore = true;
    await loadNews();
  }

  Future<void> loadNews() async {
    if (loading) return;
    loading = true;
    error = '';
    moreError = '';
    update();
    try {
      final newNews = await newsRepo.getNews(category: category, searchText: searchText);
      news = [];
      addNews(newNews);
      page = 1;
      cached = false;
      hasMore = newNews.length == 10;
      await saveCache();
    } catch (e) {
      error = 'новости не загрузились';
      if (e is NewsError) error = e.message;
      if (news.isEmpty) await loadCache();
    }
    loading = false;
    update();
  }

  Future<void> loadMore() async {
    if (loading || !hasMore || cached || news.isEmpty) return;
    loading = true;
    moreError = '';
    update();
    try {
      final newNews = await newsRepo.getNews(
        page: page + 1,
        category: category,
        searchText: searchText,
      );

      addNews(newNews);
      page++;
      hasMore = newNews.length == 10 && page < 100;
      await saveCache();
    } catch (e) {
      moreError = 'Не удалось загрузить следующую страницу';
      if (e is NewsError) moreError = e.message;
    }
    loading = false;
    update();
  }

  void addNews(List<Article> newNews) {
    for (final article in newNews) {
      if (article.url.isEmpty) continue;
      bool exists = false;
      for (final oldArticle in news) {
        if (oldArticle.url == article.url) {
          exists = true;
          break;
        }
      }
      if (!exists) news.add(article);
    }
  }

  Future<void> loadCache() async {
    try {
      news = await store.readCache(category, searchText);
      cached = news.isNotEmpty;
    } catch (e) {
      error += ' Кэш не прочитан';
    }
  }

  Future<void> saveCache() async {
    try {
      await store.saveCache(news, category, searchText);
    } catch (e) {
      error = 'Кэш не сохранен';
    }
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }
}
