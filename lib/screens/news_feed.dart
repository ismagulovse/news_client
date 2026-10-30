import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../state/news_state.dart';
import '../state/favorites_state.dart';
import '../widgets/news_card.dart';

class NewsFeed extends StatefulWidget {
  final NewsState state;
  final FavoritesState favorites;

  const NewsFeed({super.key, required this.state, required this.favorites});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    scroll.addListener(loadMore);
  }

  void loadMore() {
    if (scroll.position.extentAfter < 300 && widget.state.moreError.isEmpty) {
      widget.state.loadMore();
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Column(
      children: [
        if (state.cached)
          const Text('Сохранённые новости'),
        if (state.error.isNotEmpty)
          Padding(padding: const EdgeInsets.all(8), child: Text(state.error)),
        TextButton(
          onPressed: state.loading
              ? null
              : () async {
                  scroll.jumpTo(0);
                  await state.loadNews();
                },
          child: const Text('Обновить'),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: RefreshIndicator(
              onRefresh: state.loadNews,
              child: ListView.builder(
                controller: scroll,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: state.news.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.news.length) {
                    return NewsCard(
                      article: state.news[index],
                      favorites: widget.favorites,
                      isMain: index == 0,
                    );
                  }
                  if (state.loading) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.news.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Новостей нет')),
                    );
                  }
                  if (state.moreError.isNotEmpty) {
                    return Column(
                      children: [
                        Text(state.moreError),
                        TextButton(
                          onPressed: state.loadMore,
                          child: const Text('Повторить'),
                        ),
                      ],
                    );
                  }
                  if (state.hasMore && !state.cached) {
                    return TextButton(
                      onPressed: state.loadMore,
                      child: const Text('Загрузить ещё'),
                    );
                  }
                  return const SizedBox(height: 16);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
