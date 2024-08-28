import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';

import '../../../core/constants/constants.dart';
import 'bottom_app_bar_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onNavTap,
  }) : super(key: key);

  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: AppDefaults.margin,
      color: AppColors.scaffoldBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomAppBarItem(
            name: S.of(context).home,
            iconLocation: AppIcons.home,
            isActive: currentIndex == 0,
            onTap: () => onNavTap(0),
          ),
          BottomAppBarItem(
            name: S.of(context).dr_menu,
            iconLocation: AppIcons.menu,
            isActive: currentIndex == 1,
            onTap: () => onNavTap(1),
          ),
          const Padding(
            padding: EdgeInsets.all(AppDefaults.padding * 2),
            child: SizedBox(width: AppDefaults.margin),
          ),
          /* <---- We have to leave this 3rd index (2) for the cart item -----> */

          BottomAppBarItem(
            name: S.of(context).order,
            iconLocation: AppIcons.save,
            isActive: currentIndex == 3,
            onTap: () => onNavTap(3),
          ),
          BottomAppBarItem(
            name: S.of(context).profile,
            iconLocation: AppIcons.profile,
            isActive: currentIndex == 4,
            onTap: () => onNavTap(4),
          ),
        ],
      ),
    );
  }
}
