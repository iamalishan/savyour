import 'package:ecommerce_web/constants/app_imports.dart';

import '../../web_home/widgets/section_header.dart';

class SaleSection extends StatelessWidget {
  final SalesController saleController;
  final VoidCallback onViewAll;

  const SaleSection({
    super.key,
    required this.saleController,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (saleController.isLoading.value) {
        return const BrandShimmer();
      } else if (saleController.sales.isEmpty) {
        return const SizedBox.shrink();
      }

      final sales = saleController.sales;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "On Sale",
            onViewAll: () => Get.toNamed(AppRoutes.sale),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 155,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: sales.length > 8 ? 8 : sales.length,
              itemBuilder: (context, index) {
                var sale = sales[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SalesBox(
                    sale: sale,
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
