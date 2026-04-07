import 'package:ecommerce_web/constants/app_imports.dart';

class FeaturedCollectionBox extends StatelessWidget {
  FeaturedCollectionBox({
    super.key,
    this.netImage,
    this.logoUrl,
    this.title = "Amazon",
    this.subTitle,
    this.offAmount = 25,
    this.products,
    this.visitStore = false,
    this.storeUrl,
    this.visitTap,
    this.isSingle = false,
    this.isFillImage = true,
    this.height = 240,
    required this.width,
  });

  final String? netImage;
  final String? logoUrl;
  final String title;
  final String? subTitle;
  final int offAmount;
  final int? products;
  final bool visitStore;
  final String? storeUrl;
  final VoidCallback? visitTap;
  final bool isSingle;
  final bool isFillImage;
  final double height;
  final double width;

  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          // width: detailController.isWeb ? 690 : null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [
                EcommerceTheme.mainColor.withAlpha(50),
                EcommerceTheme.primaryColor
              ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      color: EcommerceTheme.primaryColor,
                      width: Get.width,
                      child: CachedNetworkImage(
                        imageUrl: netImage ?? '',
                        placeholder: (context, url) => Image.asset(
                          "assets/images/placeholderImage.png",
                          fit: detailController.isWeb
                              ? BoxFit.fitWidth
                              : BoxFit.fitHeight,
                          height: isSingle ? 400 : height,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/placeholderImage.png",
                          fit: detailController.isWeb
                              ? BoxFit.fitWidth
                              : BoxFit.fitHeight,
                          height: isSingle ? 400 : height,
                        ),
                        height: isSingle ? 400 : height,
                        fit: detailController.isWeb
                            ? isFillImage? BoxFit.cover: BoxFit.fitWidth
                            : BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black45,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.4, 0.6],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: ReuseText(
                            title: title,
                            fontColor: Colors.white,
                            fontSize: detailController.isWeb? 21: 18,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
