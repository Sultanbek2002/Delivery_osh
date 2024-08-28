import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    
    print("Успешный выход аккаунта");
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы успешно вышли из аккаунта.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to the login screen after a short delay to allow the message to be shown
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.introLogin,
      (Route<dynamic> route) => false,
    );
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
              onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
            ),
            
            AppSettingsListTile(
              label: S.of(context).dv_connect,
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs),
            ),
            const SizedBox(height: AppDefaults.padding * 3),
            AppSettingsListTile(
              label: S.of(context).logout,
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
