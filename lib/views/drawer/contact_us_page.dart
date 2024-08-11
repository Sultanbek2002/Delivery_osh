import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/network_image.dart';
import '../../core/constants/constants.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Связь с разработчиками'),
      ),
      backgroundColor: AppColors.cardColor,
      body: Container(
        margin: const EdgeInsets.all(AppDefaults.padding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppDefaults.padding),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Связь с разработчиками',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            const SizedBox(height: AppDefaults.padding * 2),

            /// Number
            Row(
              children: [
                SvgPicture.asset(AppIcons.contactPhone),
                const SizedBox(width: AppDefaults.padding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+996700276475',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: AppDefaults.padding / 2),
                    Text(
                      '+996703421521',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDefaults.padding),
            Row(
              children: [
                SvgPicture.asset(AppIcons.contactEmail),
                const SizedBox(width: AppDefaults.padding),
                Text(
                  'sulanbekabdykadyrov69@gmail.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),

            const SizedBox(height: AppDefaults.padding),
            Row(
              children: [
                SvgPicture.asset(AppIcons.contactMap),
                const SizedBox(width: AppDefaults.padding),
                Text(
                  'Араванский\nОш, Кыргызстан',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDefaults.padding),
            
          ],
        ),
      ),
    );
  }
}
