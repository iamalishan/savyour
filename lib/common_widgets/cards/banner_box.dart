import 'package:ecommerce_web/constants/app_imports.dart';

class BannerBox extends StatelessWidget {
  BannerBox({
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

  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: detailController.isWeb ? 690 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: EcommerceTheme.primaryColor,
            gradient: LinearGradient(colors: [
              EcommerceTheme.mainColor.withAlpha(10),
              EcommerceTheme.primaryColor
            ],
            begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  height: isSingle ? 400 : 240,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/placeholderImage.png",
                                  fit: detailController.isWeb
                                      ? BoxFit.fitWidth
                                      : BoxFit.fitHeight,
                                  height: isSingle ? 400 : 240,
                                ),
                                height: isSingle ? 400 : 240,
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
                                      Colors.black26,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.4, 0.6],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Container(
                  //     width: 120,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(8)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(2),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           Icon(Icons.info_outline),
                  //           ReuseText(
                  //             title: "CONDITIONS",
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 13,
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 0,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         ReuseText(
                  //           title: "Up to",
                  //           fontColor: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //         Row(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             ReuseText(
                  //               title: "${offAmount}%",
                  //               fontColor: Colors.white,
                  //               fontSize: 30,
                  //               fontWeight: FontWeight.w900
                  //             ),
                  //             SizedBox(width: 5,),
                  //             ReuseText(
                  //               title: "OFF",
                  //               fontColor: Colors.white,
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w700,
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    if (logoUrl != null)
                      ClipOval(
                        child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: logoUrl!,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/placeholderImage.png",
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/placeholderImage.png",
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover,
                            )),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: detailController.isWeb ? 200 : Get.width / 3,
                          child: ReuseText(
                            title: title,
                            fontWeight: FontWeight.w900,
                            maxLines: subTitle != null ? 1 : 2,
                          ),
                        ),
                        if (subTitle != null)
                          SizedBox(
                            width: detailController.isWeb ? 200 : 70,
                            child: ReuseText(
                              title: subTitle!,
                              fontColor: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              maxLines: 1,
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (products != null)
                          ReuseText(
                            title: "Products : $products",
                            fontSize: 12,
                            fontColor: Colors.red,
                          )
                      ],
                    ),
                    const Spacer(),
                    if (visitStore)
                      SizedBox(
                        height: 25,
                        width: 90,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: EcommerceTheme.mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: visitTap,
                          child: const ReuseText(
                            title: "Explore",
                            fontColor: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
