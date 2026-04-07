import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import '../../../constants/app_imports.dart';
import '../../screens/search_in_brand/controller/search_in_brand_controller.dart';

class SearchedProductsWidget extends StatelessWidget {
  final String brandId;
  final Brand? brand;
  final bool isWeb;
  final EdgeInsets? padding;

  const SearchedProductsWidget({
    super.key,
    required this.brandId,
    required this.brand,
    required this.isWeb,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final searchInBrandCon = Get.find<SearchInBrandController>();

    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWeb ? 6 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: isWeb ? 350 : 300,
        ),
        itemCount: searchInBrandCon.fetchedProducts.length,
        itemBuilder: (context, index) {
          final product = searchInBrandCon.fetchedProducts[index];
          return _buildProductItem(product);
        },
      ),
    );
  }

  Widget _buildProductItem(dynamic product) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          "/p/${product.productUrl.extractProductHandle()}/$brandId",
          arguments: {'brand': brand},
        );
      },
      child: HoverScaleWrapper(
        scaleValue: 1.05,
        child: ProductBox(
          title: product.productTitle,
          description: null,
          newPrice: product.price.toString(),
          netImg: product.imageUrl,
        ),
      ),
    );
  }
}