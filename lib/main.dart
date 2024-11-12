import 'dart:async';
import 'dart:io';
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
  final String? lastRoute = prefs.getString('last_route');
  final String? language = prefs.getString('language_code');
  print('LastRoute: $lastRoute');
  print('Language: $language');

  runApp(MyApp(
    initialRoute: AppRoutes.entryPoint,
    language: language,
  ));
}

bool isIPad(BuildContext context) {
  return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 120000;
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  final String? language;

  const MyApp({Key? key, required this.initialRoute, this.language})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    print("Language: ${widget.language}");
    final language = widget.language ?? 'ru';
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: '/',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      home: SplashScreen(initialRoute: widget.initialRoute),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String initialRoute;

  const SplashScreen({Key? key, required this.initialRoute}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Создаем AnimationController для анимации
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Продолжительность анимации
    );

    // Анимация цвета
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.green,
    ).animate(_controller);

    // Анимация масштаба
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Запуск анимации
    _controller.forward();

    // Таймер для перехода на главный экран после анимации
    Timer(const Duration(seconds: 3), _navigateToMain);
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacementNamed(widget.initialRoute);
  }

  @override
  void dispose() {
    _controller.dispose(); // Освобождаем ресурсы
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Логотип
            Image.asset('assets/images/app_logo_splash.png', height: 200),
            const SizedBox(height: 20),
            
            // Анимированный текст
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value, // Масштаб текста
                  child: Text(
                    'Green Life',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _colorAnimation.value, // Изменение цвета текста
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
