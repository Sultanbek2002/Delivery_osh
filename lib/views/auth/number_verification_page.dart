 import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/core/components/network_image.dart';
import 'package:grocery/core/constants/app_colors.dart';
import 'package:grocery/core/constants/app_defaults.dart';
import 'package:grocery/core/constants/app_images.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:grocery/views/entrypoint/entrypoint_ui.dart';
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

    // Автоматически отправляем код при загрузке страницы
    _requestVerificationCode();
    // Восстанавливаем данные, если они сохранены
    _restoreData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', AppRoutes.numberVerification);
    await prefs.setString('saved_email', _emailController.text);
    await prefs.setString('saved_password', _passwordController.text);
  }

  Future<void> _removeData() async {
    final prefs = await SharedPreferences.getInstance();

    // Очищаем сохраненные данные при успешной авторизации
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.remove('last_route');
    print('clear data');
  }

  Future<void> _restoreData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
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
        final token = jsonResponse['access_token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          print("Успешно авторизован");
          // Очищаем сохраненные данные при успешной авторизации
          await _removeData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EntryPointUI()), // Здесь укажите страницу на которую хотите перейти после авторизации
            (Route<dynamic> route) => false, // Удаляет все предыдущие маршруты
          );
        } else {
          setState(() {
            _errorMessage = 'Ошибка: Токен отсутствует в ответе сервера.';
          });
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = 'Ошибка: Неправильный код.';
        });
      } else {
        setState(() {
          _errorMessage =
              'Ошибка проверки: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка при отправке данных: $e';
      });
    }
  }

  Future<void> _requestVerificationCode() async {
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

    try {
      final response = await http.post(
        Uri.parse('${ApiConsts.urlbase}/api/restart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        final verificationCode = jsonResponse['message'];
        // Сохраняем данные после успешной отправки кода
        await _saveData();
        print(verificationCode);
        if (verificationCode == "Код подтверждения отправлен") {
          setState(() {
            _verificationCode = verificationCode;
          });
          _startTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Код отправлен. Проверьте свою почту. Код истечет через три минуты.')),
          );
        }
         else {
          setState(() {
            _errorMessage =
                'Ошибка: Код проверки отсутствует в ответе.Попробуйте обратно отправить';
          });
        }
      }else if(response.statusCode == 422){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Есть активный код. Ждите 3 минуты, потом заново отпровьте. Иначе регистрируйтесь занова')),
          );
      } 
      else {
        setState(() {
          _errorMessage = 'Ошибка при отправке данных';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при отправке данных';
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
                      SizedBox(height: AppDefaults.padding),
                      ElevatedButton(
                        onPressed: _verifyCode,
                        child: const Text('Подтвердить код'),
                      ),
                      SizedBox(height: AppDefaults.padding),
                      TextButton(
                          onPressed: () {
                            _removeData();
                            Navigator.pushNamed(context,AppRoutes.introLogin);
                          },
                          // onPressed: () => Navigator.pushNamed(
                          //     context, AppRoutes.introLogin),
                          child: const Text('На главную'))
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

class NumberVerificationHeader extends StatelessWidget {
  const NumberVerificationHeader({Key? key}) : super(key: key);

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
            child: NetworkImageWithLoader(AppImages.numberVerfication),
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
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
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
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
              ),
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
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Отправить код повторно',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
