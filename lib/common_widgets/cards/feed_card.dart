import '../../constants/app_imports.dart';

class FeedCard extends StatelessWidget {
  final FeedModel feed;

  const FeedCard({super.key, required this.feed});

  String getFeedSubtext(FeedModel feed) {
    String personType = feed.userId != Utils.userId ? 'Someone' : 'You';

    switch (feed.type) {
      case 'product_like':
        return '$personType liked ${feed.title ?? "this product"} from ${feed.brandName}';
      case 'brand_like':
        return '$personType liked ${feed.brandName}';
      case 'collection_like':
        return '$personType liked the ${feed.title ?? "collection"} collection from ${feed.brandName}';
      case 'price_changed':
        if (feed.oldPrice != null && feed.newPrice != null) {
          final oldPrice = double.tryParse(feed.oldPrice!) ?? 0;
          final newPrice = double.tryParse(feed.newPrice!) ?? 0;
          final action = newPrice < oldPrice ? "reduced" : "increased";
          return 'Price $action for ${feed.title}: $oldPrice → $newPrice';
        }
        return 'Price changed for ${feed.title}';
      case 'sale_added':
        return 'Sale is live on ${feed.brandName}';
        case 'product_buy':
        return '$personType bought ${feed.title ?? "this product"} from ${feed.brandName}';
      default:
        return 'Activity on ${feed.brandName}';
    }
  }

  void onFeedPress() {
    switch (feed.type) {
      case 'brand_like':
        Get.toNamed("/b/${feed.brandId}");
      case 'collection_like':
      case 'sale_added':
        Get.toNamed("/c/${feed.handle}/${feed.brandId}");
      case 'price_changed':
      case 'product_like':
      case 'product_buy':
        Get.toNamed("/p/${feed.handle}/${feed.brandId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = Get.width > 500;
    return GestureDetector(
      onTap: () {
       onFeedPress();
      },
      child: SizedBox(
        width: isWeb ? Get.width / 2 : Get.width,
        child: Card(
          color: Colors.grey.shade100,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedImage(imageUrl: feed.image, width: 100, height: 80),
                    if (feed.type != 'brand_like') ...[
                      SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: CachedImage(
                                imageUrl: feed.brandLogo,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ReuseText(
                                title: feed.brandName,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                maxLines: 1,
                                fontColor: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseText(
                        title: feed.title,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      ReuseText(
                        title: getFeedSubtext(feed),
                        fontSize: 13,
                        fontColor: Colors.black87,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  feed.timestamp.timeAgo(),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
