import 'dart:async';
import 'package:ecommerce_web/constants/app_imports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
          () => splashController.navigateBasedOnScreenSize(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcommerceTheme.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BrandIconWrapper(),
            const SizedBox(height: 30),
            const _AnimatedLoadingText(),
          ],
        ),
      ),
    );
  }
}

class _BrandIconWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.white, offset: Offset(-2, 0), blurRadius: 20),
          BoxShadow(color: Colors.white, offset: Offset(2, 0), blurRadius: 20),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset(
          AppAssets.webFavicon2,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AnimatedLoadingText extends StatelessWidget {
  const _AnimatedLoadingText();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 2),
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) => Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.grey.shade300,
              color: Colors.white,
              value: value,
            ),
            const SizedBox(height: 20),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(color: Color(0xFFFEB692), blurRadius: 10, offset: Offset(2, 2)),
                  Shadow(color: Color(0xFFEA5455), blurRadius: 10, offset: Offset(-2, -2)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
