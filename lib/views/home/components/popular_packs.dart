import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:grocery/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../api_routes/apis.dart';

class PopularPacks extends StatefulWidget {
  const PopularPacks({Key? key}) : super(key: key);

  @override
  _PopularPacksState createState() => _PopularPacksState();
}

class _PopularPacksState extends State<PopularPacks> {
  List<dynamic> _cachedProducts = [];
  late Future<void> _futureUpdate;
  String _languageCode = 'ru';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _loadCachedProducts();
    _futureUpdate = _fetchAndUpdateProducts();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'ru';
    });
  }

  Future<void> _loadCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsData = prefs.getString('products_data');

    if (productsData != null) {
      setState(() {
        _cachedProducts = json.decode(productsData);
      });
    }
  }

  Future<void> _fetchAndUpdateProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('${ApiConsts.urlbase}/api/all-Product'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await prefs.setString('products_data', json.encode(data['product']));

        setState(() {
          _cachedProducts = data['product'];
        });
      } else if (response.statusCode == 401) {
        await prefs.remove('auth_token');
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        throw Exception('Ошибка загрузки продуктов: ${response.body}');
      }
    } catch (error) {
      print('Ошибка при обновлении данных: $error');
    }
  }

  String _getLocalizedKey(String key) {
    return _languageCode == 'ru' ? 'ru_$key' : key;
  }

  bool isIPad(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return deviceWidth > 600; // Проверка на iPad или другие большие устройства
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).popular_product_menu,
          style: TextStyle(fontSize: isIPad(context) ? 24 : 20, fontWeight: FontWeight.bold),
        ),
        if (_cachedProducts.isEmpty)
          Center(child: Text(S.of(context).empty_data))
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDefaults.padding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isIPad(context) ? 4 : 2, // Больше колонок для iPad
              crossAxisSpacing: isIPad(context) ? 16 : 10, // Отступы
              mainAxisSpacing: isIPad(context) ? 16 : 10, // Отступы
              childAspectRatio: isIPad(context) ? 1.2 : 0.8, // Более широкий для iPad
            ),
            itemCount: _cachedProducts.length,
            itemBuilder: (context, index) {
              return BundleTileSquare(
                data: _cachedProducts[index],
                languageCode: _languageCode,
              );
            },
          ),
        FutureBuilder<void>(
          future: _futureUpdate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({
    Key? key,
    required this.data,
    required this.languageCode,
    this.isOffline = false,
  }) : super(key: key);

  final dynamic data;
  final String languageCode;
  final bool isOffline;

  String _getLocalizedKey(String key) {
    return languageCode == 'ru' ? 'ru_$key' : key;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: data,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: isOffline
                        ? Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '${ApiConsts.urlbase}/images/${data['image']}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data[_getLocalizedKey('name')],
                      style: TextStyle(
                        fontSize: isIPad(context) ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data[_getLocalizedKey('description')],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${data['price']} сом',
                      style: TextStyle(
                        fontSize: isIPad(context) ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
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
