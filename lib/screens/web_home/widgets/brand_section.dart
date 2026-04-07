import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/web_home/widgets/section_header.dart';

class BrandSection extends StatelessWidget {
  final BrandsController brandController;

  BrandSection({required this.brandController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (brandController.isLoading.value) {
        return const BrandShimmer();
      } else if (brandController.brands.isEmpty) {
        return const SizedBox.shrink();
      }

      final brands = brandController.brands;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
              title: "Top Brands",
              onViewAll: () => Get.toNamed(AppRoutes.brand),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
              ),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: brands.length >= 10 ? 10 : brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed("/b/${brand.id}",
                    arguments: {
                      "brand": brand,
                    }
                    );
                  },
                  child: BrandBox(
                    brand: brand,
                    size: 100,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
