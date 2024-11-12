import 'package:flutter/material.dart';
import 'package:grocery/generated/l10n.dart';
import '../../core/components/app_back_button.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).privacy_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Внешний отступ для всего содержимого
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).privacy_intro,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20), // Отступ между блоками
            _buildSection(context, S.of(context).privacy_section1_title, S.of(context).privacy_section1_content),
            const Divider(height: 30, thickness: 1), // Разделитель между секциями
            _buildSection(context, S.of(context).privacy_section2_title, S.of(context).privacy_section2_content),
            const Divider(height: 30, thickness: 1),
            _buildSection(context, S.of(context).privacy_section3_title, S.of(context).privacy_section3_content),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8), // Отступ между заголовком и контентом
        Text(
          content,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
