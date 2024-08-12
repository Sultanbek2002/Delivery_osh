import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery/views/api_routes/apis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/components/network_image.dart';
import '../../core/constants/app_defaults.dart';
import './show_details/show_details.dart';

class EmptySavePage extends StatefulWidget {
  const EmptySavePage({Key? key}) : super(key: key);

  @override
  _EmptySavePageState createState() => _EmptySavePageState();
}

class _EmptySavePageState extends State<EmptySavePage> {
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
        // Фильтрация заказов, у которых status_client не равен 0
        List<dynamic> orders = responseData['orders'];
        orders = orders.where((order) => order['status_client'] != 0).toList();

        orders.sort((a,b){
          DateTime dateA = DateTime.parse(a['created_at']);
          DateTime dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA);
        });
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

  String _getOrderStatus(Map<String, dynamic> order) {
    if (order['status_get'] == 1) {
      return 'Полученный';
    } else if (order['status_set'] == 1) {
      return 'В пути';
    } else if (order['status_show'] == 1) {
      return 'Просмотрен';
    } else if (order['status_have'] == 1) {
      return 'Принят';
    } else {
      return 'Неизвестный статус';
    }
  }

  Color _getOrderStatusColor(Map<String, dynamic> order) {
    if (order['status_get'] == 1) {
      return Colors.green;
    } else if (order['status_set'] == 1) {
      return Colors.orange;
    } else if (order['status_show'] == 1) {
      return Colors.blue;
    } else if (order['status_have'] == 1) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Future<void> _cancelOrder(BuildContext context, int orderId, Map<String, dynamic> order) async {
  if (order['status_get'] == 1 || order['status_set'] == 1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вы не можете удалить этот заказ, так как он уже получен или в пути')),
    );
    return;
  }

  String? reason = await _showCancelDialog(context);
  if (reason == null || reason.isEmpty) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('auth_token');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $userToken',
  };
  print(reason);

  try {
    final response = await http.post(
      Uri.parse('${ApiConsts.urlbase}/api/order/cancaled/$orderId?comment_client=$reason'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      setState(() {
        _futureOrders = _fetchOrders();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ успешно отменен')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при отмене заказа')),
      );
    }
  } catch (e) {
    print(e);
  }
}


  Future<String?> _showCancelDialog(BuildContext context) async {
    TextEditingController _reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Отмена заказа'),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: 'Причина отказа'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Отправить'),
              onPressed: () {
                Navigator.of(context).pop(_reasonController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваши заказы'),
      ),
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
              return _buildEmptyWishlist(context);
            } else {
              return _buildOrderList(context, snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(AppDefaults.padding * 2),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: NetworkImageWithLoader(
                  'https://i.imgur.com/mbjap7k.png',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('У вас нет заказов'),
          const Spacer(),
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
        var formattedDate = "${orderDate.day}/${orderDate.month}/${orderDate.year}-${orderDate.hour}:${orderDate.minute}";
        var orderStatus = _getOrderStatus(order);
        var orderStatusColor = _getOrderStatusColor(order);

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
                color: orderStatusColor,
                child: Text(
                  'Статус: $orderStatus',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () => _cancelOrder(context, order['id'],order),
          ),
          onTap: () {
            _showOrderDetails(context, order['id']);
          },
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetails(orderId: orderId),
      ),
    );
  }
}
