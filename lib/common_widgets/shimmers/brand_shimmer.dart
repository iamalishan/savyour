import 'package:ecommerce_web/constants/app_imports.dart';

class BrandShimmer extends StatelessWidget {
  const BrandShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var circleSize = 60;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 80,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, crossAxisSpacing: 10, mainAxisSpacing: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(circleSize / 2)),
                );
              }),
        ),
      ),
    );
  }
}
