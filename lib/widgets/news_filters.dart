import 'package:flutter/material.dart';

class NewsFilters extends StatefulWidget {
  final String category;
  final bool busy;
  final void Function(String category, String searchText) onFilter;

  const NewsFilters({
    super.key,
    required this.category,
    required this.busy,
    required this.onFilter,
  });

  @override
  State<NewsFilters> createState() => _NewsFiltersState();
}

class _NewsFiltersState extends State<NewsFilters> {
  final search = TextEditingController();
  final categories = {
    'general': 'Все',
    'world': 'Мир',
    'nation': 'Страна',
    'business': 'Бизнес',
    'technology': 'Технологии',
    'entertainment': 'Развлечения',
    'sports': 'Спорт',
    'science': 'Наука',
    'health': 'Здоровье',
  };

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: search,
                enabled: !widget.busy,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: 'Поиск статей',
                  counterText: '',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => widget.onFilter(widget.category, value),
              ),
            ),
            TextButton(
              onPressed: widget.busy
                  ? null
                  : () => widget.onFilter(widget.category, search.text),
              child: const Text('Найти'),
            ),
            TextButton(
              onPressed: widget.busy
                  ? null
                  : () {
                      search.clear();
                      widget.onFilter(widget.category, '');
                    },
              child: const Text('Сброс'),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final entry in categories.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: widget.category == entry.key,
                    showCheckmark: false,
                    onSelected: widget.busy
                        ? null
                        : (value) => widget.onFilter(entry.key, search.text),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
