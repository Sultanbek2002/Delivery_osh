import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/generated/l10n.dart';
import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import 'profile_header_options.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Image.asset('assets/images/profile_page_background.png'),

        /// Content
        Column(
          children: [
            AppBar(
              title: const Text('Профиль'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const _UserData(),
            const ProfileHeaderOptions(),
          ],
        ),
      ],
    );
  }
}

class _UserData extends StatefulWidget {
  const _UserData({
    Key? key,
  }) : super(key: key);

  @override
  State<_UserData> createState() => _UserDataState();
}

class _UserDataState extends State<_UserData> {
  late Future<Map<String, dynamic>?> _futureProfileData;

  @override
  void initState() {
    super.initState();
    _futureProfileData = _fetchProfileData();
  }

  Future<Map<String, dynamic>?> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('auth_token');

    if (userToken == null) {
      // Если токен отсутствует, возвращаем null
      return null;
    }

    final headers = {
      'Authorization': 'Bearer $userToken',
    };

    final response = await http.get(
      Uri.parse('https://dostavka.arendabook.com/api/user'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(S.of(context).fail_load);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _futureProfileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          // Если пользователь не авторизован, показываем кнопку "Войти или регистрация"
          return Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/login'); // Навигация к экрану логина
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Белый фон
                foregroundColor: Colors.green, // Зелёный текст
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Скругление углов, если нужно
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16), // Вертикальные отступы
                textStyle: const TextStyle(
                  fontSize: 15, // Размер текста
                  fontWeight: FontWeight.bold, // Полужирный текст
                ),
              ),
              child: Text(S.of(context).sign_or_signup),
            ),
          );
        } else {
          // Если данные пользователя загружены, показываем их
          var profileData = snapshot.data!;
          var firstName = profileData['username'];
          var email = profileData['email'];

          return Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Row(
              children: [
                const SizedBox(width: AppDefaults.padding),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipOval(
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: NetworkImageWithLoader(
                          "https://cdn-icons-png.flaticon.com/512/4519/4519729.png"),
                    ),
                  ),
                ),
                const SizedBox(width: AppDefaults.padding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
