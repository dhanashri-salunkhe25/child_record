import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppBarIcon({
    super.key,
    this.size = 24.0,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.health_and_safety,
        color: iconColor ?? Colors.green[600],
        size: size * 0.6,
      ),
    );
  }
} 