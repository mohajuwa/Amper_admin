import 'package:flutter/material.dart';

import 'package:ecom_modwir/constants.dart';

class StatusBadge extends StatelessWidget {
  final String text;

  final Color? color;

  final Color? backgroundColor;

  final EdgeInsets? padding;

  final double? fontSize;

  const StatusBadge({
    Key? key,
    required this.text,
    this.color,
    this.backgroundColor,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? primaryColor;

    final bgColor = backgroundColor ?? badgeColor.withOpacity(0.1);

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: badgeColor,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
