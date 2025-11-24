import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'privacy_controller.dart';

class PrivacyView extends GetView<PrivacyController> {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFD1DEE4);
    const Color appBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color accentColor = Color(0xFF36466B);
    const Color buttonColor = Color(0xFF4F8D62);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Container(
              height: 56,
              color: appBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    padding: EdgeInsets.zero,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Privacy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- TITLE ROW "Privacy Settings" + icon ----
                    Row(
                      children: const [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Privaci Setting',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1),

                    const SizedBox(height: 16),

                    // ====== CONTENT YOU SEE ======
                    const Text(
                      'Content You See',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Atur topik & interest kamu',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              'Current interests:\n• ${controller.interests.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Manage Topics',
                            icon: Icons.arrow_forward,
                            color: buttonColor,
                            onTap: controller.onManageTopics,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== GENTLE NUDGE INTERVENTION ======
                    const Text(
                      'Gentle Nudge Intervention',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Row(
                              children: [
                                const Text(
                                  'Status : ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  controller.isNudgeActive.value
                                      ? 'Active'
                                      : 'Inactive',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dashboard aktivitas harian dengan\n'
                            'detail tracking & wellness insights',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Lihat Dashboard',
                            icon: Icons.arrow_forward,
                            color: accentColor,
                            onTap: controller.onViewDashboard,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== SET DAILY REMINDER ======
                    const Text(
                      'Set Daily Reminder',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifikasi pengingat jadwal\n'
                            'aktifitas & break time',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              'Current reminders: ${controller.currentReminders} active',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Atur Reminder',
                            icon: Icons.arrow_forward,
                            color: buttonColor,
                            onTap: controller.onSetReminder,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== PRIVACY CONTROL ======
                    const Text(
                      'Privacy Control',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kontrol semua data & permission kamu',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => Text(
                              'Last updated : ${controller.lastUpdatedDaysAgo} days ago',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => Text(
                              'Privacy score : ${controller.privacyScore}/100',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Kelola Privacy',
                            icon: Icons.arrow_forward,
                            color: accentColor,
                            onTap: controller.onManagePrivacy,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ====== LEARN MORE ======
                    const Text(
                      'Learn more :',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _LearnMoreItem(
                      text: 'Privacy Policy (Plain Explained)',
                      onTap: controller.onOpenPrivacyPolicy,
                    ),
                    _LearnMoreItem(
                      text: 'Data Usage Explained',
                      onTap: controller.onOpenDataUsage,
                    ),
                    _LearnMoreItem(
                      text: 'Your Rights',
                      onTap: controller.onOpenYourRights,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== WIDGET BANTUAN ==================

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFE8EEF2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}

class _LearnMoreItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LearnMoreItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ',
                style: TextStyle(fontSize: 12, height: 1.4)),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
