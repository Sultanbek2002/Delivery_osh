import 'package:flutter/material.dart';
import './api/api_service.dart';
import '../../core/components/network_image.dart';
import '../../core/constants/app_defaults.dart';
import './show_details/show_details.dart'; // Импортируем страницу ShowDetails

class EmptySavePage extends StatefulWidget {
  const EmptySavePage({Key? key}) : super(key: key);

  @override
  _EmptySavePageState createState() => _EmptySavePageState();
}

class _EmptySavePageState extends State<EmptySavePage> {
  late Future<List<dynamic>> _futurePosts;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futurePosts = _apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts List'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<dynamic>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyWishlist(context);
            } else {
              return _buildPostList(context, snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(AppDefaults.padding * 2),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: NetworkImageWithLoader(
                  'https://i.imgur.com/mbjap7k.png',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Oops!',
           
          ),
          const SizedBox(height: 8),
          const Text('Sorry, no posts found.'),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context, List<dynamic> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        return ListTile(
          title: Text(post['title']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${post['id']}'),
              Text('User ID: ${post['userId']}'),
            ],
          ),
          onTap: () {
            _showPostDetails(context, post['id']); // Передаем id поста
          },
        );
      },
    );
  }

  void _showPostDetails(BuildContext context, int postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetails(postId: postId), // Передаем postId
      ),
    );
  }
}
