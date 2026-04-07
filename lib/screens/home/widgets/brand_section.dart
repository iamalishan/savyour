import 'package:ecommerce_web/constants/app_imports.dart';

import '../../web_home/widgets/section_header.dart';

class BrandSection extends StatelessWidget {
  final BrandsController brandController;
  final VoidCallback onViewAll;

  const BrandSection({
    Key? key,
    required this.brandController,
    required this.onViewAll,
  }) : super(key: key);

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
            height: 100,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
              ),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
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
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text("View All"),
          ),
        ],
      ),
    );
  }
}
