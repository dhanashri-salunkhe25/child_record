import 'package:flutter/material.dart';

class IconGenerator {
  static Widget generateAppIcon({double size = 1024}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[600]!,
            Colors.green[700]!,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: size * 0.02,
                    offset: Offset(0, size * 0.01),
                  ),
                ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: size * 0.02,
                    offset: Offset(0, size * 0.01),
                  ),
                ],
              ),
            ),
          ),
          // Child silhouette
          Positioned(
            bottom: size * 0.15,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: size * 0.02,
                    offset: Offset(0, size * 0.01),
                  ),
                ],
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
    );
  }
} 