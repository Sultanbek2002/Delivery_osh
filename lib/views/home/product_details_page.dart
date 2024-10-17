import 'package:flutter/material.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/constants/app_defaults.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isFavorite = false;
  bool isInCart = false;
  String _languageCode = 'ru';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _checkIfFavorite();
    _checkIfInCart();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'ru';
    });
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        isFavorite = favorites.contains(widget.product['id'].toString());
      });
    } else {
      await prefs.setStringList('favorites', []);
    }
  }

  Future<void> _checkIfInCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart');
    if (cart != null) {
      setState(() {
        isInCart = cart.contains(widget.product['id'].toString());
      });
    } else {
      await prefs.setStringList('cart', []);
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      favorites.remove(widget.product['id'].toString());
    } else {
      favorites.add(widget.product['id'].toString());
    }

    await prefs.setStringList('favorites', favorites);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];
      cart.add(widget.product['id'].toString());
    await prefs.setStringList('cart', cart);
    setState(() {
      isInCart = !isInCart;
    });
  }

  String _getLocalizedKey(String key) {
    return _languageCode == 'ru' ? 'ru_$key' : key;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Все о продукте'),
        ),
        body: const Center(
          child: Text('Invalid product details.'),
        ),
      );
    }

    final double price = double.tryParse(product['price']) ?? 0.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Продукт'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: BuyNowRow(
            onBuyButtonTap: () async {
              await _addToCart();
              Navigator.pushNamed(context, AppRoutes.cartPage);
            },
            onCartButtonTap: _addToCart,
            isInCart: isInCart,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImagesSlider(
              images: [
                'https://dostavka.arendabook.com/images/${product['image']}',
                'https://dostavka.arendabook.com/images/${product['image_2']}',
                'https://dostavka.arendabook.com/images/${product['image_3']}',
                'https://dostavka.arendabook.com/images/${product['image_4']}',
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product[_getLocalizedKey('name')],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${price} сом',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${S.of(context).description}: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product[_getLocalizedKey('description')],
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
