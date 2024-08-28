import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/core/constants/app_defaults.dart';
import 'package:grocery/core/constants/app_icons.dart';
import 'package:grocery/core/routes/app_routes.dart';
import 'package:grocery/main.dart';
import 'package:grocery/views/profile/components/profile_list_tile.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({Key? key}) : super(key: key);

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
    final authToken = prefs.getString('auth_token'); // Сохраняем auth_token

    await prefs.clear(); // Очищаем все данные

    if (authToken != null) {
      await prefs.setString('auth_token', authToken); // Восстанавливаем auth_token
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).clear_data),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    print(locale.languageCode);
    await prefs.setString('language_code', locale.languageCode);

    // Перезагрузка приложения
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
          ListTile(
            title: Text(S.of(context).langauge),
            trailing: DropdownButton<String>(
              items: [
                DropdownMenuItem(child: Text('Русский'), value: 'ru'),
                DropdownMenuItem(child: Text('Кыргыз'), value: 'en'),
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










// import 'package:flutter/material.dart';
// import 'package:grocery/core/constants/app_defaults.dart';
// import 'package:grocery/core/constants/app_icons.dart';
// import 'package:grocery/core/routes/app_routes.dart';
// import 'package:grocery/main.dart';
// import 'package:grocery/views/profile/components/profile_list_tile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../core/languages/localization.dart'; // Импортируйте класс локализации

// class ProfileMenuOptions extends StatelessWidget {
//   const ProfileMenuOptions({Key? key}) : super(key: key);

//   Future<void> _logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(AppLocalizations.of(context)?.translate('logout_success') ?? 'Logout successful'),
//         duration: Duration(seconds: 3),
//       ),
//     );

//     await Future.delayed(Duration(seconds: 1));

//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       AppRoutes.introLogin,
//       (Route<dynamic> route) => false,
//     );
//   }

//   Future<void> _clearData(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('auth_token'); // Сохраняем auth_token

//     await prefs.clear(); // Очищаем все данные

//     if (authToken != null) {
//       await prefs.setString('auth_token', authToken); // Восстанавливаем auth_token
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(AppLocalizations.of(context)?.translate('data_cleared') ?? 'Data cleared'),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   void _changeLanguage(BuildContext context, Locale locale) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language_code', locale.languageCode);

//     // Обновите состояние приложения для применения нового языка
//     MyApp.of(context)?.setLocale(locale);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(AppDefaults.padding),
//       padding: const EdgeInsets.all(AppDefaults.padding),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: AppDefaults.boxShadow,
//         borderRadius: AppDefaults.borderRadius,
//       ),
//       child: Column(
//         children: [
//           ProfileListTile(
//             title: 'Выйти',
//             icon: AppIcons.profileLogout,
//             onTap: () => _logout(context),
//           ),
//           ProfileListTile(
//             title:'Очистка кеша',
//             icon: AppIcons.delete,
//             onTap: () => _clearData(context),
//           ),
//           ListTile(
//             title: Text(AppLocalizations.of(context)?.translate('language') ?? 'Language'),
//             trailing: DropdownButton<String>(
//               items: [
//                 DropdownMenuItem(child: Text('Русский'), value: 'kg'),
//                 DropdownMenuItem(child: Text('Кыргызча'), value: ''),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   _changeLanguage(context, Locale(value));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
