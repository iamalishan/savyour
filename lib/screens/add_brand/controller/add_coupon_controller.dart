import 'package:ecommerce_web/constants/app_imports.dart';

class AddCouponController extends GetxController {
  final couponCodeTEC = TextEditingController();
  final percentageTEC = TextEditingController();
  final brandIdTEC = TextEditingController();
  final brandNameTEC = TextEditingController();
  final brandLogoTEC = TextEditingController();

  final isLoading = false.obs;

  void initialize(Brand brand) {
    brandIdTEC.text = brand.id;
    brandNameTEC.text = brand.name;
    brandLogoTEC.text = brand.imageUrl ?? '';
  }

  Future<void> addCoupon() async {
    final code = couponCodeTEC.text.trim();
    final percentage = percentageTEC.text.trim();
    final brandId = brandIdTEC.text.trim();
    final brandName = brandNameTEC.text.trim();
    final brandLogo = brandLogoTEC.text.trim();

    if (code.isEmpty ||
        percentage.isEmpty ||
        brandId.isEmpty ||
        brandName.isEmpty ||
        brandLogo.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields.");
      return;
    }

    isLoading(true);

    final id = FirebaseFirestore.instance.collection('coupon').doc().id;

    final coupon = Coupon(
      id: id,
      brandId: brandId,
      brandLogo: brandLogo,
      brandName: brandName,
      coupon: code,
      disabled: false,
      expired: false,
      money: null,
      percentage: percentage,
      addedDate: DateTime.now()
    );

    try {
      await FirebaseFirestore.instance
          .collection('coupons')
          .doc(id)
          .set(coupon.toFireStore());

      Get.snackbar("Success", "Coupon added successfully.");
      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Failed to add coupon: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearFields() {
    couponCodeTEC.clear();
    percentageTEC.clear();
  }

  @override
  void onClose() {
    couponCodeTEC.dispose();
    percentageTEC.dispose();
    brandIdTEC.dispose();
    brandNameTEC.dispose();
    brandLogoTEC.dispose();
    super.onClose();
  }
}
