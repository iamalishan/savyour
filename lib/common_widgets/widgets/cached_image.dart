import 'package:ecommerce_web/constants/app_imports.dart';

class CachedImage extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final IconData fallbackIcon;
  final String? fallbackImagePath;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.photo,
    this.fallbackImagePath,
  });

  @override
  CachedImageWithKeepAliveState createState() =>
      CachedImageWithKeepAliveState();
}

class CachedImageWithKeepAliveState extends State<CachedImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl ?? "",
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        placeholder: (context, url) => Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(Icons.image, size: 30),
          ),
        ),
        errorWidget: (context, url, error) => widget.fallbackImagePath != null
            ? Image.asset(
                widget.fallbackImagePath!,
                height: widget.height,
                width: widget.width,
                fit: widget.fit,
              )
            : Container(
                color: Colors.grey.withOpacity(0.1),
                child: Icon(
                  widget.fallbackIcon,
                  size: widget.height ?? 30,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
