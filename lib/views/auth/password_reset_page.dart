
import 'package:grocery/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:grocery/views/api_routes/apis.dart';
import 'package:http/http.dart' as http; // Добавьте пакет http для запросов
import 'package:grocery/core/routes/app_routes.dart';
import '../../core/components/app_back_button.dart';
import '../../core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);
  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('${ApiConsts.urlbase}/api/accaunt/dissable'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Добавьте токен в заголовок
        },
      );
      
        // Успешное удаление
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).success_delete_account)),
        );

        await Future.delayed(
            Duration(seconds: 1)); // Дайте время сообщению появиться

        // Удалите токен из SharedPreferences
        await prefs.remove('auth_token');

        // Перейдите на главный экран
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.introLogin,
          (Route<dynamic> route) => false,
        );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(S.of(context).my_account),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(AppDefaults.margin),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding * 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).my_account,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDefaults.padding * 3),

                    // Кнопка для удаления аккаунта
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _deleteAccount(context),
                        child: Text(S.of(context).account_delete),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.padding * 2),
                    Text(
                      S.of(context).check_delete_account,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDefaults.padding * 2),
                    // Неактивированная кнопка для изменения пароля
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null, // Деактивируем кнопку
                        child: Text(S.of(context).change_password),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
