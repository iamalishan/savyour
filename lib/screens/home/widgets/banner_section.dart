import 'package:ecommerce_web/constants/app_imports.dart';

class BannerSection extends StatelessWidget {
  final HomeController homeController;
  final BannerController bannerController;

  const BannerSection({
    Key? key,
    required this.homeController,
    required this.bannerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bannerController.isLoading.value) {
        return BannerShimmer();
      } else if (bannerController.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: bannerController.banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: InkWell(
                  onTap: () => homeController.handleOnTap(
                    () => Utils.navigateBasedOnUrl(
                      banner.brandId,
                      banner.url,
                      null,
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 240,
                    child: CachedNetworkImage(
                      imageUrl: banner.image,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/placeholderImage.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/placeholderImage.png",
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }
}
