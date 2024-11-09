import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.label,
    required this.value,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.color,
    this.onTap,
    this.labelFontSize,
    this.valueFontSize,
    this.onLongPress,
  });

  final String label;
  final String value;
  final double? labelFontSize;
  final double? valueFontSize;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: labelFontSize),
            ),
            Text(
              value,
              style: TextStyle(fontSize: valueFontSize),
            ),
          ],
        ),
      ),
    );
  }
}
