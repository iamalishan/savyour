import 'package:ecommerce_web/constants/app_imports.dart';

class CategoryServiceController extends GetxController {
  final DetailController detailController = Get.put(DetailController());

  List<CategoryModel> categories = [];
  String _searchText = '';
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    detailController.determinePlatform(Get.context!);
  }

  Future<void> loadCategories() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance
          .collection('category')
          .orderBy('priority');

      QuerySnapshot querySnapshot = await query.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      if (_searchText.isNotEmpty) {
        docs = docs.where((doc) {
          final name = doc['name'].toString().toLowerCase();
          return name.contains(_searchText.toLowerCase());
        }).toList();
      }

      categories = docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    _searchText = value;
    loadCategories();
  }

  List<CategoryModel> get categoryList => categories;
}
