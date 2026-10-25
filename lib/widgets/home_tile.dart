import 'package:flutter/material.dart';

/// زرار الرئيسية. لو عاوز تصميمك إنت: ابعت [imageAsset] (PNG/SVG محوّل) وهيتعرض بدل الشكل المرسوم بالكود.
class HomeTile extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? imageAsset;

  const HomeTile({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.imageAsset,
  });

  @override
  State<HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final Widget face = widget.imageAsset != null
        ? Image.asset(widget.imageAsset!, fit: BoxFit.contain)
        : Container(
            height: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(widget.color, Colors.white, 0.18)!,
                  widget.color,
                ],
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 36, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: face,
      ),
    );
  }
}
