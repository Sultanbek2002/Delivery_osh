import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/core/components/app_back_button.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CouponAndOffersPage extends StatefulWidget {
  const CouponAndOffersPage({Key? key}) : super(key: key);

  @override
  _CouponAndOffersPageState createState() => _CouponAndOffersPageState();
}

class _CouponAndOffersPageState extends State<CouponAndOffersPage> {
  List<Map<String, dynamic>> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];
    final String? productsData = prefs.getString('products_data');

    if (productsData != null) {
      final List<dynamic> allProducts = json.decode(productsData);
      setState(() {
        favoriteProducts = allProducts
            .where((product) => favoriteIds.contains(product['id'].toString()))
            .map((product) => product as Map<String, dynamic>)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Избранные продукты'),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Text('Нет избранных продуктов'),
            )
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ListTile(
                  leading: Image.network(
                    'https://dostavka.arendabook.com/images/${product['image']}',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['ru_name']),
                  subtitle: Text('${product['price']} сом'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetails,
                      arguments: product,
                    );
                  },
                );
              },
            ),
    );
  }
}
