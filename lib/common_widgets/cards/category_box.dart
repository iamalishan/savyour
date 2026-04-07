import 'package:ecommerce_web/constants/app_imports.dart';

class CategoryBox extends StatefulWidget {
  const CategoryBox({
    super.key,
    this.title = "",
    this.imageUrl,
    this.isListView = false,
    required this.categoryId,
  });

  final String title;
  final String? imageUrl;
  final bool isListView;
  final String categoryId;

  @override
  State<CategoryBox> createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {
  final DetailController detailController = Get.put(DetailController());
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final double baseWidth = detailController.isWeb ? 170 : 100;
    final double hoveredWidth = baseWidth + 30;

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: () {
          // print(widget.imageUrl);
          Get.to(
            CategoryBrandsScreen(
              categoryId: widget.categoryId,
              title: widget.title,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHover ? hoveredWidth : baseWidth,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 7)],
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const [0.3, 0.6],
              colors: [EcommerceTheme.primaryColor, Colors.grey.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                    ? Image.memory(
                        base64Decode(widget.imageUrl!),
                        fit: BoxFit.fitHeight,
                        width: widget.isListView
                            ? detailController.isWeb
                                  ? 120
                                  : 60
                            : null,
                      )
                    : Image.asset(
                        "assets/images/placeholderImage.png",
                        fit: BoxFit.fitHeight,
                        width: widget.isListView
                            ? detailController.isWeb
                                  ? 120
                                  : 80
                            : null,
                      ),
                // child: CachedNetworkImage(
                //   imageUrl: widget.imageUrl!,
                //   placeholder: (context, url) => Image.asset(
                //     "assets/images/placeholderImage.png",
                //     fit: BoxFit.fitHeight,
                //     width: widget.isListView
                //         ? detailController.isWeb
                //         ? 120
                //         : 80
                //         : null,
                //   ),
                //   errorWidget: (context, url, error) => Image.asset(
                //     "assets/images/placeholderImage.png",
                //     width: widget.isListView
                //         ? detailController.isWeb
                //         ? 120
                //         : 80
                //         : null,
                //     fit: BoxFit.fitHeight,
                //   ),
                //   fit: BoxFit.contain,
                //   width: widget.isListView
                //       ? detailController.isWeb
                //       ? 120
                //       : 60
                //       : null,
                // ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: isHover ? hoveredWidth - 10 : baseWidth - 10,
                  child: ReuseText(
                    title: widget.title,
                    fontWeight: FontWeight.bold,
                    linesSpace: 1.1,
                    fontSize: detailController.isWeb ? 15 : 10,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
