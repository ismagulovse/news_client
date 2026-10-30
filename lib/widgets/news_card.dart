import 'package:flutter/material.dart';

import '../models/article.dart';
import '../state/favorites_state.dart';
import '../screens/article_screen.dart';
import 'favorite_button.dart';
import 'news_image.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final FavoritesState favorites;
  final bool isMain;

  const NewsCard({
    super.key,
    required this.article,
    required this.favorites,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ArticleScreen(article: article, favorites: favorites),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(url: article.image, height: isMain ? 220 : 140),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: isMain
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(article.text, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text('${article.source.name} · ${article.dateText}'),
              FavoriteButton(article: article, favorites: favorites),
            ],
          ),
        ),
      ),
    );
  }
}
