import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('У вас есть аккаунт?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
          child: const Text('Вход'),
        ),
      ],
    );
  }
}
