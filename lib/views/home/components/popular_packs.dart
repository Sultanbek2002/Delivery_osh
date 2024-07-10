import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/apis/api_product.dart';
import '../../../core/components/bundle_tile_square.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/models/product_model.dart';

class PopularPacks extends StatefulWidget {
  const PopularPacks({Key? key}) : super(key: key);

  @override
  _PopularPacksState createState() => _PopularPacksState();
}

class _PopularPacksState extends State<PopularPacks> {
  late Future<List<ProductModel>> _futureProducts;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.fetchProducts();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndActionButton(
          title: 'Популярные продукты',
          onTap: () => Navigator.pushNamed(context, AppRoutes.popularItems),
        ),
        FutureBuilder<List<ProductModel>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No popular packs found'));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: AppDefaults.padding),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppDefaults.padding),
                      child: BundleTileSquare(data: product),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({Key? key, required this.data}) : super(key: key);

  final ProductModel data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          if (data != null) {
            print("dsafkjasjkfnajkfansdkfjdsaf");
            print(data);
            Navigator.pushNamed(
              context,
              AppRoutes.productDetails,
              arguments: data,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid product details')),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 176,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${data.price} сом',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
