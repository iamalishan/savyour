import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  // final DetailRepository _repository = DetailRepository();

  // Loading states
  final RxBool _isLoading = false.obs;
  final RxBool _isNotifierLoading = false.obs;
  final RxBool _isHomeLoading = false.obs;
  final RxBool _isWeb = false.obs;
  final RxBool _isMobWeb = false.obs;

  // Navigation indices
  final RxInt _navbarIndex = 0.obs;
  final RxInt _mobNavbarIndex = 0.obs;

  // Response states
  // Rx<UserLikesResponse?> likes = Rx<UserLikesResponse?>(null);
  // Rx<LikesResponse?> collectionLikes = Rx<LikesResponse?>(null);
  // Rx<LikesResponse?> productLikes = Rx<LikesResponse?>(null);
  // Rx<PriceNotificationResponse?> priceResponse = Rx<PriceNotificationResponse?>(null);
  // Rx<PriceHistoryResponse?> priceHistory = Rx<PriceHistoryResponse?>(null);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isNotifierLoading => _isNotifierLoading.value;
  bool get isHomeLoading => _isHomeLoading.value;
  bool get isWeb => _isWeb.value;
  bool get isMobWeb => _isMobWeb.value;
  int get navbarIndex => _navbarIndex.value;
  int get mobNavbarIndex => _mobNavbarIndex.value;

  // Setters
  void setIsLoading(bool value) => _isLoading.value = value;
  void setIsNotifierLoading(bool value) => _isNotifierLoading.value = value;
  void setIsHomeLoading(bool value) => _isHomeLoading.value = value;
  void setIsWeb(bool value) => _isWeb.value = value;
  void setIsMobWeb(bool value) => _isMobWeb.value = value;
  void setNavbarIndex(int value) => _navbarIndex.value = value;
  void setMobNavbarIndex(int value) => _mobNavbarIndex.value = value;

  String newProductId = "";

  void determinePlatform(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if(width < 500){
      setIsMobWeb(true);
    }else{
      setIsWeb(true);
    }
  }


// // User Likes Methods
  // Future<void> getUserLikes() async {
  //   setIsLoading(true);
  //   likes.value = await _repository.getUserLikes();
  //   setIsLoading(false);
  // }
  //
  // Future<bool> getCollectionLikes(String collectionId) async {
  //   setIsLoading(true);
  //   final response = await _repository.getCollectionLikes(collectionId);
  //   setIsLoading(false);
  //
  //   if (response != null) {
  //     collectionLikes.value = response;
  //     return true;
  //   }
  //   return false;
  // }
  //
  // Future<bool> getProductLikes(String productId) async {
  //   setIsLoading(true);
  //   final response = await _repository.getProductLikes(productId);
  //   setIsLoading(false);
  //
  //   if (response != null) {
  //     productLikes.value = response;
  //     return true;
  //   }
  //   return false;
  // }
  //
  // Future<bool> addToLike(String? collectionId, String? productId) async {
  //   if (productId != null) newProductId = productId;
  //
  //   setIsLoading(true);
  //   final success = await _repository.addToLike(collectionId, productId);
  //
  //   if (success && productId != null) {
  //     await getProductLikes(newProductId);
  //   }
  //
  //   setIsLoading(false);
  //   return success;
  // }
  //
  // Future<bool> removeLike(String? collectionId, String? productId) async {
  //   if (productId != null) newProductId = productId;
  //
  //   setIsLoading(true);
  //   final success = await _repository.removeLike(collectionId, productId);
  //
  //   if (success && productId != null) {
  //     await getProductLikes(newProductId);
  //   }
  //
  //   setIsLoading(false);
  //   return success;
  // }
  //
  // // Token Methods
  // Future<bool> addToken(String productId) async {
  //   setIsNotifierLoading(true);
  //   final success = await _repository.addToken(productId);
  //   setIsNotifierLoading(false);
  //   return success;
  // }
  //
  // Future<bool> removeToken(String productId) async {
  //   setIsNotifierLoading(true);
  //   final success = await _repository.removeToken(productId);
  //   setIsNotifierLoading(false);
  //   return success;
  // }
  //
  // // Price Methods
  // Future<void> comparePrice(String productId, double price) async {
  //   setIsLoading(true);
  //   priceResponse.value = await _repository.comparePrice(productId, price);
  //   setIsLoading(false);
  // }
  //
  // Future<void> priceHistoryFunc(String itemId, double price) async {
  //   setIsLoading(true);
  //   await _repository.savePriceHistory(itemId, price);
  //   setIsLoading(false);
  // }
  //
  // Future<void> getPrices(String itemId) async {
  //   setIsLoading(true);
  //   priceHistory.value = await _repository.getPriceHistory(itemId);
  //   setIsLoading(false);
  // }
}