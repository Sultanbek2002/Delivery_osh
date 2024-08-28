import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:grocery/generated/l10n.dart';

import '../constants/constants.dart';

class BuyNowRow extends StatelessWidget {
  const BuyNowRow({
    Key? key,
    required this.onCartButtonTap,
    required this.onBuyButtonTap,
    required this.isInCart,
  }) : super(key: key);

  final void Function() onCartButtonTap;
  final void Function() onBuyButtonTap;
  final bool isInCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDefaults.padding,
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: onCartButtonTap,
            child: SvgPicture.asset(
              AppIcons.shoppingCart,
              color: isInCart ? Colors.green : Colors.black,
            ),
          ),
          const SizedBox(width: AppDefaults.padding),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onCartButtonTap(); // Добавляем продукт в корзину
                Navigator.pushNamed(context, AppRoutes.cartPage); // Переходим в корзину
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(AppDefaults.padding * 1.2),
              ),
              child: Text(S.of(context).order_btn),
            ),
          ),
        ],
      ),
    );
  }
}
