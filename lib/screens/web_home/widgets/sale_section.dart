import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/web_home/widgets/section_header.dart';

class SaleSection extends StatelessWidget {
  final SalesController saleController;

  SaleSection({required this.saleController});

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
          SectionHeader(title: "On Sale", onViewAll: () {
            Get.toNamed(AppRoutes.sale);
          }),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: sales.length > 15 ? 15 : sales.length,
                itemBuilder: (context, index) {
                  var sale = sales[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SalesBox(
                      sale: sale,
                    ),
                  );
                }),
          )
        ],
      );
    });
  }
}