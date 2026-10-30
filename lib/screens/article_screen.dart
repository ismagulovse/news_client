import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../state/favorites_state.dart';
import '../widgets/favorite_button.dart';
import '../widgets/news_image.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;
  final FavoritesState favorites;

  const ArticleScreen({
    super.key,
    required this.article,
    required this.favorites,
  });

  Future<void> openSource(BuildContext context) async {
    try {
      final url = Uri.parse(article.url);
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) throw Exception('Ссылка не открылась');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть источник')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статья')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('${article.source.name} · ${article.dateText}'),
          const SizedBox(height: 12),
          NewsImage(url: article.image, height: 220),
          const SizedBox(height: 12),
          Text(article.text),
          const SizedBox(height: 12),
          if (article.content != article.text) Text(article.content),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => openSource(context),
            child: const Text('Перейти к источнику'),
          ),
          ListenableBuilder(
            listenable: favorites,
            builder: (context, child) {
              return FavoriteButton(article: article, favorites: favorites);
            },
          ),
        ],
      ),
    );
  }
}
