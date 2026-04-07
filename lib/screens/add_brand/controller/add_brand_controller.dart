import 'package:ecommerce_web/constants/app_imports.dart';

class AddBrandController extends GetxController {
  final nameTEC = TextEditingController();
  final imageTEC = TextEditingController();
  final descriptionTEC = TextEditingController();
  final urlTEC = TextEditingController();
  final priorityTEC = TextEditingController();

  final isLoading = false.obs;

  Future<void> addBrand() async {
    final name = nameTEC.text.trim();
    final image = imageTEC.text.trim();
    final desc = descriptionTEC.text.trim();
    final url = urlTEC.text.trim();
    final priority = int.tryParse(priorityTEC.text.trim()) ?? 0;

    if (name.isEmpty || image.isEmpty || desc.isEmpty || url.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields.");
      return;
    }

    isLoading(true);

    final id = FirebaseFirestore.instance.collection('brands').doc().id;

    final brand = Brand(
      id: id,
      name: name,
      imageUrl: image,
      links: [],
      description: desc,
      url: url,
      priority: priority,
    );

    try {
      await FirebaseFirestore.instance
          .collection('brands')
          .doc(id)
          .set(brand.toFireStore());

      Get.snackbar("Success", "Brand added successfully.");
      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Failed to add brand: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearFields() {
    nameTEC.clear();
    imageTEC.clear();
    descriptionTEC.clear();
    urlTEC.clear();
    priorityTEC.clear();
  }

  @override
  void onClose() {
    nameTEC.dispose();
    imageTEC.dispose();
    descriptionTEC.dispose();
    urlTEC.dispose();
    priorityTEC.dispose();
    super.onClose();
  }
}
