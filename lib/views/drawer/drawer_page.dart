import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_icons.dart';
import '../../core/routes/app_routes.dart';
import '../../core/components/app_settings_tile.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('cart');
    await prefs.remove('favorites');

    print("Успешный выход из аккаунта");
    // Показываем сообщение об успешном выходе
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Вы успешно вышли из аккаунта.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Переходим на экран входа после короткой задержки
    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.introLogin,
      (Route<dynamic> route) => false,
    );
  }

  // Открытие внешнего URL
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Открыть ссылку во внешнем браузере
      );
    } else {
      // Показать сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  Future<bool> _isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    return authToken != null && authToken.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(S.of(context).dr_menu),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          children: [
            AppSettingsListTile(
              label: S.of(context).use_rule,
              trailing: SvgPicture.asset(AppIcons.right),
            ),
            AppSettingsListTile(
              label: S.of(context).about_us,
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Открываем ссылку о компании
                _launchURL(context, 'https://dostavka.arendabook.com/about');
              },
            ),
            AppSettingsListTile(
              label: S.of(context).dv_connect,
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs),
            ),
            AppSettingsListTile(
              label: S.of(context).privacy_title,
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.faq),
            ),
            const SizedBox(height: AppDefaults.padding * 3),
            FutureBuilder<bool>(
              future: _isUserAuthenticated(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!) {
                  return Container(); // Не показываем кнопку выхода, если пользователь не авторизован
                }

                return AppSettingsListTile(
                  label: S.of(context).logout,
                  trailing: SvgPicture.asset(AppIcons.right),
                  onTap: () => _logout(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
