import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';

class ShopBottomButton extends StatelessWidget {
  ShopBottomButton({super.key, required this.context});

  final BuildContext context;

  final productCon = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width - 20,
          child: ElevatedButton(
            onPressed: () async {
              Utils.launchBrandProduct(
                "${productCon.brand!.url}/products/${productCon.product!.handle}",
                FeedModel(
                  type: 'product_buy',
                  brandId: productCon.brand!.id,
                  brandLogo: productCon.brand!.imageUrl ?? '',
                  url: '${productCon.brand!.url}/products/${productCon.product!.handle}',
                  brandName: productCon.brand!.name,
                  timestamp: DateTime.now(),
                  title: productCon.product!.title,
                  image: productCon.product!.images.first.src,
                  userId: Utils.userId!,
                  id: '',
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReuseText(
                  title: "Shop",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(width: 10),
                Transform.rotate(
                  angle: 45,
                  child: Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
