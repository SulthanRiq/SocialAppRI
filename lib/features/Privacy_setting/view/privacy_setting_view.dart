import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/privacy_setting_controller.dart';

class PrivacyView extends GetView<PrivacyController> {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFD1DEE4);
    const Color appBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color accentColor = Color(0xFF4F8D62);

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Setting',
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Title with Lock Icon ----
                    Row(
                      children: const [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Privacy Settings',
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

                    // ====== Content You See ======
                    const _SectionTitle(title: 'Content You See'),
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
                            color: accentColor,
                            onTap: controller.onManageTopics,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== Gentle Nudge ======
                    const _SectionTitle(title: 'Gentle Nudge Intervention'),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                'Status : ${controller.isNudgeActive.value ? "Active" : "Inactive"}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(height: 8),
                          const Text(
                            'Dashboard aktivitas harian dengan\n'
                            'detail tracking & wellness insights',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Lihat Dashboard',
                            color: accentColor,
                            onTap: controller.onViewDashboard,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== Reminder ======
                    const _SectionTitle(title: 'Set Daily Reminder'),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifikasi pengingat jadwal\naktifitas & break time',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Obx(() => Text(
                                'Current reminders: ${controller.currentReminders.value} active',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Atur Reminder',
                            color: accentColor,
                            onTap: controller.onSetReminder,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ====== Privacy Control ======
                    const _SectionTitle(title: 'Privacy Control'),
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kontrol semua data & permission kamu',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Obx(() => Text(
                                'Last updated : ${controller.lastUpdatedDaysAgo.value} days ago',
                                style: const TextStyle(fontSize: 12),
                              )),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                                'Privacy score : ${controller.privacyScore.value}/100',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(height: 16),
                          _PrimaryButton(
                            text: 'Kelola Privacy',
                            color: accentColor,
                            onTap: controller.onManagePrivacy,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== Learn More ======
                    const Text(
                      '📚 Learn more :',
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

                    const SizedBox(height: 32),
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

// ======================== WIDGETS ========================

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white, // <- teks putih
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward,
              size: 14,
              color: Colors.white, // <- icon putih
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnMoreItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LearnMoreItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 12, height: 1.5)),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
