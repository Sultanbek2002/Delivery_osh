import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/views/api_routes/apis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/components/product_tile_square.dart';

class CategoryProductPage extends StatefulWidget {
  final int categoryId;

  const CategoryProductPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  _CategoryProductPageState createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  List<Map<String, dynamic>> products = []; // Измените на List<Map<String, dynamic>>
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('auth_token');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: отсутствует токен доступа')),
      );
      return;
    }

    final url = '${ApiConsts.urlbase}/api/CategoryProduct/${widget.categoryId}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Response body: ${response.body}'); // Вывод всего ответа в консоль

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Decoded data: $data'); // Вывод декодированных данных

        setState(() {
          products = (data['product'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Не удалось загрузить продукты');
      }
    } catch (e) {
      print('Ошибка HTTP-запроса: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить продукты: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Продукты'),
          leading: const BackButton(),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты'),
        leading: const BackButton(),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppDefaults.padding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductTileSquare(
            data: product, // Передача данных как Map
          );
        },
      ),
    );
  }
}
