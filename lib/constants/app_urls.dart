class AppUrls {
  // Base Urls
  static const baseUrl = "karkhaany.com";
  static const dataUrl = "script.google.com";
  static const path =
      "/macros/s/AKfycbxsOdWgHhvz56GiCTYEbqtzKQJnuhKRm8hRl4p2SnDtgM8qvQ80ce7QVUrUJLW1Sj07FQ/exec";
  static const singlePath =
      "/macros/s/AKfycbykaV60psDkrKc5ze3toRSJRk5acW0rjX4rvvL56PGGZFxPFLcWtVTmn13JCkaO91FPSQ/exec";

  // EndPoints
  static const getLikes = "/ecommerce/get_likes.php";
  static const comparePrice = "/ecommerce/notify/compare_price.php";
  static const addToLike = "/ecommerce/likes/add_to_like.php";
  static const removeLike = "/ecommerce/likes/remove_like.php";
  static const addToken = "/ecommerce/notify/add_token.php";
  static const removeToken = "/ecommerce/notify/remove_token.php";
  static const getPrices = "/ecommerce/prices/get_prices.php";
  static const priceHistory = "/ecommerce/prices/price_history.php";

  static String getProducts(String url, String handle) {
    return "$url/collections/$handle";
  }

  static String getSingleProduct(
    String productUrl,
  ) {
    return productUrl;
  }

  // New Urls
  static String getBaseUrl(String type){
    return "https://$type-ly73sndtja-uc.a.run.app/";
  }
}
