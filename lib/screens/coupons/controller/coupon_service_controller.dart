import 'dart:async';
import 'package:ecommerce_web/constants/app_imports.dart';

class CouponServiceController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<Coupon> loadedCoupons = <Coupon>[].obs;
  RxList<Coupon> searchedCoupons = <Coupon>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxString searchText = ''.obs;
  RxInt limit = 20.obs;

  final bool isWeb;
  Timer? _debounce;

  CouponServiceController({this.isWeb = false}) {
    limit.value = isWeb ? 40 : 20;
    _initScrollListener();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange &&
          !isLoading.value &&
          hasMore.value) {
        loadMoreCoupons();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> loadCoupons() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance.collection('coupons');
      QuerySnapshot querySnapshot;

      if (searchText.value.length > 2) {
        final search = searchText.value.capitalizeEachWord();

        query = query
            .where('brandName', isGreaterThanOrEqualTo: search)
            .where('brandName', isLessThanOrEqualTo: search + '\uf8ff');

        querySnapshot = await query.limit(limit.value).get();

        searchedCoupons.value = querySnapshot.docs
            .map((doc) => Coupon.fromFireStore(doc))
            .toList();
      } else {
        querySnapshot = await query
            .orderBy('addedDate', descending: true)
            .limit(limit.value)
            .get();

        loadedCoupons.value = querySnapshot.docs
            .map((doc) => Coupon.fromFireStore(doc))
            .toList();
      }

      hasMore.value = (searchText.value.length > 2
          ? searchedCoupons.length
          : loadedCoupons.length) ==
          limit.value;
    } catch (e) {
      print('Error loading Coupons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreCoupons() {
    limit.value += isWeb ? 40 : 20;
    loadCoupons();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchedCoupons.clear();
      limit.value = isWeb ? 40 : 20;
      hasMore.value = true;
      loadCoupons();
    });
  }

  List<Coupon> get couponsToDisplay =>
      searchText.value.length > 2 ? searchedCoupons : loadedCoupons;
}
