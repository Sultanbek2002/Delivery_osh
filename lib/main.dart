import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugin services are initialized

  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('auth_token');
  print(accessToken);

  // Check connectivity
  final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    runApp(NoInternetApp());
  } else {
    runApp(MyApp(accessToken: accessToken));
  }
}

class MyApp extends StatelessWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding,
    );
  }
}

class NoInternetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      home: Scaffold(
        appBar: AppBar(title: Text('Нет подклячение')),
        body: Center(
          child: Text('Пожалуйста, проверте подключение к интернету.'),
        ),
      ),
    );
  }
}
