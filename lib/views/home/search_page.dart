import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_icons.dart';
import '../../core/routes/app_routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadProducts();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsData = prefs.getString('products_data');
    if (productsData != null) {
      final decodedData = json.decode(productsData) as List<dynamic>;
      setState(() {
        allProducts = decodedData;
        filteredProducts = allProducts;
      });
    }
  }

  void _filterProducts(String query) {
    final filtered = allProducts.where((product) {
      final productName = product['ru_name'].toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();
    
    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SearchPageHeader(onSearch: _filterProducts),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTile(
                    title: Text(product['ru_name']),
                    subtitle: Text('${product['price']} руб'),
                    leading: isOffline==false
                        ? Icon(
                            Icons.image_not_supported, // Замените на нужную иконку из AppIcons
                          size: 60,
                          color: Colors.grey,
                          )
                        : Image.network(
                            'https://dostavka.arendabook.com/images/${product['image']}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                            Icons.image_not_supported, // Замените на нужную иконку из AppIcons
                          size: 60,
                          color: Colors.grey,
                          );
                            },
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPageHeader extends StatelessWidget {
  final Function(String) onSearch;

  const _SearchPageHeader({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: S.of(context).search,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: SvgPicture.asset(AppIcons.search),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
