import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../drawer/drawer_page.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import 'profile_list_tile.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({
    Key? key,
  }) : super(key: key);
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
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
            title: 'Выйти',
            icon: AppIcons.profileLogout,
            onTap: ()=>_logout(context),
          ),
        ],
      ),
    );
  }
}
