import 'package:ecommerce_web/constants/app_imports.dart';

class CustomIndicator extends StatelessWidget {
  final bool isActive;

  const CustomIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isActive ? 12.0 : 10.0,
      width: isActive ? 12.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
    );
  }
}
