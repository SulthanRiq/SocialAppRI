import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String? base64String;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const Base64ImageWidget({
    super.key,
    required this.base64String,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada base64 string, tampilkan placeholder
    if (base64String == null || base64String!.isEmpty) {
      return placeholder ??
          Icon(
            Icons.person,
            size: width ?? height ?? 80,
            color: Colors.grey.shade600,
          );
    }

    try {
      // Decode Base64 string to bytes
      final Uint8List bytes = base64Decode(base64String!);

      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading Base64 image: $error');
          return errorWidget ??
              Icon(
                Icons.broken_image,
                size: width ?? height ?? 80,
                color: Colors.grey.shade400,
              );
        },
      );
    } catch (e) {
      print('Error decoding Base64: $e');
      return errorWidget ??
          Icon(
            Icons.error,
            size: width ?? height ?? 80,
            color: Colors.red.shade400,
          );
    }
  }
}

// Extension untuk CircleAvatar dengan Base64
class Base64CircleAvatar extends StatelessWidget {
  final String? base64String;
  final double radius;
  final Color? backgroundColor;

  const Base64CircleAvatar({
    super.key,
    required this.base64String,
    this.radius = 20,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (base64String == null || base64String!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade300,
        child: Icon(
          Icons.person,
          size: radius * 1.2,
          color: Colors.grey.shade600,
        ),
      );
    }

    try {
      final Uint8List bytes = base64Decode(base64String!);

      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade300,
        backgroundImage: MemoryImage(bytes),
      );
    } catch (e) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade300,
        child: Icon(
          Icons.error,
          size: radius * 1.2,
          color: Colors.red.shade400,
        ),
      );
    }
  }
}