import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.label,
    required this.value,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.labelFontSize,
    this.valueFontSize,
  });

  final String label;
  final String value;
  final double? labelFontSize;
  final double? valueFontSize;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: labelFontSize ?? 16),
            ),
            Text(
              value,
              style: TextStyle(fontSize: valueFontSize ?? 16),
            ),
          ],
        ),
      ),
    );
  }
}
