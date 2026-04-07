import 'dart:async';
import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';

class ImagesScroller extends StatefulWidget {
  const ImagesScroller({super.key});

  @override
  State<ImagesScroller> createState() => _ImagesScrollerState();
}

class _ImagesScrollerState extends State<ImagesScroller> {
  final controller = Get.find<ProductDetailController>();
  late final PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      final itemCount = controller.product?.images.length ?? 0;
      if (itemCount == 0) return;

      int nextPage = (_pageController.page?.round() ?? 0) + 1;
      if (nextPage >= itemCount) nextPage = 0;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      controller.currentPage.value = nextPage;
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: controller.product?.images.length ?? 0,
      onPageChanged: (int page) {
        controller.currentPage.value = page;
      },
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Your image detail navigation code here (currently commented out)
          },
          child: CachedNetworkImage(
            imageUrl: controller.product!.images[index].src,
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
