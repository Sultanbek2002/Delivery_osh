import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugin services are initialized

  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding,
    );
  }
}
