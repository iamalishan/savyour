import 'package:ecommerce_web/constants/app_imports.dart';

class ProductBox extends StatelessWidget {
  ProductBox({
    super.key,
    this.netImg,
    this.imgUrl = "assets/images/placeholderImage.png",
    this.title = "",
    this.description,
    this.newPrice,
    this.oldPrice,
    this.discount = 0,
    this.isFavorite = false,
    this.isFBModel = false,
  });

  final String? netImg;
  final String imgUrl;
  final String title;
  final String? description;
  final String? newPrice;
  final String? oldPrice;
  final int discount;
  final bool isFavorite;
  final bool isFBModel;

  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: netImg ?? '',
              placeholder: (context, url) => Image.asset(
                "assets/images/placeholderImage.png",
                fit: BoxFit.cover,
                height: detailController.isWeb ? 240 : 200,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/placeholderImage.png",
                fit: BoxFit.cover,
                height: detailController.isWeb ? 240 : 200,
              ),
              height: detailController.isWeb ? 240 : 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 130,
          child: ReuseText(
            title: title,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            maxLines: description != null ? isFBModel? 1: 2 : 2,
          ),
        ),
        if (description != null)
          ReuseText(
            title: description!,
            fontColor: Colors.grey.shade600,
            maxLines: 1,
            fontSize: 12,
          ),
        ReuseText(
          title: "Rs: ${newPrice ?? ''}",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontColor: Colors.red,
        ),
        if (oldPrice != null && oldPrice != newPrice)
          Row(
            children: [
              ReuseText(
                title: "Rs: $oldPrice",
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
              const SizedBox(
                width: 5,
              ),
              if (discount > 0)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ReuseText(
                    title: "-$discount%",
                    fontColor: Colors.red,
                    fontSize: 12,
                  ),
                )
            ],
          )
      ],
    );
  }
}
