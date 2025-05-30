import 'package:flutter/material.dart';

import 'package:ecom_modwir/constants.dart';

class InfoTile extends StatelessWidget {
  final String title;

  final String value;

  final IconData? icon;

  final Color? iconColor;

  final VoidCallback? onTap;

  final bool isVertical;

  const InfoTile({
    Key? key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.onTap,
    this.isVertical = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = isVertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? primaryColor, size: 20),
                const SizedBox(height: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? primaryColor, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: content,
    );
  }
}
