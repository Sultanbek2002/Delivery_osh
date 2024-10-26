import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:grocery/views/api_routes/apis.dart';
import 'package:grocery/views/home/order_successfull_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cart', []);
  }

  Future<void> _placeOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Если форма не валидна, прекратить выполнение
    }

    final prefs = await SharedPreferences.getInstance();
    final userToken =
        prefs.getString('auth_token'); // Замените на ваш метод получения токена

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken', // Добавляем токен в заголовки
    };
    final body = json.encode({
      'map': _addressController.text, // Используем значение из текстового поля
      'number': _phoneController.text,
      'products': widget.cartItems
          .map((item) => {
                'product_id': item['id'],
                'quantity': item['quantity'],
              })
          .toList(),
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.post(
          Uri.parse("${ApiConsts.urlbase}/api/Order"),
          headers: headers,
          body: body);
      Navigator.pop(context);
      print(response);
      if (response.statusCode == 200) {
        await _clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrderSuccessfullPage()), // Ваша главная страница
          (Route<dynamic> route) => false,
        );
      } else {
        print("statusCode: ${response.statusCode}-${response.reasonPhrase}");
        _showErrorDialog(context, S.of(context).order_fail);
      }
    } catch (e) {
      print("Error ${e}");
      Navigator.pop(context);
      _showErrorDialog(context, S.of(context).fail_connect_internet);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Рассчёт общего количества товаров
    final double totalItems = widget.cartItems
        .fold<double>(0, (sum, item) => sum + (item['quantity'] ?? 1));

    // Рассчёт общей суммы
    final double totalPrice = widget.cartItems.fold<double>(
        0.0,
        (sum, item) =>
            sum +
            ((item['quantity'] ?? 1) *
                (double.tryParse(item['price']) ?? 0.0)));

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(S.of(context).order_menu),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Поле для ввода адреса
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: S.of(context).order_adress,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).order_validate_address;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDefaults.padding),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: S.of(context).phone_to_order,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).order_validate_phone;
                    }
                    if (!value.startsWith('+996')) {
                      return S.of(context).order_phone_validate;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDefaults.padding),
                // Отображение списка товаров в корзине
                ...widget.cartItems
                    .map((item) => ListTile(
                          title: Text(item['name']),
                          subtitle: Text(
                              '${item['quantity']} ${S.of(context).produc_count}'),
                          trailing: Text('${item['price']} сом'),
                        ))
                    .toList(),
                const Divider(),
                // Отображение общего количества товаров
                ListTile(
                  title: Text(S.of(context).allCount),
                  trailing: Text('$totalItems ${S.of(context).produc_count}'),
                ),
                // Отображение общей суммы
                ListTile(
                  title: Text(S.of(context).allsumma),
                  trailing: Text('$totalPrice сом'),
                ),
                const SizedBox(height: AppDefaults.padding),
                // Кнопка для размещения заказа
                PayNowButton(onPressed: () => _placeOrder(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayNowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PayNowButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(S.of(context).order_to),
        ),
      ),
    );
  }
}
