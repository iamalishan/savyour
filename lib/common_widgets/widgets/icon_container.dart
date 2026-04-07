import '../../constants/app_imports.dart';

class IconContainer extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onLongPress;
  final double size;

  const IconContainer({super.key, required this.icon, this.onTap,this.iconColor = Colors.white, this.backgroundColor = Colors.transparent, this.onLongPress,
  this.size = 24
  });

  @override
  State<IconContainer> createState() => _IconContainerState();
}

class _IconContainerState extends State<IconContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onLongPressUp: widget.onLongPress,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? Colors.white.withOpacity(0.2) : widget.backgroundColor,
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
