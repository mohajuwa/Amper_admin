import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;

  final EdgeInsets? padding;

  final EdgeInsets? margin;

  final Color? color;

  final double? elevation;

  final BorderRadius? borderRadius;

  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(defaultPadding),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Get.theme.cardColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: elevation ?? 4,
            offset: Offset(0, elevation ?? 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ?? BorderRadius.circular(defaultBorderRadius),
        child: card,
      );
    }

    return card;
  }
}
