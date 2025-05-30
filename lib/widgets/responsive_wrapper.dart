import 'package:flutter/material.dart';

import 'package:ecom_modwir/responsive.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  final EdgeInsets? padding;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.all(
            Responsive.isMobile(context) ? 16 : 24,
          ),
      child: child,
    );
  }
}
