import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../core/components/network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_images.dart';
import '../../core/themes/app_themes.dart';
import 'dialogs/verified_dialogs.dart';

class NumberVerificationPage extends StatelessWidget {
  const NumberVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем аргументы, переданные из предыдущего экрана
    final Map<String, String>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    if (args == null || args.isEmpty) {
      // Обработка ситуации, если аргументы не переданы корректно
      return Scaffold(
        body: Center(
          child: Text('Ошибка передачи данных для верификации'),
        ),
      );
    }

    final String email = args['email'] ?? '';
    final String password = args['password'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  margin: const EdgeInsets.all(AppDefaults.margin),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: Column(
                    children: [
                      const NumberVerificationHeader(),
                      const OTPTextFields(),
                      SizedBox(height: AppDefaults.padding * 3),
                      const ResendButton(),
                      SizedBox(height: AppDefaults.padding),
                      VerifyButton(
                        email: email,
                        password: password,
                      ),
                      SizedBox(height: AppDefaults.padding),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyButton extends StatelessWidget {
  final String email;
  final String password;

  const VerifyButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  
  get context => null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Отправляем данные на сервер для верификации
          sendDataToServer(email, password);
        },
        child: const Text('Подвердить'),
      ),
    );
  }

  void sendDataToServer(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
      // Добавьте необходимые данные для верификации, например, код OTP
      'code': '1234', // Пример: фиксированный код OTP для тестирования
    };

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.4:8000/api/verify-code/'), // Замените на адрес вашего сервера
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Обработка успешной верификации
        // Например, показать диалог успешной верификации
        showGeneralDialog(
          barrierLabel: 'Dialog',
          barrierDismissible: true,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => const VerifiedDialog(),
          transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      } else {
        // Обработка ошибок верификации
        print('Ошибка верификации: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Обработка ошибок при отправке запроса
      print('Ошибка при отправке данных: $e');
    }
  }
}

class ResendButton extends StatelessWidget {
  const ResendButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Не получили код?'),
        TextButton(
          onPressed: () {
            // Добавьте действия по повторной отправке кода
          },
          child: const Text('Отправить снова'),
        ),
      ],
    );
  }
}

class NumberVerificationHeader extends StatelessWidget {
  const NumberVerificationHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDefaults.padding),
        Text(
          'Введите 4 значный код',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDefaults.padding),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: const AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(
              AppImages.numberVerfication,
            ),
          ),
        ),
        const SizedBox(height: AppDefaults.padding * 3),
      ],
    );
  }
}

class OTPTextFields extends StatelessWidget {
  const OTPTextFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.otpInputDecorationTheme,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
