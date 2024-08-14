import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_life/core/routes/app_routes.dart';
import 'package:green_life/views/cart/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import 'components/coupon_code_field.dart';
import 'components/items_totals_price.dart';
import 'components/single_cart_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
    this.isHomePage = false,
  }) : super(key: key);

  final bool isHomePage;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();

    // Загружаем идентификаторы продуктов из корзины
    final cart = prefs.getStringList('cart') ?? [];
    print('cart: $cart');

    // Загружаем данные о всех продуктах
    final productsData = prefs.getString('products_data');
    print('data: $productsData');

    if (productsData != null) {
      final List<dynamic> jsonList = json.decode(productsData);
      _allProducts =
          jsonList.map((item) => Map<String, dynamic>.from(item)).toList();

      // Сопоставляем продукты в корзине с данными о продуктах
      _cartItems = _allProducts
          .where((product) => cart.contains(product['id'].toString()))
          .toList();

      // Устанавливаем quantity по умолчанию, если он отсутствует
      for (var item in _cartItems) {
        item['quantity'] = item['quantity'] ?? 1;
      }
    }

    setState(() {});
  }

  void _updateCartItem(Map<String, dynamic> updatedItem) {
    setState(() {
      _cartItems = _cartItems.map((item) {
        if (item['id'] == updatedItem['id']) {
          return updatedItem;
        }
        return item;
      }).toList();
    });
  }

  void _removeCartItem(Map<String, dynamic> itemToRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];

    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemToRemove['id']);
    });

    cart.remove(itemToRemove['id'].toString());
    await prefs.setStringList('cart', cart);
  }

  void _navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(cartItems: _cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: widget.isHomePage
            ? null
            : AppBar(
                leading: const AppBackButton(),
                title: const Text("Корзина"),
              ),
        body: const Center(
          child: Text('Корзина пусто'),
        ),
      );
    }

    return Scaffold(
      appBar: widget.isHomePage
          ? null
          : AppBar(
              leading: const AppBackButton(),
              title: const Text('Корзина'),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._cartItems
                  .map((item) => SingleCartItemTile(
                        item: item,
                        onUpdateQuantity: _updateCartItem,
                        onRemove: _removeCartItem,
                      ))
                  .toList(),
              ItemTotalsAndPrice(cartItems: _cartItems),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: ElevatedButton(
                    onPressed: _navigateToCheckout,
                    child: const Text('Заказать'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
