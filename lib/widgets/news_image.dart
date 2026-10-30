import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  final String url;
  final double height;

  const NewsImage({super.key, required this.url, this.height = 140});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stack) {
        return const SizedBox(
          height: 60,
          child: Center(child: Text('Изображение загрузить не удалось')),
        );
      },
    );
  }
}
