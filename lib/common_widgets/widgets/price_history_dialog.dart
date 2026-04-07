// import 'package:ecommerce_web/constants/app_imports.dart';
//
// class PriceHistoryDialog extends StatefulWidget {
//   const PriceHistoryDialog({
//     super.key,
//     required this.brandImage,
//     required this.productTitle,
//     required this.productHandle,
//     required this.brandId,
//   });
//
//   final String brandImage;
//   final String productTitle;
//   final String productHandle;
//   final String brandId;
//
//   @override
//   State<PriceHistoryDialog> createState() => _PriceHistoryDialogState();
// }
//
// class _PriceHistoryDialogState extends State<PriceHistoryDialog> {
//   DetailController controller = Get.put(DetailController());
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // controller.getPrices("${widget.brandId}_${widget.productHandle}");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AlertDialog(
//         content: SizedBox(
//           height: 500,
//           width: 500,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: const Icon(Icons.arrow_back, size: 20)),
//                     const SizedBox(width: 15),
//                     const ReuseText(
//                       title: "Price History",
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 thickness: 1,
//                 height: 0,
//                 color: Colors.grey,
//               ),
//               Obx(() {
//                 if (controller.priceHistory.value == null) {
//                   return controller.isLoading
//                       ? const Expanded(
//                           child: Center(child: CircularProgressIndicator()))
//                       : const Expanded(
//                           child: Center(
//                             child: ReuseText(
//                               title: "No price history available!",
//                               fontSize: 12,
//                             ),
//                           ),
//                         );
//                 } else {
//                   final prices = controller.priceHistory.value!.prices;
//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: prices.length,
//                       itemBuilder: (context, index) {
//                         final priceEntry = prices[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     ClipOval(
//                                       child: CachedNetworkImage(
//                                         imageUrl: widget.brandImage,
//                                         placeholder: (context, url) =>
//                                             Image.asset(
//                                           "assets/images/placeholderImage.png",
//                                           height: 50,
//                                           width: 50,
//                                         ),
//                                         errorWidget: (context, url, error) =>
//                                             Image.asset(
//                                           "assets/images/placeholderImage.png",
//                                           height: 50,
//                                           width: 50,
//                                         ),
//                                         height: 50,
//                                         width: 50,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     ReuseText(
//                                       maxLines: 2,
//                                       fontSize: 10,
//                                       title: widget.productTitle,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   // Price
//                                   ReuseText(
//                                     title: "Rs: ${priceEntry.price}",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w900,
//                                     fontColor: Colors.red,
//                                   ),
//                                   // Date and Time
//                                   ReuseText(
//                                     title: priceEntry.dateTime,
//                                     fontSize: 9,
//                                     fontColor: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
