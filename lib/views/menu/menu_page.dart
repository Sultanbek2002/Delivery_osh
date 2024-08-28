import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
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
            S.of(context).chose_cat,
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
  String _languageCode = 'ru';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    fetchCategories();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'ru';
    });
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('auth_token');

    if (accessToken == null) {
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
        print('Response data: $data');

        setState(() {
          categories = data['categories'];
          isLoading = false;
        });
      } else {
        throw Exception(S.of(context).fail_load);
      }
    } catch (e) {
      print('HTTP request error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).fail_connect_internet)),
      );
    }
  }

  String _getLocalizedKey(String key) {
    return _languageCode == 'ru' ? 'ru_$key' : key;
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
            imageLink: '${ApiConsts.urlbase}/images/${category['image']}',
            label: category[_getLocalizedKey('name')], // Use the localized key
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.categoryDetails,
                arguments: category['id'],
              );
            },
          );
        },
      ),
    );
  }
}
