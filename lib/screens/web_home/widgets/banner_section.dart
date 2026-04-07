import 'package:ecommerce_web/constants/app_imports.dart';

class BannerSection extends StatefulWidget {
  final BannerController bannerController;

  BannerSection({required this.bannerController});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final _carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.bannerController.isLoading.value) {
        return BannerShimmer();
      } else if(widget.bannerController.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      final banners = widget.bannerController.banners;

      return Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: Get.height / 2,
              viewportFraction: 1.0,
              autoPlay: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: banners.map((banner) {
              return InkWell(
                onTap: () => Utils.handleOnTap(() =>
                    Utils.navigateBasedOnUrl(banner.brandId, banner.url, null)),
                child: CachedNetworkImage(
                  imageUrl: banner.image,
                  placeholder: (context, url) => Image.asset(
                    "assets/images/placeholderImage.png",
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: Get.height,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/placeholderImage.png",
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: Get.height,
                  ),
                  fit: BoxFit.cover,
                  width: Get.width,
                  height: Get.height,
                ),
              );
            }).toList(),
          ),

          // Left arrow
          Positioned(
            left: 16,
            child: _ArrowButton(
              icon: Icons.arrow_back_ios,
              onTap: () {
                _carouselController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),

          // Right arrow
          Positioned(
            right: 16,
            child: _ArrowButton(
              icon: Icons.arrow_forward_ios,
              onTap: () {
                _carouselController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      shape: const CircleBorder(),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
    );
  }
}
