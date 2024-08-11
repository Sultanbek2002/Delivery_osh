import 'package:flutter/material.dart';

import '../../../core/components/app_back_button.dart';
import '../../../core/constants/app_colors.dart';
import 'components/custom_tab_label.dart';
import 'components/tab_all.dart';
import 'components/tab_completed.dart';
import 'components/tab_running.dart';

class AllOrderPage extends StatelessWidget {
  const AllOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Мои заказы'),
          bottom: const TabBar(
            physics: NeverScrollableScrollPhysics(),
            tabs: [
              CustomTabLabel(label: 'Полученные', value: ''),
              CustomTabLabel(label: 'Отмененные', value: ''),

            ],
          ),
        ),
        body: Container(
          color: AppColors.cardColor,
          child: const TabBarView(
            children: [
              ReceivedOrdersPage(),
              RunningTab(),
            ],
          ),
        ),
      ),
    );
  }
}
