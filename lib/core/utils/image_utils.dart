import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUtils {
  /// Resolves a thumbnail URL/path into an [ImageProvider].
  /// Handles:
  /// - Network URLs (http/https)
  /// - Asset paths (assets/)
  /// - Local file paths
  /// Returns null if the path is null, empty, or a non-existent file.
  static ImageProvider? resolveImageProvider(String? path) {
    if (path == null || path.isEmpty) return null;

    if (path.startsWith('http')) {
      return CachedNetworkImageProvider(path);
    }

    if (path.startsWith('assets/')) {
      // Handle known missing assets and ensure valid paths
      if (path == 'assets/images/rest_day.jpg' || path.isEmpty) return null;
      return AssetImage(path);
    }

    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }

    return null;
  }
}
