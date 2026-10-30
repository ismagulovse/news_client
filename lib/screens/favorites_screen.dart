import 'package:flutter/material.dart';

import '../state/favorites_state.dart';
import '../widgets/news_card.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesState favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.busy && favorites.news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (favorites.news.isEmpty) {
      return Center(
        child: Text(
          favorites.error.isEmpty
              ? 'В избранном ничего нет'
              : favorites.error,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: favorites.news.length,
      itemBuilder: (context, index) {
        return NewsCard(article: favorites.news[index], favorites: favorites);
      },
    );
  }
}
