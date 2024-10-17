import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RunningTab extends StatefulWidget {
  const RunningTab({Key? key}) : super(key: key);

  @override
  _RunningTabState createState() => _RunningTabState();
}

class _RunningTabState extends State<RunningTab> {
  late Future<List<dynamic>> _futureOrders;
  final String _apiUrl = 'https://dostavka.arendabook.com/api/order/show';

  @override
  void initState() {
    super.initState();
    _futureOrders = _fetchOrders();
  }

  Future<List<dynamic>> _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('auth_token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    final response = await http.get(Uri.parse(_apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']) {
        
        return responseData['orders'];
      } else {
        throw Exception('Failed to load orders');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Нет отмененных заказов'));
        } else {
          // Фильтрация отменённых заказов
          final cancelledOrders = snapshot.data!
              .where((order) => order['comment_client'] != null)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: cancelledOrders.length,
            itemBuilder: (context, index) {
              final order = cancelledOrders[index];
              final orderDate = DateTime.parse(order['created_at']);
              final formattedDate = DateFormat('dd MMM yyyy').format(orderDate);

              return ListTile(
                title: Text('Сумма заказа: ${order['all_summa']} сом'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Дата: $formattedDate'),
                    Text('Адрес: ${order['map']}'),
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color: Colors.red, // Цвет для отменённых заказов
                      child: Text(
                        'Отменён: ${order['comment_client']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Здесь можно добавить обработку нажатия
                },
              );
            },
          );
        }
      },
    );
  }
}
