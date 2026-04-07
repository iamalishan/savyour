import 'dart:async';
import 'package:ecommerce_web/common_widgets/widgets/full_image_dialog.dart';
import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';

class WebImagesScroller extends StatefulWidget {
  const WebImagesScroller({super.key});

  @override
  State<WebImagesScroller> createState() => _WebImagesScrollerState();
}

class _WebImagesScrollerState extends State<WebImagesScroller> {
  final controller = Get.find<ProductDetailController>();
  final PageController pageController = PageController();
  Timer? autoScrollTimer;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  void startAutoScroll() {
    autoScrollTimer = Timer.periodic(const Duration(seconds: 9), (timer) {
      if (controller.numPages.value == 0) return;

      final nextPage = (controller.currentPage.value + 1) % controller.numPages.value;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 3),
        curve: Curves.easeInOut,
      );
      controller.currentPage.value = nextPage;
    });
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: controller.numPages.value,
      onPageChanged: (int page) {
        controller.currentPage.value = page;
      },
      itemBuilder: (context, index) {
        final imageUrl = controller.product?.images[index].src ?? '';

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => FullImageDialog(imageUrl: imageUrl),
            );
          },
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Image.asset(
              "assets/images/placeholderImage.png",
              fit: BoxFit.fitHeight,
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/placeholderImage.png",
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
