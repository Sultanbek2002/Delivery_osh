import 'package:flutter/material.dart';
import '../api/api_service.dart'; // Импорт ApiService, если требуется работа с данными

class ShowDetails extends StatefulWidget {
  final int postId;

  const ShowDetails({Key? key, required this.postId}) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  late Future<Map<String, dynamic>> _futurePost;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futurePost = _apiService.fetchPostById(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            var post = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('ID: ${post['id']}'),
                  Text('User ID: ${post['userId']}'),
                  const SizedBox(height: 16),
                  Text(post['body']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
