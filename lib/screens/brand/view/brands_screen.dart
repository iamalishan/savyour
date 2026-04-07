import 'package:ecommerce_web/constants/app_imports.dart';
import '../controller/brand_service_controller.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final DetailController detailController = Get.put(DetailController());

  final BrandServiceController brandController = Get.put(
    BrandServiceController(isWeb: true),
  );
  final passwordCon = Get.put(PasswordAlertController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailController.setMobNavbarIndex(1);
      detailController.setNavbarIndex(1);
      brandController.loadBrands();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailController.isMobWeb ? MobileNavbar() : null,
      drawer: Obx(
        () => CustomDrawer(selectedIndex: detailController.mobNavbarIndex),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Column(
              children: [
                Obx(() {
                  if (detailController.isWeb) {
                    return NavBar(selectedIndex: detailController.navbarIndex);
                  }
                  return const SizedBox.shrink();
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 10),
                        Obx(() {
                          final brands = brandController.brandsToDisplay;

                          return Expanded(
                            child: GridView.builder(
                              controller: brandController.scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: detailController.isWeb
                                        ? 8
                                        : 3,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    mainAxisExtent: detailController.isWeb
                                        ? 130
                                        : 100,
                                  ),
                              itemCount:
                                  brands.length +
                                  (brandController.isLoading.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < brands.length) {
                                  return _buildBrandItem(brands[index]);
                                } else {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 20),
  //         child: GestureDetector(
  //           onTap: () => Get.back(),
  //           child: const Icon(Icons.arrow_back),
  //         ),
  //       ),
  //       // Expanded(
  //       //   child: SearchField(
  //       //     hintText: "Search Brand",
  //       //     // controller: brandController.searchController,
  //       //     onChanged: brandController.onSearchChanged,
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            GestureDetector(
              onTap: (){
                passwordCon.handleTap(context, 'addBrand', null);
              },
              child: const ReuseText(
                title: "All Brands:",
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (widget.isAdmin)
          const ReuseText(
            title: "Select a brand to proceed !",
            fontSize: 13,
            fontColor: Colors.red,
          ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: Colors.grey.shade300, height: 0),
      ],
    );
  }

  Widget _buildBrandItem(Brand brand) {
    final size = detailController.isWeb ? 100.0 : 70.0;

    // if (isAdmin) {
    //   return GestureDetector(
    //     onTap: () {
    //       Get.to(() => WebViewScreen(
    //         url: brand.url,
    //         name: brand.name,
    //         brandId: brand.id,
    //       ));
    //     },
    //     child: BrandBox(
    //       brand: brand,
    //       size: size,
    //     ),
    //   );
    // }

    return GestureDetector(
      onTap: () {
        Get.toNamed("/b/${brand.id}", arguments: {"brand": brand});
      },
      child: BrandBox(brand: brand, size: size),
    );
  }
}
