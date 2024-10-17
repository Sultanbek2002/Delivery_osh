import 'package:flutter/cupertino.dart';
import 'package:grocery/views/home/home_page.dart';

import '../../views/auth/forget_password_page.dart';
import '../../views/auth/intro_login_page.dart';
import '../../views/auth/login_or_signup_page.dart';
import '../../views/auth/login_page.dart';
import '../../views/auth/number_verification_page.dart';
import '../../views/auth/password_reset_page.dart';
import '../../views/auth/sign_up_page.dart';
import '../../views/cart/cart_page.dart';
import '../../views/cart/checkout_page.dart';
import '../../views/drawer/about_us_page.dart';
import '../../views/drawer/contact_us_page.dart';
import '../../views/drawer/drawer_page.dart';
import '../../views/drawer/faq_page.dart';
import '../../views/drawer/help_page.dart';
import '../../views/drawer/terms_and_conditions_page.dart';
import '../../views/entrypoint/entrypoint_ui.dart';
import '../../views/home/bundle_create_page.dart';
import '../../views/home/bundle_details_page.dart';
import '../../views/home/bundle_product_details_page.dart';
import '../../views/home/new_item_page.dart';
import '../../views/home/order_failed_page.dart';
import '../../views/home/order_successfull_page.dart';
import '../../views/home/popular_pack_page.dart';
import '../../views/home/product_details_page.dart';
import '../../views/home/search_page.dart';
import '../../views/home/search_result_page.dart';
import '../../views/menu/category_page.dart';
import '../../views/onboarding/onboarding_page.dart';
import '../../views/profile/address/address_page.dart';
import '../../views/profile/address/new_address_page.dart';
import '../../views/profile/coupon/coupon_details_page.dart';
import '../../views/profile/coupon/coupon_page.dart';
import '../../views/profile/notification_page.dart';
import '../../views/profile/order/my_order_page.dart';
import '../../views/profile/order/order_details.dart';

import '../../views/profile/profile_edit_page.dart';
import '../../views/profile/settings/change_password_page.dart';
import '../../views/profile/settings/change_phone_number_page.dart';
import '../../views/profile/settings/language_settings_page.dart';
import '../../views/profile/settings/notifications_settings_page.dart';
import '../../views/profile/settings/settings_page.dart';
import '../../views/review/review_page.dart';
import '../../views/review/submit_review_page.dart';
import '../../views/save/save_page.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;

    switch (route) {
      case AppRoutes.introLogin:
        return CupertinoPageRoute(builder: (_) => const IntroLoginPage());

      case AppRoutes.onboarding:
        return CupertinoPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.entryPoint:
        return CupertinoPageRoute(builder: (_) => const EntryPointUI());

      case AppRoutes.search:
        return CupertinoPageRoute(builder: (_) => const SearchPage());

      case AppRoutes.searchResult:
        return CupertinoPageRoute(builder: (_) => const SearchResultPage());

      case AppRoutes.cartPage:
        return CupertinoPageRoute(builder: (_) => const CartPage());

      case AppRoutes.savePage:
        return CupertinoPageRoute(builder: (_) => const SavePage());

      case AppRoutes.checkoutPage:
          final cartItems = settings.arguments as List<Map<String, dynamic>>? ?? [];
          return CupertinoPageRoute(
            builder: (_) => CheckoutPage(cartItems: cartItems),
          );

      case AppRoutes.categoryDetails:
        final categoryId = settings.arguments as int;
        return CupertinoPageRoute(
          builder: (context) => CategoryProductPage(categoryId: categoryId),
        );

      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return CupertinoPageRoute(builder: (_) => const SignUpPage());

      case AppRoutes.loginOrSignup:
        return CupertinoPageRoute(builder: (_) => const LoginOrSignUpPage());

      case AppRoutes.numberVerification:
      return CupertinoPageRoute(
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
          final email = args?['email'] ?? '';
          final password = args?['password'] ?? '';

          return NumberVerificationPage(
            email: email,
            password: password,
          );
        },
      );


      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => const ForgetPasswordPage());

      case AppRoutes.passwordReset:
        return CupertinoPageRoute(builder: (_) => const PasswordResetPage());

      case AppRoutes.newItems:
        return CupertinoPageRoute(builder: (_) => const NewItemsPage());

      case AppRoutes.popularItems:
        return CupertinoPageRoute(builder: (_) => const PopularPackPage());

      case AppRoutes.bundleProduct:
        return CupertinoPageRoute(
            builder: (_) => const BundleProductDetailsPage());

      case AppRoutes.bundleDetailsPage:
        return CupertinoPageRoute(builder: (_) => const BundleDetailsPage());

       case AppRoutes.productDetails:
        return CupertinoPageRoute(
          builder: (context) {
            final product = settings.arguments as Map<String, dynamic>;
            return ProductDetailsPage(product: product);
          },
        );

      case AppRoutes.createMyPack:
        return CupertinoPageRoute(builder: (_) => const BundleCreatePage());

      case AppRoutes.orderSuccessfull:
        return CupertinoPageRoute(builder: (_) => const OrderSuccessfullPage());

      case AppRoutes.orderFailed:
        return CupertinoPageRoute(builder: (_) => const OrderFailedPage());

      case AppRoutes.myOrder:
        return CupertinoPageRoute(builder: (_) => const AllOrderPage());

      case AppRoutes.orderDetails:
        return CupertinoPageRoute(builder: (_) => const OrderDetailsPage());

      case AppRoutes.coupon:
        return CupertinoPageRoute(builder: (_) => const CouponAndOffersPage());

      case AppRoutes.couponDetails:
        return CupertinoPageRoute(builder: (_) => const CouponDetailsPage());

      case AppRoutes.profileEdit:
        return CupertinoPageRoute(builder: (_) => const ProfileEditPage());

      case AppRoutes.newAddress:
        return CupertinoPageRoute(builder: (_) => const NewAddressPage());

      case AppRoutes.deliveryAddress:
        return CupertinoPageRoute(builder: (_) => const AddressPage());

      case AppRoutes.notifications:
        return CupertinoPageRoute(builder: (_) => const NotificationPage());

      case AppRoutes.settingsNotifications:
        return CupertinoPageRoute(
            builder: (_) => const NotificationSettingsPage());

      case AppRoutes.settings:
        return CupertinoPageRoute(builder: (_) => const SettingsPage());

      case AppRoutes.settingsLanguage:
        return CupertinoPageRoute(builder: (_) => const LanguageSettingsPage());

      case AppRoutes.changePassword:
        return CupertinoPageRoute(builder: (_) => const ChangePasswordPage());

      case AppRoutes.changePhoneNumber:
        return CupertinoPageRoute(
            builder: (_) => const ChangePhoneNumberPage());

      case AppRoutes.review:
        return CupertinoPageRoute(builder: (_) => const ReviewPage());

      case AppRoutes.submitReview:
        return CupertinoPageRoute(builder: (_) => const SubmitReviewPage());

      case AppRoutes.drawerPage:
        return CupertinoPageRoute(builder: (_) => const DrawerPage());

      case AppRoutes.aboutUs:
        return CupertinoPageRoute(builder: (_) => const AboutUsPage());

      case AppRoutes.termsAndConditions:
        return CupertinoPageRoute(
            builder: (_) => const TermsAndConditionsPage());

      case AppRoutes.faq:
        return CupertinoPageRoute(builder: (_) => const FAQPage());

      case AppRoutes.help:
        return CupertinoPageRoute(builder: (_) => const HelpPage());

      case AppRoutes.contactUs:
        return CupertinoPageRoute(builder: (_) => const ContactUsPage());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const EntryPointUI());
}
