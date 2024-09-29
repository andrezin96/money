import 'package:flutter/material.dart';

import '../../../core/core.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.label,
    required this.value,
    this.margin,
    this.height,
    this.width,
    this.onTap,
  });

  final String label;
  final String value;
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
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              double.parse(value).toCurrency,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
