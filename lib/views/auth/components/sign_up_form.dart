import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import 'sign_up_button.dart';
import 'already_have_accout.dart';

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
  File? _avatar;
  String? _errorMessage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _avatar = File(pickedFile.path);
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'username': _usernameController.text,
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://172.20.10.4:8000/api/register/'), // Замените на адрес вашего сервера
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Регистрация успешна, переходим на страницу верификации
          Navigator.pushNamed(
            context,
            AppRoutes.numberVerification,
            arguments: {
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          );
        } else {
          setState(() {
            _errorMessage = 'Ошибка регистрации: ${response.statusCode} - ${response.reasonPhrase}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Ошибка при отправке данных: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Form(
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
              validator: Validators.requiredWithFieldName('Username'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Имя"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _firstnameController,
              validator: Validators.requiredWithFieldName('First Name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Фамилия"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lastnameController,
              validator: Validators.requiredWithFieldName('Last Name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              validator: Validators.requiredWithFieldName('Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Телефон номер"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              validator: Validators.requiredWithFieldName('Phone Number'),
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Пароль"),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              validator: Validators.requiredWithFieldName('Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppIcons.eye,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Фото профиля"),
            const SizedBox(height: 8),
            Row(
              children: [
                _avatar == null
                    ? const Text("Выберите фото")
                    : Image.file(_avatar!, width: 100, height: 100),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const SizedBox(height: AppDefaults.padding),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Регистрация'),
            ),
            const AlreadyHaveAnAccount(),
            const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}
