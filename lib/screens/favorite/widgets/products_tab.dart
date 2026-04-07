import '../../../constants/app_imports.dart';
import '../controller/favorite_controller.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;
    final favoriteCon = Get.find<FavoriteController>();

    return Obx(() {
      final products = favoriteCon.likedProducts;

      if (favoriteCon.isProductsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (products.isEmpty) {
        return const Center(child: Text('No favorite products found.'));
      }

      return Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 7 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 350,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final brandId = favoriteCon.userController.user.value?.likedProductData?[index].brandId;
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  "/p/${product.handle}/$brandId",
                  arguments: {
                    "product": product,
                    "brand": null,
                    "collection": null,
                  },
                );
              },
                child: ProductBox(
                  title: product.title,
                  description: product.description.toString().trim().isEmpty
                      ? null
                      : product.description.toString().trim(),
                  newPrice: product.variants.first.price,
                  oldPrice: product.variants.first.compareAtPrice,
                  discount: product.variants.first.discount ?? 0,
                  netImg: product.images.first.src,
                ),
            );
          },
        ),
      );
    });
  }
}
