import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/web_home/widgets/section_header.dart';

class CategorySection extends StatelessWidget {
  final CategoriesController categoryController;

  CategorySection({required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.value) {
        return const ProductShimmer();
      } else if (categoryController.categories.isEmpty) {
        return const SizedBox.shrink();
      }

      final categories = categoryController.categories;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: "Top Categories",
              onViewAll: () => Get.toNamed(AppRoutes.category)),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length >= 10 ? 10 : categories.length,
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryBox(
                      title: category.name,
                      imageUrl: category.imageBase64,
                      isListView: true,
                      categoryId: category.id,
                    ),
                  );
                }),
          )
        ],
      );
    });
  }
}
