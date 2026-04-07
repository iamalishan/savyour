import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import '../../../constants/app_imports.dart';
import '../controller/search_in_brand_controller.dart';

class SearchInBrandView extends StatefulWidget {
  SearchInBrandView({super.key});

  final String brandId = Get.arguments['brandId']!;

  final Brand? brand = Get.arguments.toString().contains("brand")
      ? Get.arguments['brand']
      : null;

  @override
  State<SearchInBrandView> createState() => _SearchInBrandViewState();
}

class _SearchInBrandViewState extends State<SearchInBrandView> {
  final controller = Get.put(SearchInBrandController());
  final detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchProducts(widget.brandId, mainBrand: widget.brand);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;

    return Scaffold(
      appBar: isWeb ? null : MobileNavbar(),
      drawer: CustomDrawer(selectedIndex: 0),
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWeb) const NavBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back),
                    SizedBox(
                      height: 40,
                      width: 400,
                      child: SearchField(
                        hintText: 'Search in ${controller.brand.value?.name ?? "Brand"}',
                        // controller: controller.searchTEC,
                        onChanged: (_) => controller.onSearchChanged(widget.brandId),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isBrandLoading.value)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: HeaderShimmer(),
                )
              else if (controller.brand.value != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: CachedImage(imageUrl: controller.brand.value!.imageUrl ?? ""),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ReuseText(
                              title: controller.brand.value!.name,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ReuseText(
                        title: controller.brand.value!.description ?? "",
                        fontSize: 16,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey.shade400, height: 10),
              if (controller.isLoading.value && controller.fetchedProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (controller.fetchedProducts.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: isWeb ? 350 : 300,
                    ),
                    itemCount: controller.fetchedProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.fetchedProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            "/p/${product.productUrl.extractProductHandle()}/${controller.brand.value!.id}",
                            arguments: {
                              'brand': controller.brand.value,
                            },
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
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
