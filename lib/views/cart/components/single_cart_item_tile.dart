import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleCartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final void Function(Map<String, dynamic>) onUpdateQuantity;
  final void Function(Map<String, dynamic>) onRemove;

  const SingleCartItemTile({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
  }) : super(key: key);

  Future<String> _getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ?? 'ru';
  }

  @override
  Widget build(BuildContext context) {
    int quantity = item['quantity'] ?? 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Thumbnail
              SizedBox(
                width: 70,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(
                    'https://dostavka.arendabook.com/images/${item['image']}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              /// Quantity and Name
              FutureBuilder<String>(
                future: _getLanguageCode(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final languageCode = snapshot.data!;

                  print(languageCode);
                  final itemNameKey = languageCode == 'ru' ? 'ru_name' : 'name';
                  print(itemNameKey);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item[itemNameKey],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              '$quantity кг.', // Ensure that "kg" is translated if needed
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                quantity -= 1;
                                item['quantity'] = quantity;
                                onUpdateQuantity(item);
                              }
                            },
                            icon: SvgPicture.asset(AppIcons.removeQuantity),
                            constraints: const BoxConstraints(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$quantity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              quantity += 1;
                              item['quantity'] = quantity;
                              onUpdateQuantity(item);
                            },
                            icon: SvgPicture.asset(AppIcons.addQuantity),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
              const Spacer(),

              /// Price and Delete label
              Column(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      onRemove(item);
                    },
                    icon: SvgPicture.asset(AppIcons.delete),
                  ),
                  const SizedBox(height: 16),
                  Text('${item['price']} сом'),
                ],
              )
            ],
          ),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }
}
