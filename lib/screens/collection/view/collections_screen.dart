import 'package:ecommerce_web/common_widgets/cards/coupon_box.dart';

import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import '../../../constants/app_imports.dart';
import '../../search_in_brand/controller/search_in_brand_controller.dart';
import '../../share_screen_shots/brand_post.dart';
import '../collection_controller/collection_service_controller.dart';

class CollectionsScreen extends StatefulWidget {
  CollectionsScreen({super.key});

  final String brandId = Get.parameters['brandId']!;
  final Brand? brand = Get.arguments.toString().contains("brand")
      ? Get.arguments['brand']
      : null;

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final detailController = Get.put(DetailController());
  final collectionService = Get.put(CollectionServiceController());
  final searchInBrandCon = Get.put(SearchInBrandController());
  final passwordCon = Get.put(PasswordAlertController());

  final ScrollController _scrollController = ScrollController();

  final Map<String, IconData> _platformIcons = {
    'facebook': FontAwesomeIcons.facebook,
    'instagram': FontAwesomeIcons.instagram,
    'twitter': FontAwesomeIcons.twitter,
    'youtube': FontAwesomeIcons.youtube,
  };

  final Map<String, Color> _platformColors = {
    'facebook': Colors.blueAccent,
    'instagram': Colors.purple,
    'twitter': Colors.black,
    'youtube': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionService.isLiked.value = false;
      collectionService.fetchData(widget.brandId, widget.brand);
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (searchInBrandCon.navbarSearchCon.searchHomeTEC.value.text.isEmpty) {
        collectionService.loadMoreCollections();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () {
            collectionService.toggleLike();
          },
          backgroundColor: collectionService.isLiked.value
              ? Colors.grey.shade400
              : Colors.grey,
          elevation: 10,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              collectionService.isLiked.value ? Icons.favorite : Icons.favorite,
              color: collectionService.isLiked.value
                  ? Colors.red
                  : Colors.white,
            ),
          ),
        );
      }),
      appBar: detailController.isMobWeb ? MobileNavbar() : null,
      drawer: CustomDrawer(selectedIndex: detailController.mobNavbarIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Obx(
              () => collectionService.isLoading.value
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
          if (detailController.isWeb)
            GetBuilder<DetailController>(
              builder: (controller) =>
                  NavBar(selectedIndex: controller.navbarIndex),
            ),
          const HeaderShimmer(),
          const SizedBox(height: 20),
          // Show featured shimmer only when featured collections are loading
          if (collectionService.isLoadingFeatured.value)
            _buildFeaturedShimmers(),
          const ProductShimmer(isDouble: true),
          const ProductShimmer(isDouble: true),
          const ProductShimmer(isDouble: true),
        ],
      ),
    );
  }

  Widget _buildFeaturedShimmers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Container(
            height: 30,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  width: detailController.isWeb
                      ? Get.width / 2.9
                      : Get.width / 1.5,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.white,
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContent() {
    final brand = collectionService.brand;
    final collections = collectionService.fetchedCollections;

    return Column(
      children: [
        if (detailController.isWeb)
          GetBuilder<DetailController>(
            builder: (controller) =>
                NavBar(selectedIndex: controller.navbarIndex),
          ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandDetail(brand),

                  if (searchInBrandCon.isLoading.value)
                    _buildCircularIndicator()
                  else if (searchInBrandCon.fetchedProducts.isNotEmpty)
                    _buildSearchedProducts()
                  else ...[
                    if (collectionService.isLoadingCoupons.value)
                      _buildCouponShimmer()
                    else if (collectionService.coupons.isNotEmpty)
                      _buildCouponsList(),
                    if (collectionService.isLoadingFeatured.value)
                      _buildFeaturedShimmers()
                    else if (collectionService.featuredCollections.isNotEmpty)
                      _buildFeaturedCollectionsPart(),

                    if (collections.isNotEmpty)
                      _buildCollectionsPart(collections)
                    else if (!collectionService.isLoadingFeatured.value &&
                        collectionService.featuredCollections.isEmpty)
                      _buildNoData(),

                    // Pagination loading indicator
                    Obx(() {
                      if (collectionService.isLoadingMore.value) {
                        return _buildLoadMoreIndicator();
                      } else if (!collectionService.hasMoreData.value &&
                          collections.isNotEmpty) {
                        return _buildEndOfListIndicator();
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
      child: SizedBox(
        height: 65,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              width: 160,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCouponsList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: 'Available Coupons:',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontColor: EcommerceTheme.mainColor,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: collectionService.coupons.length,
              itemBuilder: (context, index) {
                final coupon = collectionService.coupons[index];
                return SmallCouponBox(coupon: coupon).marginOnly(right: 10);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCollectionsPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ReuseText(
            title: 'Featured Collections :',
            fontSize: 20,
            fontColor: EcommerceTheme.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 175,
          child: ListView.builder(
            itemCount: collectionService.featuredCollections.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              var collection = collectionService.featuredCollections[index];
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: detailController.isWeb
                      ? Get.width / 2.9
                      : Get.width / 1.5,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        "/c/${collection.handle}/${widget.brandId}",
                        arguments: {
                          "collection": collection,
                          "brand": collectionService.brand,
                        },
                      );
                    },
                    child: FeaturedCollectionBox(
                      height: 170,
                      width: detailController.isWeb
                          ? Get.width / 2.9
                          : Get.width / 1.5,
                      title: collection.title,
                      netImage: collection.image,
                      subTitle: collection.description.toString().trim().isEmpty
                          ? null
                          : collection.description.toString().trim(),
                      products: collection.productsCount,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
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
          'No more collections to load',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: ReuseText(title: "No Data available"),
      ),
    );
  }

  Widget _buildCollectionsPart(List<Collection> collections) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: 'Collections :',
            fontSize: 20,
            fontColor: EcommerceTheme.mainColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: detailController.isWeb ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 340,
            ),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              var collection = collections[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    "/c/${collection.handle}/${widget.brandId}",
                    arguments: {
                      "collection": collection,
                      "brand": collectionService.brand,
                    },
                  );
                },
                child: HoverScaleWrapper(
                  scaleValue: 1.05,
                  child: BannerBox(
                    title: collection.title,
                    netImage: collection.image,
                    subTitle: collection.description.toString().trim().isEmpty
                        ? null
                        : collection.description.toString().trim(),
                    products: collection.productsCount,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchedProducts() {
    return SearchedProductsWidget(
      brandId: widget.brandId,
      brand: collectionService.brand,
      isWeb: detailController.isWeb,
      padding: const EdgeInsets.all(16),
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

  Widget _buildBrandDetail(Brand? brand) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Obx(() {
              return Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: CachedImage(
                  imageUrl: collectionService.coverImage.value ?? '',
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30),
              child: IconContainer(
                iconColor: Colors.black,
                backgroundColor: Colors.white,
                icon: Icons.arrow_back,
                onTap: () {
                  Get.back();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 130, left: 40),
              child: GestureDetector(
                onTap: () {
                  passwordCon.handleTap(context, 'addCoupon', brand);
                },
                child: ClipOval(
                  child: Container(
                    height: 90,
                    width: 90,
                    color: Colors.grey.shade300,
                    child: collectionService.brand!.imageBase64 != null ?
                    Image.memory(base64Decode(collectionService.brand!.imageBase64!),fit: BoxFit.cover,):
                    CachedImage(imageUrl: brand?.imageUrl ?? ''),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: GestureDetector(
                  onLongPressUp: () {
                    final validImages = collectionService.fetchedCollections
                        .map((c) => c.image)
                        .where((img) => img != null && img!.isNotEmpty)
                        .toList();

                    if (validImages.length >= 6) {
                      Get.to(() => BrandPostScreenShot());
                    } else {
                      print('Insufficient Images');
                    }
                  },
                  child: ReuseText(
                    title: brand?.name ?? "",
                    fontSize: 24,
                    maxLines: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    brand?.links.map((link) {
                      String platform = '';
                      if (link.contains('facebook.com'))
                        platform = 'facebook';
                      else if (link.contains('instagram.com'))
                        platform = 'instagram';
                      else if (link.contains('twitter.com'))
                        platform = 'twitter';
                      else if (link.contains('youtube.com') ||
                          link.contains('youtube'))
                        platform = 'youtube';

                      if (platform.isNotEmpty) {
                        return _socialIcon(
                          _platformIcons[platform]!,
                          link,
                          _platformColors[platform]!,
                        ).marginOnly(left: 10);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }).toList() ??
                    [],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (detailController.isWeb)
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ReuseText(
                    title: brand?.description ?? "",
                    fontSize: 16,
                    maxLines: 5,
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: SearchField(
                    controller: searchInBrandCon.searchTEC,
                    onChanged: (val) {
                      searchInBrandCon.onSearchChanged(widget.brandId);
                    },
                    hintText: 'Search products in brand . . . ',
                  ),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width,
                  child: SearchField(
                    controller: searchInBrandCon.searchTEC,
                    onChanged: (val) {
                      searchInBrandCon.onSearchChanged(widget.brandId);
                    },
                    hintText: 'Search products in brand . . . ',
                  ),
                ),
                SizedBox(height: 10),
                ReuseText(
                  title: brand?.description ?? "",
                  fontSize: 16,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: Colors.grey.shade400, height: 10),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String url, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch $url');
        }
      },
      child: Icon(icon, color: color),
    );
  }
}
