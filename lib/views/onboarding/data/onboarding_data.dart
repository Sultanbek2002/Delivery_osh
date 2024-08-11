import '../../../core/constants/app_images.dart';
import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> items = [
    OnboardingModel(
      imageUrl: AppImages.onboarding1,
      headline: 'Много различных продуктов',
      description:
          '',
    ),
    OnboardingModel(
      imageUrl: AppImages.onboarding2,
      headline: 'В удобное и любое время',
      description:
          '',
    ),
    OnboardingModel(
      imageUrl: AppImages.onboarding3,
      headline: 'Быстрая доставка на ваш адрес',
      description:
          '',
    ),
  ];
}
