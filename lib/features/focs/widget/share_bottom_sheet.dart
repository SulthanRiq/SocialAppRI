// ============================================
// FILE: lib/features/focs/widget/share_bottom_sheet.dart
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

  /// Method untuk menampilkan bottom sheet
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
      decoration: const BoxDecoration(
        color: Color(0xFFE8F4F8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Bagikan ke',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Share options grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  icon: Icons.share,
                  label: 'Share',
                  color: const Color(0xFF6B95A8),
                  onTap: () => _shareGeneral(context),
                ),
                _buildShareOption(
                  context,
                  icon: Icons.whatshot,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _shareGeneral(context), // Same as general for now
                ),
                _buildShareOption(
                  context,
                  icon: Icons.link,
                  label: 'Copy Link',
                  color: Colors.grey[700]!,
                  onTap: () => _copyToClipboard(context),
                ),
                _buildShareOption(
                  context,
                  icon: Icons.more_horiz,
                  label: 'More',
                  color: Colors.grey[600]!,
                  onTap: () => _shareGeneral(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Share menggunakan native share dialog
  void _shareGeneral(BuildContext context) async {
    onShare(); // Increment counter

    try {
      final shareText = '$content\n\nShared from Focs-C App';

      await Share.share(
        shareText,
        subject: 'Check out this post!',
      );

      Navigator.pop(context);

      Get.snackbar(
        'Berhasil',
        'Post berhasil dibagikan',
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
        'Gagal membagikan post',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Copy link ke clipboard
  void _copyToClipboard(BuildContext context) {
    onShare(); // Increment counter

    final link = 'https://focs-c.app/post/$postId';
    final copyText = '$content\n\n$link';

    Clipboard.setData(ClipboardData(text: copyText));

    Navigator.pop(context);

    Get.snackbar(
      'Berhasil',
      'Link berhasil disalin ke clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6B95A8),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}