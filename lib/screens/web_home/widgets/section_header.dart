import 'package:ecommerce_web/constants/app_imports.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 8,
                margin: const EdgeInsets.all(5),
                color: EcommerceTheme.mainColor.withOpacity(0.5),
              ),
              ReuseText(
                title: "$title :",
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ],
          ),
          SizedBox(
            height: 25,
            width: 70,
            child: ElevatedButton(
              onPressed: onViewAll ?? () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: EcommerceTheme.mainColor,
                  padding: const EdgeInsets.all(5)),
              child: const ReuseText(
                title: "Explore",
                fontSize: 9,
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
