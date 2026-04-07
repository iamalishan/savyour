import 'package:ecommerce_web/common_widgets/widgets/hover_scale_wrapper.dart';
import 'package:ecommerce_web/constants/app_imports.dart';

import '../controller/category_service_controller.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final CategoryServiceController categoryServiceController = Get.put(
    CategoryServiceController(),
  );
  final DetailController detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailController.setMobNavbarIndex(2);
      detailController.setNavbarIndex(2);
      categoryServiceController.loadCategories();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                                  hintText: "Search Category",
                                  controller: _searchController,
                                  onChanged:
                                      categoryServiceController.onSearchChanged,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const ReuseText(
                            title: "All Categories:",
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.shade300,
                            height: 0,
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (categoryServiceController.isLoading.value &&
                                categoryServiceController.categoryList.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: detailController.isWeb ? 5 : 3,
                                mainAxisSpacing: detailController.isWeb ? 20 : 10,
                                crossAxisSpacing: detailController.isWeb ? 20 : 10,
                              ),
                              itemCount: categoryServiceController.categoryList.length,
                              itemBuilder: (context, index) {
                                final category = categoryServiceController.categoryList[index];
                                return HoverScaleWrapper(
                                  scaleValue: 1.05,
                                  child: CategoryBox(
                                    title: category.name,
                                    imageUrl: category.imageBase64,
                                    categoryId: category.id,
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
