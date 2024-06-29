import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class DontHaveAccountRow extends StatelessWidget {
  const DontHaveAccountRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('У вас нет аккаунта?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
          child: const Text('Регистрация'),
        ),
      ],
    );
  }
}
