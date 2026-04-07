import 'package:ecommerce_web/constants/app_imports.dart';

class HeaderShimmer extends StatelessWidget {
  const HeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Row(
            children: [
              Expanded(child: productShimmer()),
            ],
          )),
    );
  }

  Column productShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
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
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 25,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        )
      ],
    );
  }
}
