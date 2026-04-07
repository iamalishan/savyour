import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/common_widgets/widgets/hover_scale_wrapper.dart';
import 'package:ecommerce_web/screens/share_screen_shots/collection_story.dart';
import '../../search_in_brand/controller/search_in_brand_controller.dart';
import '../../share_screen_shots/collection_post.dart';
import '../controller/product_service_controller.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});

  final String collectionHandle = Get.parameters['collectionHandle']!;
  final String brandId = Get.parameters['brandId']!;
  final Brand? brand = Get.arguments.toString().contains("brand")
      ? Get.arguments['brand']
      : null;
  final Collection? collection = Get.arguments.toString().contains("collection")
      ? Get.arguments['collection']
      : null;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final productCon = Get.put(ProductServiceController());
  final searchInBrandCon = Get.put(SearchInBrandController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      productCon.isLiked.value = false;
      productCon.fetchData(
        widget.brandId,
        widget.collectionHandle,
        widget.brand,
        widget.collection,
      );
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productCon.controller.determinePlatform(context);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (searchInBrandCon.navbarSearchCon.searchHomeTEC.value.text.isEmpty) {
        productCon.loadMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () {
            productCon.toggleLike();
          },
          backgroundColor: productCon.isLiked.value
              ? Colors.grey.shade400
              : Colors.grey,
          elevation: 10,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              productCon.isLiked.value ? Icons.favorite : Icons.favorite,
              color: productCon.isLiked.value ? Colors.red : Colors.white,
            ),
          ),
        );
      }),
      appBar: productCon.controller.isMobWeb ? MobileNavbar() : null,
      drawer: CustomDrawer(selectedIndex: productCon.controller.mobNavbarIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Obx(
              () => productCon.isLoading.value
                  ? _buildLoadingShimmer()
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (productCon.controller.isWeb)
            NavBar(selectedIndex: productCon.controller.navbarIndex),
          // App bar header
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          // Loading shimmer grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: productCon.controller.isWeb ? 6 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: productCon.controller.isWeb ? 350 : 300,
              ),
              itemCount: 12,
              itemBuilder: (context, index) =>
                  const ProductShimmer(isDouble: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        if (productCon.controller.isWeb)
          NavBar(selectedIndex: productCon.controller.navbarIndex),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildAppBarSection(),
                const Divider(thickness: 1, color: Colors.grey, height: 20),
                if (searchInBrandCon.isLoading.value)
                  _buildCircularIndicator()
                else if (searchInBrandCon.fetchedProducts.isNotEmpty)
                  _buildSearchedProducts()
                else if (productCon.fetchedProducts.isNotEmpty)
                  _buildProductsGrid()
                else
                  _buildNoData(),

                // Pagination loading indicator
                Obx(() {
                  if (productCon.isLoadingMore.value) {
                    return _buildLoadMoreIndicator();
                  } else if (!productCon.hasMoreData.value &&
                      productCon.fetchedProducts.isNotEmpty) {
                    return _buildEndOfListIndicator();
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarSection() {
    return productCon.controller.isWeb? Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                final products = productCon.fetchedProducts;

                int totalImages = products.fold(0, (sum, product) => sum + product.images.length);

                if (totalImages < 5) {
                  print("Not enough product images to generate screenshot");
                  return;
                }

                Get.to(()=> CollectionPostScreenShot());
              },

              child: ReuseText(
                title: productCon.collection != null
                    ? Utils.replaceHyphensWithSpaces(
                        productCon.collection!.title.toUpperCase(),
                      )
                    : Utils.replaceHyphensWithSpaces(
                        widget.collectionHandle.toString().toUpperCase(),
                      ),
                fontSize: 17,
                fontWeight: FontWeight.w900,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 500,
            child: SearchField(
              controller: searchInBrandCon.searchTEC,
              onChanged: (val){
                searchInBrandCon.onSearchChanged(widget.brandId);
              },
              hintText: 'Search products in brand . . . ',
            ),
          ),
        ],
      ),
    ):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ReuseText(
                    title: productCon.collection != null
                        ? Utils.replaceHyphensWithSpaces(
                      productCon.collection!.title.toUpperCase(),
                    )
                        : Utils.replaceHyphensWithSpaces(
                      widget.collectionHandle.toString().toUpperCase(),
                    ),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
           SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: SearchField(
                controller: searchInBrandCon.searchTEC,
                onChanged: (val) {
                  searchInBrandCon.onSearchChanged(widget.brandId);
                },
                hintText: 'Search products in brand . . . ',
              ),
            ),
          ],
        );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEndOfListIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'No more products to load',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCircularIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSearchedProducts() {
    return SearchedProductsWidget(
      brandId: widget.brandId,
      brand: productCon.brand,
      isWeb: productCon.controller.isWeb,
      padding: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: productCon.controller.isWeb ? 6 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: productCon.controller.isWeb ? 350 : 300,
        ),
        itemCount: productCon.fetchedProducts.length,
        itemBuilder: (context, index) {
          final product = productCon.fetchedProducts[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                "/p/${product.handle}/${widget.brandId}",
                arguments: {
                  "product": product,
                  "brand": productCon.brand,
                  "collection": productCon.collection,
                },
              );
            },
            child: HoverScaleWrapper(
              scaleValue: 1.05,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: ReuseText(title: "No Products available"),
      ),
    );
  }
}
