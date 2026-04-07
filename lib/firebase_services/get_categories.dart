import 'package:ecommerce_web/constants/app_imports.dart';

class CategoriesController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('category').get();

      categories.value = snapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? imageBase64;

  // final String description;
  final int priority;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    // required this.description,
    required this.priority,
    this.imageBase64
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    return CategoryModel(
      id: doc['id'],
      name: doc['name'],
      imageUrl: doc['image'],
      // description: doc['description'],
      priority: doc['priority'],
      imageBase64: doc['imageBase64']
    );
  }
}
