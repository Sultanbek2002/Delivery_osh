import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_life/core/components/network_image.dart';
import 'package:green_life/core/constants/app_colors.dart';
import 'package:green_life/core/constants/app_defaults.dart';
import 'package:green_life/core/constants/app_images.dart';
import 'package:green_life/core/routes/app_routes.dart';
import 'package:green_life/core/themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '.././api_routes/apis.dart';

class NumberVerificationPage extends StatefulWidget {
  final String email;
  final String password;

  const NumberVerificationPage({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _NumberVerificationPageState createState() => _NumberVerificationPageState();
}

class _NumberVerificationPageState extends State<NumberVerificationPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  String? _errorMessage;
  String? _verificationCode;
  bool _isLoading = false;
  Timer? _timer;
  bool _isCodeExpired = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _isCodeExpired = false;
    _timer = Timer(Duration(minutes: 3), () {
      setState(() {
        _isCodeExpired = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Код истек. Пожалуйста, запросите новый код.')),
      );
    });
  }

  Future<void> _verifyCode() async {
    final otpCode = _otpControllers.map((controller) => controller.text).join();
    if (otpCode.length != 4) {
      setState(() {
        _errorMessage = 'Пожалуйста, введите полный код для проверки.';
      });
      return;
    }

    if (_isCodeExpired) {
      setState(() {
        _errorMessage = 'Код истек. Пожалуйста, запросите новый код.';
      });
      return;
    }

    final data = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'code': otpCode,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConsts.urlbase}/api/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response JSON: $jsonResponse');
        final token = jsonResponse['access_token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          print("Успешно авторизован");
          Navigator.pushNamed(context, AppRoutes.entryPoint);
        } else {
          setState(() {
            _errorMessage = 'Ошибка: Токен отсутствует в ответе сервера.';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Ошибка верификации: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка при отправке данных 3: $e';
      });
    }
  }

  void _requestVerificationCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final data = {
      'email': email,
      'password': password,
    };
    print(data['email']);
    print(data['password']);
    try {
      final response = await http.post(
        Uri.parse('${ApiConsts.urlbase}/api/restart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response JSON: $jsonResponse');
        final verificationCode = jsonResponse['code'];
        if (verificationCode != null) {
          setState(() {
            _verificationCode = verificationCode;
          });
          _startTimer();
        } else {
          setState(() {
            _errorMessage = 'Ошибка: Код верификации отсутствует в ответе.';
          });
        }
      } else {
        print("1");
        setState(() {
          _errorMessage =
              'Ошибка при отправке данных1: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      print("2");
      setState(() {
        _errorMessage = 'Ошибка при отправке данных2: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      OTPTextFields(
                        controllers: _otpControllers,
                        onCodeEntered: _verifyCode,
                      ),
                      SizedBox(height: AppDefaults.padding * 3),
                      if (_isLoading) CircularProgressIndicator(),
                      ResendButton(onPressed: _requestVerificationCode),
                      SizedBox(height: AppDefaults.padding),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      VerifyButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onVerificationCodeReceived: (code) {
                          setState(() {
                            _verificationCode = code;
                          });
                        },
                      ),
                      SizedBox(height: AppDefaults.padding),
                      ElevatedButton(
                        onPressed: _verifyCode,
                        child: const Text('Подтвердить код'),
                      ),
                      SizedBox(height: AppDefaults.padding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String>? onVerificationCodeReceived;

  const VerifyButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    this.onVerificationCodeReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final email = emailController.text;
          final password = passwordController.text;

          if (email.isEmpty || password.isEmpty) {
            print('Ошибка: Почта и пароль не могут быть пустыми.');
            return;
          }

          final data = {
            'email': email,
            'password': password,
          };
          print('postemail $email');
          print('postpass $password');
          try {
            final response = await http.post(
              Uri.parse('${ApiConsts.urlbase}/api/restart'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(data),
            );

            if (response.statusCode == 200) {
              final jsonResponse = jsonDecode(response.body);
              print('Response JSON: $jsonResponse');
              if (jsonResponse['code'] != null) {
                final verificationCode = jsonResponse['code'];
                if (onVerificationCodeReceived != null) {
                  onVerificationCodeReceived!(verificationCode);
                }
              } else {
                print('Ошибка: Код верификации отсутствует в ответе.');
              }
            } else {
              print(
                  'Ошибка при отправке данных: ${response.statusCode} - ${response.reasonPhrase}');
            }
          } catch (e) {
            print('Ошибка при отправке данных: $e');
          }
        },
        child: const Text('Запросить код'),
      ),
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
  final List<TextEditingController> controllers;
  final VoidCallback onCodeEntered;

  const OTPTextFields({
    Key? key,
    required this.controllers,
    required this.onCodeEntered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.otpInputDecorationTheme,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              controller: controllers[index],
              onChanged: (v) {
                if (v.length == 1 && index < 3) {
                  FocusScope.of(context).nextFocus();
                } else if (v.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }

                if (controllers
                    .every((controller) => controller.text.length == 1)) {
                  onCodeEntered();
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
          );
        }),
      ),
    );
  }
}

class ResendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResendButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Не получили код?'),
        TextButton(
          onPressed: onPressed,
          child: const Text('Отправить снова'),
        ),
      ],
    );
  }
}
