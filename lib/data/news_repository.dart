import '../models/article.dart';
import 'news_api.dart';

class NewsRepository {
  final api = NewsApi();

  Future<List<Article>> getNews({ int page = 1, String category = 'general', String searchText = '',}) 
  async {
    final data = await api.getNews
    (
      page: page,
      category: category,
      searchText: searchText,
    );
    final news = <Article>[];
    for (final item in data) 
    {
      news.add(Article.fromJson(item));
    }
    return news;
  }
}
