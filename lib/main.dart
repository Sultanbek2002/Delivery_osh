import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';
import 'core/languages/localization.dart'; // Импортируйте свой файл локализации

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('auth_token');
  final String? lastRoute = prefs.getString('last_route');
  print('AccessToken: $accessToken');
  print('LastRoute: $lastRoute');

  // Проверяем, если последний маршрут сохранен
  if (lastRoute != null && lastRoute.isNotEmpty) {
    runApp(MyApp(initialRoute: lastRoute));
  } else {
    // Проверяем подключение к интернету
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final String initialRoute =
          accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding;
      runApp(MyApp(initialRoute: initialRoute));
    } else {
      runApp(NoInternetApp());
    }
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: initialRoute,
      supportedLocales: [
        Locale('kg'),
        Locale('ru'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationsDelegate(),
      ],
    );
  }

  static of(BuildContext context) {}
}

class NoInternetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      home: Scaffold(
        appBar: AppBar(title: Text('Нет подключения')),
        body: Center(
          child: Text('Пожалуйста, проверьте подключение к интернету.'),
        ),
      ),
    );
  }
}
