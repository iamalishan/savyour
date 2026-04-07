import 'package:ecommerce_web/constants/app_imports.dart';

class ImageDetail extends StatefulWidget {
  const ImageDetail({
    super.key,
    required this.images,
    required this.brandImage,
    required this.productTitle,
    required this.newPrice,
    this.oldPrice = "",
    this.discount = 0,
    required this.productId,
    required this.brandId,
    required this.isLiked,
    required this.isNotified,
    required this.likesCount,
  });

  final List<String> images;
  final String brandImage;
  final String productTitle;
  final String newPrice;
  final String? oldPrice;
  final int? discount;
  final String productId;
  final String brandId;
  final bool isLiked;
  final bool isNotified;
  final int likesCount;

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  late PageController _pageController;
  int _currentPage = 0;
  late bool _isLiked;
  late bool _isNotified;
  late int _likesCount;
  final DetailController controller = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isLiked = widget.isLiked;
    _isNotified = widget.isNotified;
    _likesCount = widget.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Image PageView
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.7, 1.0])),
                    ),
                  ],
                );
              },
            ),

            // Image counter
            Positioned(
              top: 20,
              left: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ReuseText(
                  title: "${_currentPage + 1}/${widget.images.length}",
                  fontColor: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),

            // Brand info and price
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ReuseText(
                            title: "Rs: ${widget.newPrice}",
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            fontColor: Colors.white,
                          ),
                          if (widget.oldPrice.toString().isNotEmpty)
                            Row(
                              children: [
                                const ReuseText(
                                  title: " / ",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  fontColor: Colors.white,
                                ),
                                ReuseText(
                                  title: "Rs: ${widget.oldPrice}",
                                  fontSize: 11,
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (widget.oldPrice.toString().isNotEmpty)
                        Row(
                          children: [
                            const ReuseText(
                              title: "Sale OFF ",
                              fontColor: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ReuseText(
                                title: "${widget.discount}%",
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.grey, // Set the background color here
                          child: widget.brandImage == null
                              ? Image.asset(
                                  "assets/images/placeholderImage.png",
                                  height: 50,
                                  width: 50,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.brandImage,
                                  placeholder: (context, url) => Image.asset(
                                    "assets/images/placeholderImage.png",
                                    fit: BoxFit.fitHeight,
                                    height: 50,
                                    width: 50,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/placeholderImage.png",
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                                  fit: BoxFit.contain,
                                  height: 50,
                                  width: 50,
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: Get.width - 90,
                        child: ReuseText(
                          maxLines: 2,
                          fontSize: 12,
                          title: widget.productTitle,
                          fontColor: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Positioned(
              right: 10,
              bottom: 100,
              child: Column(
                children: [
                  _buildActionButton(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.white,
                    onTap: _handleLike,
                    label: "$_likesCount",
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    icon: Icons.notifications,
                    color: _isNotified ? Colors.red : Colors.white,
                    onTap: _handleNotification,
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    icon: Icons.share,
                    color: Colors.white,
                    onTap: _handleShare,
                  ),
                ],
              ),
            ),

            // Back button
            Positioned(
              top: 20,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ReuseText(
                title: label,
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  void _handleLike() async {
    // if (_isLiked) {
    //   setState(() {
    //     _isLiked = false;
    //   });
    //   _isLiked = !await controller.removeLike(
    //       null, "${widget.brandId}_${widget.productId}");
    //   controller.productLikes.value = null;
    //   _likesCount--;
    // } else {
    //   setState(() {
    //     _isLiked = true;
    //   });
    //   _isLiked = await controller.addToLike(
    //       null, "${widget.brandId}_${widget.productId}");
    //   _likesCount++;
    // }
    // setState(() {});
  }

  void _handleShare() async {
    // // Implement the same share logic as in ProductDetailScreen
    // final result = await Share.share(
    //     "https://savyour.io?code=p&id=${widget.brandId}_${widget.productId}");
    // if (result.status == ShareResultStatus.success) {
    //   print("shared success");
    // }
  }

  void _handleNotification() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          return ConfirmationAlert(
            controller: TextEditingController(),
            title: _isNotified ? "Alert !" : "Information !",
            isNoButton: true,
            onFirstTap: () {
              Navigator.of(context).pop();
            },
            isLoading: controller.isNotifierLoading,
            subTitle: _isNotified
                ? "Do you want to remove this product?"
                : "Are you sure about getting notification ?",
            onSecondTap: () async {
              // bool result;
              // if (_isNotified) {
              //   result = await controller.removeToken(
              //       "${widget.brandId}_${widget.productId}");
              // } else {
              //   result = await controller.addToken(
              //       "${widget.brandId}_${widget.productId}");
              // }
              // if (result) {
              //   setState(() {
              //     _isNotified = !_isNotified;
              //   });
              //   Navigator.of(context).pop();
              // }
            },
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
