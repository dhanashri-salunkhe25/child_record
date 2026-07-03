import 'package:flutter/material.dart';

class LauncherIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const LauncherIcon({
    super.key,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green[600],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.health_and_safety,
        color: iconColor ?? Colors.white,
        size: size * 0.6,
      ),
    );
  }
} 