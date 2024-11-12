import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:grocery/views/auth/password_reset_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/core/constants/app_defaults.dart';
import 'package:grocery/core/constants/app_icons.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:grocery/main.dart';
import 'package:grocery/views/profile/components/profile_list_tile.dart';

class ProfileMenuOptions extends StatefulWidget {
  const ProfileMenuOptions({Key? key}) : super(key: key);

  @override
  _ProfileMenuOptionsState createState() => _ProfileMenuOptionsState();
}

class _ProfileMenuOptionsState extends State<ProfileMenuOptions> {
  String? _selectedLanguage;
  bool _isAuthorized = false; // Флаг авторизации

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _checkAuthorization();
  }

  // Метод для проверки авторизации
  Future<void> _checkAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthorized = prefs.getString('auth_token') != null; // Проверка наличия токена
    });
  }

  void _navigateToPasswordReset() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const PasswordResetPage()),
    );
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language_code') ?? 'ru';
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).logout_success),
        duration: Duration(seconds: 3),
      ),
    );

    await Future.delayed(Duration(seconds: 1));
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.introLogin,
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _clearData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    await prefs.clear();

    if (authToken != null) {
      await prefs.setString('auth_token', authToken);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).clear_data),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    setState(() {
      _selectedLanguage = locale.languageCode;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp(initialRoute: AppRoutes.entryPoint, language: locale.languageCode)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        children: [
          if (_isAuthorized) // Отображаем, если пользователь авторизован
            ProfileListTile(
              title: S.of(context).logout,
              icon: AppIcons.profileLogout,
              onTap: () => _logout(context),
            ),
          ProfileListTile(
            title: S.of(context).menu_clear_data,
            icon: AppIcons.delete,
            onTap: () => _clearData(context),
          ),
          if (_isAuthorized) // Отображаем, если пользователь авторизован
            ProfileListTile(
              onTap: _navigateToPasswordReset,
              icon: AppIcons.profile,
              title: S.of(context).my_account,
            ),
          ListTile(
            title: Text(S.of(context).langauge),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(child: Text('Русский'), value: 'ru'),
                DropdownMenuItem(child: Text('Кыргыз'), value: 'ky'),
              ],
              onChanged: (value) {
                if (value != null) {
                  _changeLanguage(context, Locale(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
