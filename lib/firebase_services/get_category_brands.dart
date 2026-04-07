import 'package:ecommerce_web/constants/app_imports.dart';

class CategoryBrandsController extends GetxController {
  var brands = <Brand>[].obs;
  var isLoading = true.obs;
  var searchText = ''.obs;

  Future<void> fetchBrands(String categoryId) async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('brands')
          .where('category_id', isEqualTo: categoryId)
          .get();

      brands.value = snapshot.docs.map((doc) {
        return Brand.fromFireStore(doc);
      }).toList();
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      isLoading(false);
    }
  }

  List<Brand> get filteredBrands {
    if (searchText.value.isEmpty) {
      return brands;
    }
    return brands.where((brand) {
      return brand.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  void updateSearchText(String value) {
    searchText(value);
  }
}
