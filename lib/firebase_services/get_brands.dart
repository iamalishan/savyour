import 'package:ecommerce_web/constants/app_imports.dart';

class BrandsController extends GetxController {
  var brands = <Brand>[].obs;
  var isLoading = true.obs;
  var selectedBrand = Rxn<Brand>();

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  // ==================== Fetch Single Brand ====================
  Future<Brand>? fetchBrand(String brandId) async {
    Brand? brand;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .get();

      if (doc.exists) {
        brand = Brand.fromFireStore(doc);
      }
    } catch (e) {
      print("Error fetching brand: $e");
    }
    return brand!;
  }


  // ==================== Fetch Multiple Brands ====================
  Future<List<Brand>> fetchBrands() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('brands')
          .orderBy("priority", descending: true)
          .get();

      brands.value = snapshot.docs.map((doc) {
        return Brand.fromFireStore(doc);
      }).toList();
      return brands;
    } catch (e) {
      print("Error fetching brands: $e");
      return brands;
    } finally {
      isLoading(false);
    }
  }

}