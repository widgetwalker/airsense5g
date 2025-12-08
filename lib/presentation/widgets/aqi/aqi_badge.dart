import 'package:flutter/material.dart';

class AqiBadge extends StatelessWidget {
  final int aqi;
  final double size;
  final bool showValue;

  const AqiBadge({
    required this.aqi, super.key,
    this.size = 40,
    this.showValue = true,
  });

  Color _getAqiColor() {
    if (aqi <= 50) return const Color(0xFF43A047);
    if (aqi <= 100) return const Color(0xFFFFEB3B);
    if (aqi <= 150) return const Color(0xFFFB8C00);
    if (aqi <= 200) return const Color(0xFFE53935);
    if (aqi <= 300) return const Color(0xFF8E24AA);
    return const Color(0xFF6D1B1B);
  }

  String _getAqiLabel() {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getAqiColor();
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: showValue
            ? Text(
                aqi.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.4,
                ),
              )
            : Icon(
                Icons.air,
                color: Colors.white,
                size: size * 0.5,
              ),
      ),
    );
  }
}
