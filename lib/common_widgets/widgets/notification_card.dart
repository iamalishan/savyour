import '../../constants/app_imports.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});


  @override
  Widget build(BuildContext context) {
    final bool isReduced = notification.oldPrice > notification.newPrice;
    final isWeb = Get.width > 500;
    return GestureDetector(
      onTap: (){
        Get.toNamed('/p/${notification.handle}/${notification.brandId}');
      },
      child: SizedBox(
        width: isWeb? Get.width / 2: Get.width,
        child: Card(
          color: Colors.grey.shade100,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon(item["icon"], color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuseText(
                        title: notification.title,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      ReuseText(
                        title: isReduced? 'Product price was reduced from ${notification.oldPrice.toStringAsFixed(0)} to ${notification.newPrice.toStringAsFixed(0)}' :
                        'Price increased from ${notification.oldPrice.toStringAsFixed(2)} to ${notification.newPrice.toStringAsFixed(2)}',
                        fontSize: 13,
                        maxLines: 4,
                        fontColor: Colors.black87,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('hh:mm a').format(notification.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
