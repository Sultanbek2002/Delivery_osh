import 'package:flutter/material.dart';
import 'package:grocery/views/api_routes/apis.dart';

import '../constants/constants.dart';

import '../routes/app_routes.dart';
import 'network_image.dart';

class ProductTileSquare extends StatelessWidget {
  const ProductTileSquare({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Material(
        borderRadius: BorderRadius.circular(15), // Скругленные углы
        color: Color.fromARGB(255, 239, 249, 240), // Белый фон
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.productDetails, 
            arguments: data, // Передача данных как Map
          ),
          child: Container(
            width: 180,
            height: 310,
            padding: const EdgeInsets.all(AppDefaults.padding),
            decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Центровка
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Скругление изображения
                    child: Image.network(
                      '${ApiConsts.urlbase}/images/${data['image']}',
                      fit: BoxFit.cover, // Обрезка изображения по размеру контейнера
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Отступ между изображением и текстом
                Text(
                  data['ru_name'] != null && data['ru_name'].isNotEmpty
                      ? data['ru_name']
                      : 'Название отсутствует',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center, // Центровка текста
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  '${data['price']} сом',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
