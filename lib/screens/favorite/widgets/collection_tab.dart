import '../../../constants/app_imports.dart';
import '../controller/favorite_controller.dart';

class CollectionsTab extends StatelessWidget {
  const CollectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;
    final favoriteCon = Get.find<FavoriteController>();

    return Obx(() {
      final collections = favoriteCon.likedCollections;

      if (favoriteCon.isCollectionsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (collections.isEmpty) {
        return const Center(child: Text('No favorite collections found.'));
      }

      return Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: collections.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 350,
          ),
          itemBuilder: (context, index) {
            final collection = collections[index];
            final brandId = favoriteCon.userController.user.value?.likedCollectionData?[index].brandId;
            return GestureDetector(
              onTap: (){
                Get.toNamed(
                  "/c/${collection.handle}/$brandId",
                  arguments: {
                    "collection": collection,
                    "brand": null,
                  },
                );
              },
              child: BannerBox(
                title: collection.title,
                netImage: collection.image,
                subTitle: collection.description
                    .toString()
                    .trim()
                    .isEmpty
                    ? null
                    : collection.description.toString().trim(),
                products: collection.productsCount,
              ),
            );
          },
        ),
      );
    });
  }
}
