import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/privacy_control_controller.dart';

class PrivacyControlView extends GetView<PrivacyControlController> {
  const PrivacyControlView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFD1DEE4);
    const Color appBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color buttonColor = Color(0xFF4F8D62);
    const iconColor = Color(0xFF29254C);

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
                    'Privacy',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Privacy Control',
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
                    // Header
                    Row(
                      children: const [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Your Data, Yor control',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Obx(() => Text(
                          'Profile : ⚖  ${controller.profileName.value}',
                          style: const TextStyle(fontSize: 12),
                        )),
                    Obx(() => Text(
                          'Privacy score : ${controller.privacyScore.value}/100',
                          style: const TextStyle(fontSize: 12),
                        )),

                    const SizedBox(height: 12),
                    const Divider(thickness: 1),

                    const SizedBox(height: 12),
                    const Text(
                      'Permission by category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // === PERSONAL INFORMATION ===
                    _CardContainer(
                      title: 'Personal Information',
                      items: [
                        _DataItem(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: controller.locationStatus,
                        ),
                        _DataItem(
                          icon: Icons.photo,
                          label: 'Photos',
                          value: controller.photosStatus,
                        ),
                        _DataItem(
                          icon: Icons.contact_page,
                          label: 'Contacts',
                          value: controller.contactsStatus,
                        ),
                      ],
                      onTap: controller.onManagePersonalInfo,
                    ),

                    const SizedBox(height: 16),

                    // === BEHAVIORAL DATA ===
                    _CardContainer(
                      title: 'Behavioral Data',
                      items: [
                        _DataItem(
                          icon: Icons.public,
                          label: 'Browsing',
                          value: controller.browsingStatus,
                        ),
                        _DataItem(
                          icon: Icons.people,
                          label: 'Interactions',
                          value: controller.interactionsStatus,
                        ),
                      ],
                      onTap: controller.onManageBehavioralData,
                    ),

                    const SizedBox(height: 16),

                    // === COMMUNICATION ===
                    _CardContainer(
                      title: 'Communication',
                      items: [
                        _DataItem(
                          icon: Icons.message,
                          label: 'Messages',
                          value: controller.messagesStatus,
                        ),
                        _DataItem(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: controller.phoneStatus,
                        ),
                      ],
                      onTap: controller.onManageCommunication,
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

// ==================== COMPONENTS ====================

class _DataItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final RxString value;

  const _DataItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(icon, size: 14, color: Color(0xFF29254C)),
              const SizedBox(width: 6),
              Text(
                '$label : ',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                value.value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final VoidCallback onTap;

  const _CardContainer({
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ...items,
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F8D62),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Manage',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
