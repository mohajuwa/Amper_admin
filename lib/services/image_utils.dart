import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageUtils {
  static Widget buildNetworkImage(
    String? imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return errorWidget ?? _buildDefaultErrorWidget(width, height);
    }

    Widget image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return placeholder ?? _buildDefaultPlaceholder(width, height);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(width, height);
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }

  static Widget _buildDefaultPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget _buildDefaultErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: (width != null && height != null)
            ? (width < height ? width : height) * 0.3
            : 30,
      ),
    );
  }

  static String? getImageExtension(String? path) {
    if (path == null || path.isEmpty) return null;

    final lastDot = path.lastIndexOf('.');

    if (lastDot == -1) return null;

    return path.substring(lastDot + 1).toLowerCase();
  }

  static bool isValidImageExtension(String? extension) {
    if (extension == null) return false;

    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];

    return validExtensions.contains(extension.toLowerCase());
  }

  static double getImageAspectRatio(String imagePath) {
    // This would require image package to get actual dimensions

    // For now, return a default aspect ratio

    return 16 / 9;
  }
}
