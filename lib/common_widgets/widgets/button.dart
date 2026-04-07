import 'package:ecommerce_web/constants/app_imports.dart';

class EcommerceButton extends StatelessWidget {
  EcommerceButton({
    super.key,
    required this.text,
    this.buttonColor = Colors.black,
    this.onTap,
    this.isDisabled = false,
    this.buttonWidth = 200,
    this.buttonHeight = 35,
    this.isLoading = false,
    this.fontSize = 12,
  });

  final String text;
  final Color buttonColor;
  final VoidCallback? onTap;
  final bool isDisabled;
  final double buttonWidth;
  final double buttonHeight;
  bool isLoading;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
          onPressed: isDisabled ? () {} : onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDisabled ? buttonColor.withOpacity(0.3) : buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : ReuseText(
                  title: text,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
    );
  }
}
