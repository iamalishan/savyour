import 'package:ecommerce_web/constants/app_imports.dart';

class SalesBox extends StatelessWidget {
  SalesBox({super.key, required this.sale, this.isAdmin = false});

  final Sale sale;
  final bool isAdmin;

  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!sale.ended) {
          Utils.navigateBasedOnUrl(sale.brandId, sale.url,null);
        }
      },
      child: Container(
        width: detailController.isWeb? 200: 150,
        height: detailController.isWeb? 200: 150,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(60),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: sale.imageUrl ?? '',
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
              ),
            ),
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Colors.black38,
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                    )),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black54,
                    Colors.transparent
                  ],
                  begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        height: detailController.isWeb? 30: 25,
                        width: detailController.isWeb? 30: 25,
                        color: Colors.white,
                        child: CachedImage(imageUrl: sale.brandLogo),
                      ),
                    ),
                    SizedBox(width: 7,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReuseText(
                            title: sale.name,
                            fontColor: Colors.white,
                            fontSize: detailController.isWeb? 13: 11,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                          ),
                          ReuseText(
                            title: sale.brandName,
                            fontColor: Colors.white70,
                            fontSize: detailController.isWeb? 11: 9,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (sale.ended)
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black54),
                child: Center(
                  child: ReuseText(
                    title: "Ended",
                    fontSize: 9,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
