import 'package:ecommerce_web/screens/share_screen_shots/collection_post.dart';
import 'package:ecommerce_web/screens/product_detail/controller/product_detail_controller.dart';

import '../../../constants/app_imports.dart';

class ShareButton extends StatelessWidget {
  ShareButton({
    super.key,
  });

  final controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await SharePlus.instance.share(
          ShareParams(
            text:
            "https://savyour.io/p/${controller.product!.handle}/${controller.brand!.id}",
          ),
        );
        if (result.status == ShareResultStatus.success) {
          FirebaseAnalyticsUtil.analyticLogEvent(name: 'shared',
          parameters: {
            'shared_type': 'product',
            'brand_id': controller.brand!.id,
            'brand_name': controller.brand!.name,
            'product_id': controller.product!.handle,
            'product_name': controller.product!.title,
          }
          );
        }
      },
      onLongPressUp: (){
      },
      child: Material(
        elevation: 5,
        shape: CircleBorder(),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.share),
        ),
      ),
    );
  }
}
