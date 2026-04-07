import 'package:ecommerce_web/constants/app_imports.dart';

class ReuseText extends StatelessWidget {
  const ReuseText({
    super.key,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 15,
    this.fontColor = Colors.black,
    required this.title,
    this.decoration = TextDecoration.none,
    this.maxLines,
    this.linesSpace,
    this.fontFamily
  });

  final FontWeight fontWeight;
  final double fontSize;
  final Color fontColor;
  final String title;
  final TextDecoration decoration;
  final int? maxLines;
  final double? linesSpace;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          color: fontColor,
          height: linesSpace,
          decoration: decoration),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }
}
