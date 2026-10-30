import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'news_error.dart';

class NewsApi {
  Future<List<dynamic>> getNews({ int page = 1, String category = 'general', String searchText = '',}) 
  async {
    const apiKey = String.fromEnvironment('GNEWS_KEY');
    
    if (apiKey.isEmpty)
    {
      throw NewsError(
        'Нет ключа',
      );
    }
    
    final url = Uri.https('gnews.io', '/api/v4/top-headlines', {
      'apikey': apiKey,
      'lang': 'ru',
      'max': '10',
      'page': '$page',
      'category': category,
      
      if (searchText.isNotEmpty) 'q': searchText,
    });
    
    final http.Response response;
    
    try 
    {
      response = await http.get(url).timeout(const Duration(seconds: 30));
    } 
    on TimeoutException 
    {
      throw NewsError('Нет ответа');
    } 
    on http.ClientException 
    {
      throw NewsError(
        'Нет интернета',
      );
    }
    if (response.statusCode != 200) 
    {
      throw NewsError('Ошибку: ${response.statusCode}.');
    }
    final data = jsonDecode(response.body);
    return data['articles'];
  }
}
