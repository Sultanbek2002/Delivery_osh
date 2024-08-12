import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../api_routes/apis.dart';

class PopularPacks extends StatefulWidget {
  const PopularPacks({Key? key}) : super(key: key);

  @override
  _PopularPacksState createState() => _PopularPacksState();
}

class _PopularPacksState extends State<PopularPacks> {
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  Future<List<dynamic>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiConsts.urlbase}/api/all-Product'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Save data to SharedPreferences
      await prefs.setString('products_data', json.encode(data['product']));

      return data['product'];
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  Future<List<dynamic>> _loadProductsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsData = prefs.getString('products_data');
    if (productsData != null) {
      return json.decode(productsData);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
           'Популярные продукты' ,
           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<List<dynamic>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Популярные товары не найдены'));
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDefaults.padding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjusted ratio to fit content better
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return BundleTileSquare(data: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({Key? key, required this.data}) : super(key: key);

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: data,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: const Color.fromARGB(255, 39, 37, 37)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://dostavka.arendabook.com/images/${data['image']}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['ru_name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['ru_description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${data['price']} сом',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
