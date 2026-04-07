import '../../constants/app_imports.dart';

class HoverScaleWrapper extends StatefulWidget {
  final Widget child;
  final double scaleValue;

  const HoverScaleWrapper({required this.child,this.scaleValue = 1.2});

  @override
  State<HoverScaleWrapper> createState() => HoverScaleWrapperState();
}

class HoverScaleWrapperState extends State<HoverScaleWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scaleValue : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}
