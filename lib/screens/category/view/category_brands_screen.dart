import 'package:ecommerce_web/constants/app_imports.dart';

class CategoryBrandsScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const CategoryBrandsScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<CategoryBrandsScreen> createState() => _CategoryBrandsScreenState();
}

class _CategoryBrandsScreenState extends State<CategoryBrandsScreen> {
  final CategoryBrandsController brandsController = Get.put(
    CategoryBrandsController(),
  );
  final DetailController detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await brandsController.fetchBrands(widget.categoryId);

      FirebaseAnalyticsUtil.analyticLogEvent(
        name: "category_view",
        parameters: {
          "category_id": widget.categoryId,
          "category_name": widget.title,
        },
      );
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
      drawer: CustomDrawer(selectedIndex: detailController.mobNavbarIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Column(
              children: [
                if (detailController.isWeb)
                  NavBar(selectedIndex: detailController.navbarIndex),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ),
                              Expanded(
                                child: SearchField(
                                  hintText: "Search Brand",
                                  onChanged: brandsController.updateSearchText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ReuseText(
                            title: widget.title,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                          const SizedBox(height: 10),
                          const ReuseText(
                            title: "All Brands:",
                            fontColor: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.shade300,
                            height: 0,
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (brandsController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final filteredBrands =
                                brandsController.filteredBrands;

                            if (filteredBrands.isEmpty) {
                              return const Center(
                                child: Text("No brands found"),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: detailController.isWeb
                                        ? 7
                                        : 3,
                                  ),
                              itemCount: filteredBrands.length,
                              itemBuilder: (context, index) {
                                var brand = filteredBrands[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed("/b/${brand.id}");
                                  },
                                  child: BrandBox(
                                    brand: brand,
                                    size: detailController.isWeb ? 100 : 70,
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
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
}
