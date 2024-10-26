// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Көптөгөн түрдөгү азыктар`
  String get f_image {
    return Intl.message(
      'Көптөгөн түрдөгү азыктар',
      name: 'f_image',
      desc: '',
      args: [],
    );
  }

  /// `Салам`
  String get hello {
    return Intl.message(
      'Салам',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Дуйно`
  String get world {
    return Intl.message(
      'Дуйно',
      name: 'world',
      desc: '',
      args: [],
    );
  }

  /// `Меню`
  String get dr_menu {
    return Intl.message(
      'Меню',
      name: 'dr_menu',
      desc: '',
      args: [],
    );
  }

  /// `Колдонуу эрежеси`
  String get use_rule {
    return Intl.message(
      'Колдонуу эрежеси',
      name: 'use_rule',
      desc: '',
      args: [],
    );
  }

  /// `Түзүүчүлөр менен байланышуу`
  String get dv_connect {
    return Intl.message(
      'Түзүүчүлөр менен байланышуу',
      name: 'dv_connect',
      desc: '',
      args: [],
    );
  }

  /// `Чыгуу`
  String get logout {
    return Intl.message(
      'Чыгуу',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Биз жөнүндө`
  String get about_us {
    return Intl.message(
      'Биз жөнүндө',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Маалымат жок`
  String get empty_data {
    return Intl.message(
      'Маалымат жок',
      name: 'empty_data',
      desc: '',
      args: [],
    );
  }

  /// `Издөө`
  String get search {
    return Intl.message(
      'Издөө',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Товарлар`
  String get popular_product_menu {
    return Intl.message(
      'Товарлар',
      name: 'popular_product_menu',
      desc: '',
      args: [],
    );
  }

  /// `Башкы бет`
  String get home {
    return Intl.message(
      'Башкы бет',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма`
  String get order {
    return Intl.message(
      'Буйрутма',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Профиль`
  String get profile {
    return Intl.message(
      'Профиль',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Категориялар`
  String get chose_cat {
    return Intl.message(
      'Категориялар',
      name: 'chose_cat',
      desc: '',
      args: [],
    );
  }

  /// `Жүктөөдө каталык бар`
  String get fail_load {
    return Intl.message(
      'Жүктөөдө каталык бар',
      name: 'fail_load',
      desc: '',
      args: [],
    );
  }

  /// `Интернетке начар туташуу`
  String get fail_connect_internet {
    return Intl.message(
      'Интернетке начар туташуу',
      name: 'fail_connect_internet',
      desc: '',
      args: [],
    );
  }

  /// `Товарлар`
  String get products {
    return Intl.message(
      'Товарлар',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Токен жок`
  String get empty_token {
    return Intl.message(
      'Токен жок',
      name: 'empty_token',
      desc: '',
      args: [],
    );
  }

  /// `Кутуча`
  String get basket {
    return Intl.message(
      'Кутуча',
      name: 'basket',
      desc: '',
      args: [],
    );
  }

  /// `Азырынча кутуча бош `
  String get basket_empty {
    return Intl.message(
      'Азырынча кутуча бош ',
      name: 'basket_empty',
      desc: '',
      args: [],
    );
  }

  /// `Жөнөтүү`
  String get follow {
    return Intl.message(
      'Жөнөтүү',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Жалпы буйрутма эсеби`
  String get allCount {
    return Intl.message(
      'Жалпы буйрутма эсеби',
      name: 'allCount',
      desc: '',
      args: [],
    );
  }

  /// `Жалпы сумма`
  String get allsumma {
    return Intl.message(
      'Жалпы сумма',
      name: 'allsumma',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутмада каталык бар`
  String get order_fail {
    return Intl.message(
      'Буйрутмада каталык бар',
      name: 'order_fail',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма ийгилктүү аяктады`
  String get order_success {
    return Intl.message(
      'Буйрутма ийгилктүү аяктады',
      name: 'order_success',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма берүү`
  String get order_menu {
    return Intl.message(
      'Буйрутма берүү',
      name: 'order_menu',
      desc: '',
      args: [],
    );
  }

  /// `Адрести жазыныз`
  String get order_adress {
    return Intl.message(
      'Адрести жазыныз',
      name: 'order_adress',
      desc: '',
      args: [],
    );
  }

  /// `Учурдагы телефон`
  String get order_phone {
    return Intl.message(
      'Учурдагы телефон',
      name: 'order_phone',
      desc: '',
      args: [],
    );
  }

  /// `Адрести толтурунуз`
  String get order_validate_address {
    return Intl.message(
      'Адрести толтурунуз',
      name: 'order_validate_address',
      desc: '',
      args: [],
    );
  }

  /// `Телефонду жазыныз `
  String get order_validate_phone {
    return Intl.message(
      'Телефонду жазыныз ',
      name: 'order_validate_phone',
      desc: '',
      args: [],
    );
  }

  /// `кг`
  String get produc_count {
    return Intl.message(
      'кг',
      name: 'produc_count',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма берүү`
  String get order_to {
    return Intl.message(
      'Буйрутма берүү',
      name: 'order_to',
      desc: '',
      args: [],
    );
  }

  /// `Cиз буйрутмаларды көзөмөлдөй аласыз, буйрутма абалын биле аласыз.`
  String get order_success_phrase {
    return Intl.message(
      'Cиз буйрутмаларды көзөмөлдөй аласыз, буйрутма абалын биле аласыз.',
      name: 'order_success_phrase',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутмалар тизмеси`
  String get orders {
    return Intl.message(
      'Буйрутмалар тизмеси',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Азырынча тизме бош`
  String get empty_order {
    return Intl.message(
      'Азырынча тизме бош',
      name: 'empty_order',
      desc: '',
      args: [],
    );
  }

  /// `Жеткирилди`
  String get status_get {
    return Intl.message(
      'Жеткирилди',
      name: 'status_get',
      desc: '',
      args: [],
    );
  }

  /// `Жолдо`
  String get status_set {
    return Intl.message(
      'Жолдо',
      name: 'status_set',
      desc: '',
      args: [],
    );
  }

  /// `Көрүлгөн`
  String get status_show {
    return Intl.message(
      'Көрүлгөн',
      name: 'status_show',
      desc: '',
      args: [],
    );
  }

  /// `Кабыл алынды`
  String get status_have {
    return Intl.message(
      'Кабыл алынды',
      name: 'status_have',
      desc: '',
      args: [],
    );
  }

  /// `Белгисиз`
  String get status_not_defind {
    return Intl.message(
      'Белгисиз',
      name: 'status_not_defind',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма кабыл алынган же жолдо болгону учун кайтарууга болбойт`
  String get stop_refuse {
    return Intl.message(
      'Буйрутма кабыл алынган же жолдо болгону учун кайтарууга болбойт',
      name: 'stop_refuse',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма ийгилктүү кайтарылды`
  String get refuse_success {
    return Intl.message(
      'Буйрутма ийгилктүү кайтарылды',
      name: 'refuse_success',
      desc: '',
      args: [],
    );
  }

  /// `кайтарууда каталык бар`
  String get refuse_fail {
    return Intl.message(
      'кайтарууда каталык бар',
      name: 'refuse_fail',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутманы кайтаруу`
  String get refuse_order {
    return Intl.message(
      'Буйрутманы кайтаруу',
      name: 'refuse_order',
      desc: '',
      args: [],
    );
  }

  /// `Кайтаруунун себеби`
  String get refuse_reason {
    return Intl.message(
      'Кайтаруунун себеби',
      name: 'refuse_reason',
      desc: '',
      args: [],
    );
  }

  /// `Токтотуу`
  String get btn_refuse {
    return Intl.message(
      'Токтотуу',
      name: 'btn_refuse',
      desc: '',
      args: [],
    );
  }

  /// `Жөнөтүү`
  String get btn_refuse_to {
    return Intl.message(
      'Жөнөтүү',
      name: 'btn_refuse_to',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутманын суммасы`
  String get order_sum {
    return Intl.message(
      'Буйрутманын суммасы',
      name: 'order_sum',
      desc: '',
      args: [],
    );
  }

  /// `Убактысы`
  String get order_date {
    return Intl.message(
      'Убактысы',
      name: 'order_date',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма берүү`
  String get order_btn {
    return Intl.message(
      'Буйрутма берүү',
      name: 'order_btn',
      desc: '',
      args: [],
    );
  }

  /// `Буйрутма жөнүндө`
  String get order_detail {
    return Intl.message(
      'Буйрутма жөнүндө',
      name: 'order_detail',
      desc: '',
      args: [],
    );
  }

  /// `Баасы`
  String get order_price {
    return Intl.message(
      'Баасы',
      name: 'order_price',
      desc: '',
      args: [],
    );
  }

  /// `Даана`
  String get order_detail_count {
    return Intl.message(
      'Даана',
      name: 'order_detail_count',
      desc: '',
      args: [],
    );
  }

  /// `Маалымат`
  String get description {
    return Intl.message(
      'Маалымат',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Архивдер`
  String get history {
    return Intl.message(
      'Архивдер',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Жаккан товарлар`
  String get liked {
    return Intl.message(
      'Жаккан товарлар',
      name: 'liked',
      desc: '',
      args: [],
    );
  }

  /// `Сиз аккаунттан ийгиликтүү чыктыныз`
  String get logout_success {
    return Intl.message(
      'Сиз аккаунттан ийгиликтүү чыктыныз',
      name: 'logout_success',
      desc: '',
      args: [],
    );
  }

  /// `Кештер ийгиликтүү тазаланды`
  String get clear_data {
    return Intl.message(
      'Кештер ийгиликтүү тазаланды',
      name: 'clear_data',
      desc: '',
      args: [],
    );
  }

  /// `Кештерди тазалоо`
  String get menu_clear_data {
    return Intl.message(
      'Кештерди тазалоо',
      name: 'menu_clear_data',
      desc: '',
      args: [],
    );
  }

  /// `Тили`
  String get langauge {
    return Intl.message(
      'Тили',
      name: 'langauge',
      desc: '',
      args: [],
    );
  }

  /// `Учурдагы телефон номер`
  String get phone_to_order {
    return Intl.message(
      'Учурдагы телефон номер',
      name: 'phone_to_order',
      desc: '',
      args: [],
    );
  }

  /// `Телефон номер жазылышы керек(формат: +996xxxxxxxxx)`
  String get order_phone_validate {
    return Intl.message(
      'Телефон номер жазылышы керек(формат: +996xxxxxxxxx)',
      name: 'order_phone_validate',
      desc: '',
      args: [],
    );
  }

  /// `Кененирээк маалымат`
  String get detail_of_order {
    return Intl.message(
      'Кененирээк маалымат',
      name: 'detail_of_order',
      desc: '',
      args: [],
    );
  }

  /// `Жеке аккаунт`
  String get my_account {
    return Intl.message(
      'Жеке аккаунт',
      name: 'my_account',
      desc: '',
      args: [],
    );
  }

  /// `Аккаунтту өчүрүү`
  String get account_delete {
    return Intl.message(
      'Аккаунтту өчүрүү',
      name: 'account_delete',
      desc: '',
      args: [],
    );
  }

  /// `Сыр сөздү өзгөртүү`
  String get change_password {
    return Intl.message(
      'Сыр сөздү өзгөртүү',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Аккаунт ийгиликтүү өчүрүрүлдү`
  String get success_delete_account {
    return Intl.message(
      'Аккаунт ийгиликтүү өчүрүрүлдү',
      name: 'success_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Аккаунтту өчүрүүдө каталык`
  String get failed_delete_account {
    return Intl.message(
      'Аккаунтту өчүрүүдө каталык',
      name: 'failed_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Аккаунтту өчүрүү учун эки жолу басыныз`
  String get check_delete_account {
    return Intl.message(
      'Аккаунтту өчүрүү учун эки жолу басыныз',
      name: 'check_delete_account',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kg'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
