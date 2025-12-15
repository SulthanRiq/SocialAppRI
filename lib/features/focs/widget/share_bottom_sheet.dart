// ============================================
// FILE: lib/features/focs/widget/share_bottom_sheet.dart
// REVISI - 4 Opsi Sesuai Gambar
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

class ShareBottomSheet extends StatelessWidget {
  final String postId;
  final String content;
  final String? imageUrl;
  final Function() onShare;

  const ShareBottomSheet({
    Key? key,
    required this.postId,
    required this.content,
    this.imageUrl,
    required this.onShare,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String postId,
    required String content,
    String? imageUrl,
    required Function() onShare,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareBottomSheet(
        postId: postId,
        content: content,
        imageUrl: imageUrl,
        onShare: onShare,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB3D4DB), // Sesuai gambar
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 4 Share options - Single row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  icon: Icons.chat, // WhatsApp icon
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366), // Hijau WhatsApp
                  onTap: () => _shareToWhatsApp(context),
                ),
                _buildShareOption(
                  context,
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2), // Biru Facebook
                  onTap: () => _shareToFacebook(context),
                ),
                _buildShareOption(
                  context,
                  icon: Icons.close, // X icon
                  label: 'X',
                  color: const Color(0xFF5A5A5A), // Abu-abu gelap
                  onTap: () => _shareToTwitter(context),
                ),
                _buildShareOption(
                  context,
                  icon: Icons.content_copy, // Copy icon
                  label: 'Salin',
                  color: Colors.white,
                  iconColor: Colors.black, // Icon hitam untuk Copy
                  onTap: () => _copyToClipboard(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container bulat dengan icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20), // Rounded square
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          // Label tidak ditampilkan di UI sesuai gambar
        ],
      ),
    );
  }

  // ========================================
  // SHARE HANDLERS
  // ========================================

  /// Share ke WhatsApp
  void _shareToWhatsApp(BuildContext context) async {
    onShare();

    try {
      final shareText =
          '${content.length > 100 ? content.substring(0, 100) + "..." : content}\n\nShared from Focs-C\nhttps://focs-c.app/post/$postId';

      await Share.share(
        shareText,
        subject: 'Check out this post!',
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Berhasil',
        'Dibagikan ke WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Error',
        'Gagal membagikan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Share ke Facebook
  void _shareToFacebook(BuildContext context) async {
    onShare();

    try {
      final shareText =
          '${content.length > 100 ? content.substring(0, 100) + "..." : content}\n\nShared from Focs-C\nhttps://focs-c.app/post/$postId';

      await Share.share(
        shareText,
        subject: 'Check out this post!',
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Berhasil',
        'Dibagikan ke Facebook',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Error',
        'Gagal membagikan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Share ke Twitter/X
  void _shareToTwitter(BuildContext context) async {
    onShare();

    try {
      final shareText =
          '${content.length > 100 ? content.substring(0, 100) + "..." : content}\n\nShared from Focs-C\nhttps://focs-c.app/post/$postId';

      await Share.share(
        shareText,
        subject: 'Check out this post!',
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Berhasil',
        'Dibagikan ke X',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      Get.snackbar(
        'Error',
        'Gagal membagikan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Copy link ke clipboard
  void _copyToClipboard(BuildContext context) {
    onShare();

    try {
      final link = 'https://focs-c.app/post/$postId';
      final copyText =
          '${content.length > 100 ? content.substring(0, 100) + "..." : content}\n\n$link';

      Clipboard.setData(ClipboardData(text: copyText));

      Navigator.pop(context);

      Get.snackbar(
        'Berhasil',
        'Link berhasil disalin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Navigator.pop(context);

      Get.snackbar(
        'Error',
        'Gagal menyalin link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
