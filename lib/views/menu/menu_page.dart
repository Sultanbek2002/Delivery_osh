import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_routes/apis.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import 'components/category_tile.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Выберите категорию',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          const CategoriesGrid()
        ],
      ),
    );
  }
}

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('auth_token');

    if (accessToken == null) {
      // Handle the case where the token is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Missing access token')),
      );
      return;
    }

    final url = '${ApiConsts.urlbase}/api/all-CategoryProduct';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Print the entire response data
        print('Response data: $data');

        // Iterate over each category and print it
        setState(() {
          categories = data['categories'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Log the error
      print('HTTP request error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нет подключения к интернету!!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: GridView.builder(
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryTile(
            imageLink: '${ApiConsts.urlbase}/images/${category['image']}', // Update with your server URL
            label: category['ru_name'], // Use 'ru_name' or 'name' based on your preference
            onTap: () {
               Navigator.pushNamed(
              context,
              AppRoutes.categoryDetails,
              arguments: category['id'], // Передача ID категории
            );
            },
          );
        },
      ),
    );
  }
}
