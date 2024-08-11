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
        borderRadius: AppDefaults.borderRadius,
        color: AppColors.scaffoldBackground,
        child: InkWell(
          borderRadius: AppDefaults.borderRadius,
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
              border: Border.all(width: 0.1, color: AppColors.placeholder),
              borderRadius: AppDefaults.borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding / 2),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      '${ApiConsts.urlbase}/images/${data['image']}',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                data['ru_name'] != null && data['ru_name'].isNotEmpty
                    ? data['ru_name']
                    : 'Название отсутствует',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black),
                maxLines: 2,
                
              ),

              const SizedBox(height: 4), // Увеличьте отступ, если необходимо

                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data['price']} cом',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}