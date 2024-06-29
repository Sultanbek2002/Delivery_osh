import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> posts = json.decode(response.body);

        // Проверяем, чтобы каждый элемент не был null
        posts = posts.map((post) {
          return {
            'userId': post['userId'] ?? 0,
            'id': post['id'] ?? 0,
            'title': post['title'] ?? 'No Title',
            'body': post['body'] ?? 'No Body'
          };
        }).toList();

        // Выводим данные на консоль для проверки
        print('Posts fetched successfully: $posts');
        return posts;
      } else {
        // Выводим сообщение об ошибке на консоль
        print('Failed to load posts. Status code: ${response.statusCode}');
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // Выводим исключение на консоль
      print('Error occurred: $e');
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> fetchPostById(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$postId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load post with ID $postId. Status code: ${response.statusCode}');
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load post');
    }
  }
}
