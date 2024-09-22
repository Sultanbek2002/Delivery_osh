import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/views/entrypoint/entrypoint_ui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_themes.dart';
import '../../../core/utils/validators.dart';
import 'login_button.dart';
import '../../api_routes/apis.dart';

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({Key? key}) : super(key: key);

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordShown = false;
  bool isLoading = false;  // Track loading state

  onPassShowClicked() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  Future<void> onLogin() async {
    final bool isFormOkay = _key.currentState?.validate() ?? false;
    if (isFormOkay) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      setState(() {
        isLoading = true;  // Show loading indicator
      });

      try {
        final response = await login(email, password);

        if (response.containsKey('access_token')) {
          final accessToken = response["access_token"];
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EntryPointUI()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response['Error']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;  // Hide loading indicator
        });
      }
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '${ApiConsts.urlbase}/api/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {'Error': 'Пройдите регистрацию.'};
      } else {
        throw Exception('Failed to login, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP request error: $e');
      throw Exception('Failed to login, HTTP error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.requiredWithFieldName('Email'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppDefaults.padding),

              const Text("Пароль"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                validator: Validators.password,
                onFieldSubmitted: (v) => onLogin(),
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordShown,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: onPassShowClicked,
                    icon: Icon(
                      isPasswordShown ? Icons.visibility : Icons.visibility_off,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDefaults.padding),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, AppRoutes.forgotPassword);
              //     },
              //     child: const Text('Забыли пароль?'),
              //   ),
              // ),

              if (isLoading) 
                Center(child: CircularProgressIndicator()),  // Show loading animation
              
              if (!isLoading) 
                LoginButton(onPressed: onLogin),
            ],
          ),
        ),
      ),
    );
  }
}

