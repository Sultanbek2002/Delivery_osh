import 'package:flutter/material.dart';
import 'package:grocery/views/auth/number_verification_page.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

      final data = {
        'username': _usernameController.text,
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      };

      // Создаем уникальный токен с помощью UUID
      final token = Uuid().v4();
      print('Generated token: $token');

      try {
        var url = Uri.parse('https://dostavka.arendabook.com/api/register');
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "X-CSRF-TOKEN":token

          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NumberVerificationPage(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            ),
          );
        } else if (response.statusCode == 302) {
          print('Redirect to: ${response.headers['location']}');
        } else {
          setState(() {
            _errorMessage = 'Ошибка регистрации: ${response.statusCode} - ${response.reasonPhrase}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Ошибка при отправке данных ${e}';
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
                  validator: (value) => value!.isEmpty ? 'Username is required' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Имя"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstnameController,
                  validator: (value) => value!.isEmpty ? 'First Name is required' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Фамилия"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastnameController,
                  validator: (value) => value!.isEmpty ? 'Last Name is required' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Email"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => value!.isEmpty ? 'Email is required' : null,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Телефон"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  validator: (value) => value!.isEmpty ? 'Phone is required' : null,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text("Пароль"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => value!.isEmpty ? 'Password is required' : null,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Регистрация'),
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
