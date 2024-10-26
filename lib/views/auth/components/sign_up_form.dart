import 'package:flutter/material.dart';
import 'package:grocery/views/api_routes/apis.dart';
import 'package:grocery/views/auth/login_page.dart';
import 'package:grocery/views/auth/number_verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/views/entrypoint/entrypoint_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './login_page_form.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final prefs = await SharedPreferences.getInstance();

      // Очищаем сохраненные данные при успешной авторизации
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.remove('last_route');
      print('clear data');
      final data = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      };

      // Создаем уникальный токен с помощью UUID
      final token = Uuid().v4();
      print('Generated token: $token');

      try {
        var url = Uri.parse('${ApiConsts.urlbase}/api/register');
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );
        print(response.reasonPhrase);
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final token = jsonResponse['access_token'];
          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            print("Успешно авторизован");
            // Очищаем сохраненные данные при успешной авторизаци
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const EntryPointUI()), // Здесь укажите страницу на которую хотите перейти после авторизации
              (Route<dynamic> route) =>
                  false, // Удаляет все предыдущие маршруты
            );
          } else {
            setState(() {
              _errorMessage = 'Ошибка: Токен отсутствует в ответе сервера.';
            });
          }
        } else if (response.statusCode == 400) {
          _errorMessage = "Почта или телефон существует";
        } else if (response.statusCode == 404) {
          _errorMessage = "Сервер не найден";
        } else if (response.statusCode == 302) {
          print('Redirect to: ${response.headers['location']}');
        } else {
          setState(() {
            _errorMessage = 'Ошибка регистрации';
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 4.0)],
      ),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const Text("Пользователь"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле не может быть пустым';
                    } else if (value.length < 3) {
                      return 'Должен содержать более 3 символов';
                    }
                    return null; // Если все условия соблюдены, вернуть null, что означает отсутствие ошибок
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Email"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле не может быть пустым';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Непрвильная почта ';
                    } else if (!(value.endsWith('@gmail.com') ||
                        value.endsWith('@gmail.ru'))) {
                      return 'Почта должен заканчиваться @gmail.com, @gmail.ru';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Телефон"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле не может быть пустым';
                    } else if (value.length < 9) {
                      return 'Телефон должен быть не менее 9 цифр';
                    }
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Пароль"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value!.isEmpty ? 'Поле не может быть пустым' : null,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Регистрация'),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Есть аккаунт?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 146, 25), // Цвет текста
                          decoration:
                              TextDecoration.underline, // Подчеркивание текста
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
