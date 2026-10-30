import 'package:flutter/material.dart';

import '../data/news_repository.dart';
import '../data/news_store.dart';
import '../state/news_state.dart';
import '../state/favorites_state.dart';
import '../widgets/news_filters.dart';
import 'favorites_screen.dart';
import 'news_feed.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final state = NewsState(NewsRepository());
  final favorites = FavoritesState(NewsStore());
  int tab = 0;

  @override
  void initState() {
    super.initState();
    state.addListener(update);
    favorites.addListener(update);
    favorites.load();
    state.loadNews();
  }

  void update() {
    setState(() {});
  }

  @override
  void dispose() {
    state.removeListener(update);
    favorites.removeListener(update);
    state.dispose();
    favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tab == 0 ? 'Новости' : 'Избранное')),
      body: IndexedStack(
        index: tab,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: NewsFilters(
                  category: state.category,
                  busy: state.loading,
                  onFilter: state.filter,
                ),
              ),
              Expanded(
                child: NewsFeed(state: state, favorites: favorites),
              ),
            ],
          ),
          FavoritesScreen(favorites: favorites),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            for (int index = 0; index < 2; index++)
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    tab = index;
                  }),
                  child: Text(
                    index == 0 ? 'Новости' : 'Избранное',
                    style: TextStyle(
                      fontWeight: tab == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: tab == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
