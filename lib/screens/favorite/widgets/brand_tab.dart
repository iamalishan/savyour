import '../../../constants/app_imports.dart';
import '../controller/favorite_controller.dart';

class BrandsTab extends StatelessWidget {
  BrandsTab({super.key});

  final favoriteCon = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;

    return Obx(() {
      final brands = favoriteCon.likedBrands;

      if (favoriteCon.isBrandsLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: EcommerceTheme.mainColor,),
        );
      }
      else if (brands.isEmpty) {
        return const Center(
          child: Text('No favorite brands found.'),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: brands.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 8 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 300,
          ),
          itemBuilder: (context, index) {
            var brand = brands[index];
            return GestureDetector(
                onTap: (){
                  Get.toNamed("/b/${brand.id}", arguments: {"brand": brand});
                  },
                child: BrandBox(brand: brand));
          },
        ),
      );
    });
  }
}
