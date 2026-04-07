import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:dotted_line/dotted_line.dart';

class CouponBox extends StatelessWidget {
  const CouponBox({super.key, required this.coupon,this.onTap});

  final Coupon coupon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            // Top Container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade100],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Brand Logo
                  ClipOval(
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.grey.shade400,
                      child: CachedImage(
                        imageUrl: coupon.brandLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Brand Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReuseText(
                          title: coupon.brandName,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            ReuseText(
                              title: coupon.coupon,
                              fontSize: 11,
                              fontColor: EcommerceTheme.mainColor,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.label, size: 12, color: EcommerceTheme.mainColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dotted Line
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DottedLine(
                  dashColor: Colors.grey.shade200,
                  dashGapLength: 7,
                  dashLength: 7,
                  lineThickness: 3,
                ),
              ),
            ),

            // Bottom Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15),
                  top: Radius.circular(10)
                  ),
                  gradient: LinearGradient(colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade100
                  ],
                  begin: Alignment.bottomLeft,
                    end: Alignment.topRight
                  )
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ReuseText(
                    title: coupon.percentage,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.grey.shade900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
