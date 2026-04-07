import 'package:ecommerce_web/constants/app_imports.dart';

class BrandBox extends StatefulWidget {
  final Brand brand;
  final double size;

  const BrandBox({
    super.key,
    required this.brand,
    this.size = 70,
  });

  @override
  State<BrandBox> createState() => _BrandBoxState();
}

class _BrandBoxState extends State<BrandBox> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.grey.shade300,
                    width: widget.size,
                    height: widget.size,
                    child: widget.brand.imageBase64 != null?
                    Image.memory(base64Decode(widget.brand.imageBase64!),fit: BoxFit.cover,)
                    :
                    widget.brand.imageUrl == null
                        ? Image.asset(
                      "assets/images/placeholderImage.png",
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: widget.brand.imageUrl ?? '',
                      placeholder: (context, url) => Image.asset(
                        "assets/images/placeholderImage.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/placeholderImage.png",
                              fit: BoxFit.cover),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (_isHovering)
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.brand.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 60,
              child: Center(
                child: ReuseText(
                  title: widget.brand.name,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
