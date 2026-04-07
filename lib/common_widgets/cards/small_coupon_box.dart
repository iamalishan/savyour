import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:dotted_line/dotted_line.dart';

class SmallCouponBox extends StatelessWidget {
  const SmallCouponBox({super.key, required this.coupon, this.onTap});

  final Coupon coupon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Clipboard.setData(ClipboardData(text: coupon.coupon));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied to clipboard!')),
        );
      },
      child: Container(
        width: 220,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade100],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Row(
          children: [
            // Left: Percentage
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade100],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                child: ReuseText(
                  title: coupon.percentage,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.grey.shade900,
                ),
              ),
            ),

            // Vertical Dotted Line
            Container(
              width: 1,
              color: Colors.white,
              child: DottedLine(
                direction: Axis.vertical,
                dashColor: Colors.grey.shade400,
                dashLength: 6,
                dashGapLength: 4,
                lineThickness: 1.5,
              ),
            ),

            // Right: Coupon Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand logo and name
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 28,
                            width: 28,
                            color: Colors.grey.shade400,
                            child: CachedImage(
                              imageUrl: coupon.brandLogo,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ReuseText(
                            title: coupon.brandName,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Coupon code
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
            ),
          ],
        ),
      ),
    );
  }
}
