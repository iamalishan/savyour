// import 'package:ecommerce_web/constants/app_imports.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewTrackingPage extends StatefulWidget {
//   final String url;
//   final FeedModel feed;
//
//   const WebViewTrackingPage({Key? key, required this.url, required this.feed}) : super(key: key);
//
//   @override
//   State<WebViewTrackingPage> createState() => _WebViewTrackingPageState();
// }
//
// class _WebViewTrackingPageState extends State<WebViewTrackingPage> {
//   late final WebViewController _controller;
//
//   final FeedsController feedController = Get.put(FeedsController());
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 value: double.parse(progress.toString()),
//               ),
//             );
//           },
//           onPageStarted: (String url) {
//             print('📄 Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             // if (url.contains("thankyou") || url.contains("thank-you")
//             //     || url.contains("thank_you") || url.contains("/thank_you")
//             // ) {
//             //   feedController.addFeed(
//             //       brandId: widget.feed.brandId,
//             //       type: 'product_buy',
//             //       userId: widget.feed.userId,
//             //       brandLogo: widget.feed.brandLogo,
//             //       url: widget.feed.url,
//             //       brandName: widget.feed.brandName,
//             //       timestamp: DateTime.now(),
//             //       title: widget.feed.title,
//             //       handle: widget.feed.handle,
//             //       image: widget.feed.image,
//             //       checkOutUrl: url
//             //   );
//             // }
//             },
//           onNavigationRequest: (NavigationRequest request) {
//             print('🔍 Navigating to: ${request.url}');
//             if (request.url.contains("thankyou") || request.url.contains("thank-you")
//                 || request.url.contains("thank_you") || request.url.contains("/thank_you")
//             ) {
//               feedController.addFeed(
//                 brandId: widget.feed.brandId,
//                 type: 'product_buy',
//                 userId: widget.feed.userId,
//                 brandLogo: widget.feed.brandLogo,
//                 url: widget.feed.url,
//                 brandName: widget.feed.brandName,
//                 timestamp: DateTime.now(),
//                 title: widget.feed.title,
//                 handle: widget.feed.handle,
//                 image: widget.feed.image,
//                 checkOutUrl: request.url
//               );
//             }
//
//             return NavigationDecision.navigate;
//           },
//           onWebResourceError: (WebResourceError error) {
//             print('❌ Web error: ${error.description}');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MobileNavbar(),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
