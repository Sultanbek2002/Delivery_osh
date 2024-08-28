import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import 'package:grocery/views/entrypoint/entrypoint_ui.dart';
import 'package:grocery/views/save/empty_save_page.dart';

import '../../core/components/network_image.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/utils/ui_util.dart';

class OrderSuccessfullPage extends StatelessWidget {
  const OrderSuccessfullPage({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    // Перенаправление на главную страницу при нажатии кнопки "Назад"
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const EntryPointUI()),
      (route) => false,
    );
    return false; // Возвращаем false, чтобы предотвратить закрытие текущего экрана
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Column(
          children: [
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(
                    'https://i.imgur.com/Fj9gVGy.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  Text(
                    S.of(context).order_success,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                    child: Text(
                      "${S.of(context).order_success_phrase}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          UiUtil.openDialog(
                            context: context,
                            widget: const EntryPointUI(),
                          );
                        },
                        child: Text(S.of(context).home),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          UiUtil.openDialog(
                            context: context,
                            widget: const EmptySavePage(),

                          );
                        },
                        child: Text(S.of(context).orders),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
