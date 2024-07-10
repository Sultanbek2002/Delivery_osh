// import 'package:flutter/material.dart';
// import '../constants/constants.dart';
// import '../models/product_model.dart';
// import '../routes/app_routes.dart';
// import 'network_image.dart';

// class BundleTileSquare extends StatelessWidget {
//   const BundleTileSquare({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   final ProductModel data;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.scaffoldBackground,
//       borderRadius: AppDefaults.borderRadius,
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(context, AppRoutes.bundleProduct);
//         },
//         borderRadius: AppDefaults.borderRadius,
//         child: Container(
//           width: 176,
//           padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//           decoration: BoxDecoration(
//             border: Border.all(width: 0.1, color: AppColors.placeholder),
//             borderRadius: AppDefaults.borderRadius,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: AspectRatio(
//                   aspectRatio: 1 / 1,
//                   child: NetworkImageWithLoader(
//                     data.image,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.title,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.black),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     data.description,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Text(
//                     '\$${data.price.toStringAsFixed(2)}',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.black),
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
