import 'package:ecommerce_web/constants/app_imports.dart';

class CouponsController extends GetxController {
  var coupons = <Coupon>[].obs;
  var isLoading = true.obs;
  var selectedCoupon = Rxn<Coupon>();

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  // ==================== Fetch Single Coupon ====================
  Future<Coupon?> fetchCoupon(String couponId) async {
    Coupon? coupon;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('coupons')
          .doc(couponId)
          .get();

      if (doc.exists) {
        coupon = Coupon.fromFireStore(doc);
        selectedCoupon.value = coupon;
      }
    } catch (e) {
      print("Error fetching coupon: $e");
    }
    return coupon;
  }

  // ==================== Fetch Multiple Coupons ====================
  Future<List<Coupon>> fetchCoupons() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coupons')
          .orderBy("addedDate", descending: true)
          .get();

      coupons.value = snapshot.docs.map((doc) {
        return Coupon.fromFireStore(doc);
      }).toList();
      return coupons;
    } catch (e) {
      print("Error fetching coupons: $e");
      return coupons;
    } finally {
      isLoading(false);
    }
  }

  // ==================== Fetch Coupons By Brand ID ====================
  Future<List<Coupon>> fetchCouponsByBrandId(String brandId) async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coupons')
          .where('brandId', isEqualTo: brandId)
          // .orderBy('addedDate', descending: true)
          .get();

      List<Coupon> brandCoupons = snapshot.docs.map((doc) {
        return Coupon.fromFireStore(doc);
      }).toList();

      return brandCoupons;
    } catch (e) {
      print("Error fetching coupons by brandId: $e");
      return [];
    } finally {
      isLoading(false);
    }
  }

}
