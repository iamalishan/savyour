import 'package:ecommerce_web/constants/app_imports.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key, this.isDouble = true});

  final bool isDouble;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Row(
            children: [
              Expanded(child: productShimmer()),
              if (isDouble)
                const SizedBox(
                  width: 10,
                ),
              if (isDouble) Expanded(child: productShimmer()),
            ],
          )),
    );
  }

  Column productShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 25,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 25,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        )
      ],
    );
  }
}
