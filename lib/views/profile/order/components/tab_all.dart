import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_life/views/api_routes/apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceivedOrdersPage extends StatefulWidget {
  const ReceivedOrdersPage({Key? key}) : super(key: key);

  @override
  _ReceivedOrdersPageState createState() => _ReceivedOrdersPageState();
}

class _ReceivedOrdersPageState extends State<ReceivedOrdersPage> {
  late Future<List<dynamic>> _futureOrders;
  final String _apiUrl = '${ApiConsts.urlbase}/api/order/show';

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
        List<dynamic> orders = responseData['orders'];
        // Фильтруем заказы, чтобы показать только полученные (status_get == 1)
        orders = orders.where((order) => order['status_get'] == 1).toList();
        // Сортируем заказы по дате (от новых к старым)
        orders.sort((a, b) => DateTime.parse(b['created_at'])
            .compareTo(DateTime.parse(a['created_at'])));
        return orders;
      } else {
        throw Exception('Не удалось загрузить заказы');
      }
    } else {
      throw Exception('Не удалось загрузить заказы');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<dynamic>>(
          future: _futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyOrders(context);
            } else {
              return _buildOrderList(context, snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyOrders(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Нет полученных заказов',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<dynamic> orders) {
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        var order = orders[index];
        var orderDate = DateTime.parse(order['created_at']);
        var formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(orderDate);

        return ListTile(
          title: Text('Сумма заказа: ${order['all_summa']} сом'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Дата: $formattedDate'),
              Text('Адрес: ${order['map']}'),
            ],
          ),
        );
      },
    );
  }
}
