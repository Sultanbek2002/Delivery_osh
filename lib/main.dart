import 'dart:io'; // Для определения платформы
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('auth_token');
  final String? lastRoute = prefs.getString('last_route');
  final String? language = prefs.getString('language_code');
  print('AccessToken: $accessToken');
  print('LastRoute: $lastRoute');
  
  print('the language ${language}');

  if (accessToken == null) {
    await prefs.clear();
  }

  if (lastRoute != null && lastRoute.isNotEmpty) {
    runApp(MyApp(initialRoute: lastRoute));
  } else {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final String initialRoute =
          accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding;
      runApp(MyApp(initialRoute: initialRoute, language: language));
    } else {
      final String initialRoute =
          accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding;
      runApp(MyApp(initialRoute: initialRoute, language: language));
    }
  }
}

// Функция для проверки, является ли устройство iPad
bool isIPad(BuildContext context) {
  return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  final String? language;

  const MyApp({Key? key, required this.initialRoute, this.language})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    print("dsafa ${widget.language}");
    // Устанавливаем локаль на основе сохраненного кода языка
    final language = widget.language ?? 'ru'; // По умолчанию русский язык
    _locale = Locale(language);
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLocaleToPrefs(locale);
  }

  Future<void> _saveLocaleToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    // Проверка, если пользователь зашел с iPad
    if (isIPad(context)) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eGrocery',
        theme: AppTheme.defaultTheme,
        home: Scaffold(
          body: Center(
            child: Text(
              'Это приложение поддерживается только на iPhone. '
              'Пожалуйста, используйте iPhone для работы с приложением.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
      );
    }

    // Основное приложение для всех других устройств (например, iPhone)
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: widget.initialRoute,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
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
        appBar: AppBar(title: Text('Нет подключения')),
        body: Center(
          child: Text('Пожалуйста, проверьте подключение к интернету.'),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'core/routes/app_routes.dart';
// import 'core/routes/on_generate_route.dart';
// import 'core/themes/app_themes.dart';
// import 'core/languages/localization.dart'; // Импортируйте свой файл локализации

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final prefs = await SharedPreferences.getInstance();
//   final String? accessToken = prefs.getString('auth_token');
//   final String? lastRoute = prefs.getString('last_route');
//   print('AccessToken: $accessToken');
//   print('LastRoute: $lastRoute');

//   // Проверяем, если последний маршрут сохранен
//   if (lastRoute != null && lastRoute.isNotEmpty) {
//     runApp(MyApp(initialRoute: lastRoute));
//   } else {
//     // Проверяем подключение к интернету
//     final ConnectivityResult connectivityResult =
//         await Connectivity().checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       final String initialRoute =
//           accessToken != null ? AppRoutes.entryPoint : AppRoutes.onboarding;
//       runApp(MyApp(initialRoute: initialRoute));
//     } else {
//       runApp(NoInternetApp());
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   final String initialRoute;

//   const MyApp({Key? key, required this.initialRoute}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'eGrocery',
//       theme: AppTheme.defaultTheme,
//       onGenerateRoute: RouteGenerator.onGenerate,
//       initialRoute: initialRoute,
//       supportedLocales: [
//         Locale('kg'),
//         Locale('ru'),
//       ],
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         // AppLocalizationsDelegate(),
//       ],
//     );
//   }

//   static of(BuildContext context) {}
// }

// class NoInternetApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'eGrocery',
//       theme: AppTheme.defaultTheme,
//       home: Scaffold(
//         appBar: AppBar(title: Text('Нет подключения')),
//         body: Center(
//           child: Text('Пожалуйста, проверьте подключение к интернету.'),
//         ),
//       ),
//     );
//   }
// }
