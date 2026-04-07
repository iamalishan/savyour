import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import '../../../constants/app_imports.dart';
import '../search_controller/search_service_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    final searchController = Get.put(SearchServiceController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args['query'] != null) {
        final query = args['query'] as String;
        searchController.updateSearch(query);
      }
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
    final searchController = Get.put(SearchServiceController(isWeb: isWeb));

    return Scaffold(
      appBar: isWeb ? null : MobileNavbar(),
      drawer: CustomDrawer(selectedIndex: 0),
      body: SafeArea(
        child: Obx(() {
          final query = searchController.searchQuery.value;
          final brands = searchController.brandsToDisplay;
          final products = searchController.productsToDisplay;
          final isLoading =
              searchController.isLoadingBrands.value ||
                  searchController.isLoadingProducts.value;

          return Column(
            children: [
              if (isWeb) const NavBar(),
              _buildSearchHeader(),

              if (isLoading && brands.isEmpty && products.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50 &&
                          !searchController.isLoadingProducts.value &&
                          searchController.hasMoreProducts.value) {
                        debugPrint('🔁 Load more products triggered');
                        searchController.loadMoreProducts();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: searchController.productScrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (brands.isNotEmpty)
                            _buildBrandList(searchController, isWeb),
                          if (products.isNotEmpty)
                            _buildProductGrid(searchController, isWeb),
                          if (brands.isEmpty &&
                              products.isEmpty &&
                              query.length > 2)
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: Text("No results found.")),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Get.back();
            },
          ),
          const Expanded(
            child: Center(
              child: ReuseText(
                title: "Search",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBrandList(SearchServiceController controller, bool isWeb) {
    final brands = controller.brandsToDisplay;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: "Brands",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontColor: EcommerceTheme.mainColor,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: isWeb ? 130 : 95,
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                    !controller.isLoadingBrands.value &&
                    controller.hasMoreBrands.value) {
                  controller.loadMoreBrands();
                }
                return false;
              },
              child: ListView.separated(
                controller: controller.brandScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: brands.length + 1,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  if (index == brands.length) {
                    return Obx(() => controller.hasMoreBrands.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox());
                  }

                  final brand = brands[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      "/b/${brand.id}",
                      arguments: {"brand": brand},
                    ),
                    child: BrandBox(
                      brand: brand,
                      size: isWeb ? 100 : 70,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(SearchServiceController controller, bool isWeb) {
    final products = controller.productsToDisplay;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: "Products",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontColor: EcommerceTheme.mainColor,
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.hasMoreProducts.value
                ? products.length + 1
                : products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWeb ? 7 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              if (index == products.length &&
                  controller.hasMoreProducts.value) {
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ));
              }

              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    "/p/${product.productId.split('_').last}/${product.brandId}",
                  );
                },
                child: HoverScaleWrapper(
                  scaleValue: 1.05,
                  child: ProductBox(
                    isFBModel: true,
                    title: product.title,
                    newPrice: product.price.toString(),
                    netImg: product.images.isNotEmpty
                        ? product.images[0]
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
