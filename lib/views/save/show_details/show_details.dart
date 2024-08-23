import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowDetails extends StatefulWidget {
  final int orderId;

  const ShowDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  late Future<Map<String, dynamic>> _futureOrderDetails;

  @override
  void initState() {
    super.initState();
    _futureOrderDetails = _fetchOrderDetails(widget.orderId);
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('auth_token');
    final productsData = prefs.getString('products_data');

    final response = await http.get(
      Uri.parse('https://dostavka.arendabook.com/api/order/details/show/$orderId'),
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status']) {
        final orderDetails = responseData['orderDetails'] as List<dynamic>;

        // Разбираем данные о продуктах из локального хранилища
        final List<dynamic> products = json.decode(productsData!);

        // Добавляем информацию о продуктах к деталям заказа
        for (var detail in orderDetails) {
          final product = products.firstWhere(
            (product) => product['id'] == detail['product_id'],
            orElse: () => null,
          );
          detail['product_info'] = product;
        }

        return {
          'status': responseData['status'],
          'orderDetails': orderDetails,
        };
      } else {
        throw Exception('Failed to load order details');
      }
    } else {
      throw Exception('Failed to load order details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureOrderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет данных.'));
          } else {
            final orderDetails = snapshot.data!['orderDetails'] as List<dynamic>;

            return ListView.builder(
              itemCount: orderDetails.length,
              itemBuilder: (context, index) {
                final detail = orderDetails[index];
                final productInfo = detail['product_info'];

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      'https://dostavka.arendabook.com/images/${productInfo['image']}',
                      width: 50,
                      height: 50,
                    ),
                    title: Text(productInfo['ru_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Цена: ${productInfo['price']} сом'),
                        Text('Количество: ${detail['quantity']}'),
                        Text('Описание: ${productInfo['ru_description']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
