import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100.0,
    this.color,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo container with medical cross and child icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color ?? Colors.green[600],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Medical cross
              Positioned(
                top: size * 0.25,
                child: Container(
                  width: size * 0.4,
                  height: size * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.05),
                  ),
                ),
              ),
              Positioned(
                top: size * 0.15,
                child: Container(
                  width: size * 0.2,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.05),
                  ),
                ),
              ),
              // Child silhouette
              Positioned(
                bottom: size * 0.15,
                child: Container(
                  width: size * 0.3,
                  height: size * 0.4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Heart symbol
              Positioned(
                top: size * 0.1,
                right: size * 0.1,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red[400],
                  size: size * 0.15,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              'Child Health Record',
              style: TextStyle(
                fontSize: (size * 0.12).clamp(12.0, 24.0),
                fontWeight: FontWeight.bold,
                color: color ?? Colors.green[700],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              'Offline Health Data Collection',
              style: TextStyle(
                fontSize: (size * 0.08).clamp(10.0, 16.0),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ],
    );
  }
} 