import 'package:flutter/material.dart';
import '../../../core/components/dotted_divider.dart';
import '../../../core/constants/constants.dart';
import 'item_row.dart';

class ItemTotalsAndPrice extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const ItemTotalsAndPrice({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalItems = cartItems.fold<int>(
      0,
      (sum, item) => sum + ((item['quantity'] as int?) ?? 1),
    );

    final totalPrice = cartItems.fold<double>(
      0.0,
      (sum, item) {
        final price = double.tryParse(item['price'] ?? '0') ?? 0.0;
        final quantity = (item['quantity'] as int?) ?? 1;
        return sum + (price * quantity);
      },
    );

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        children: [
          ItemRow(
            title: 'Общая количества',
            value: '$totalItems',
          ),
          ItemRow(
            title: 'Общая сумма',
            value: '${totalPrice.toStringAsFixed(2)} сом',
          ),
        ],
      ),
    );
  }
}
