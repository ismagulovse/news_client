import 'package:flutter/material.dart';

import '../models/article.dart';
import '../state/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final Article article;
  final FavoritesState favorites;

  const FavoriteButton({
    super.key,
    required this.article,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: favorites.busy || article.url.isEmpty
          ? null
          : () async {
              await favorites.toggle(article);
              if (!context.mounted || favorites.error.isEmpty) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(favorites.error)));
            },
      child: Text(
        favorites.contains(article) ? 'Убрать из избранного' : 'В избранное',
      ),
    );
  }
}
