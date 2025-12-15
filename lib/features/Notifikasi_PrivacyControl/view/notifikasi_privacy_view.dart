import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notifikasi_privacy_controller.dart';

class PrivacyControlNotification extends GetView<PrivacyControlController> {
  const PrivacyControlNotification({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color allowColor = Color(0xFF2E7D32);
    const Color denyColor = Color(0xFF8B3A3A);
    const Color textColor = Color(0xFF222222);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Container(
              color: topBarColor,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.black),
                  const Spacer(),
                  GestureDetector(
                    onTap: controller.onDeny,
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PRIVACY CONTROL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // CARD AREA
            Expanded(
              child: Center(
                child: Container(
                  width: 310,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: textColor,
                      height: 1.4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SocialApp memerlukan izin untuk:'),
                        const SizedBox(height: 4),
                        const Text(
                          'Interaction Patterns',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        const Text('Data yang dikumpulkan:'),
                        const SizedBox(height: 2),
                        const _BulletText('Daftar teman yang sering berinteraksi'),
                        const _BulletText('Konten yang kamu simpan/bagikan'),
                        const _BulletText('Pola waktu reaksi'),
                        const SizedBox(height: 14),

                        const Text('Manfaat untuk kamu:'),
                        const SizedBox(height: 2),
                        const _CheckText('"Close Friends" lebih akurat'),
                        const _CheckText('Urutan konten lebih relevan'),
                        const _CheckText('Sugesti koneksi lebih tepat'),
                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            SizedBox(width: 80, child: Text('Durasi')),
                            Text(': Berkelanjutan'),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 80, child: Text('Bisa dicabut')),
                            Text(': Kapan saja'),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 80, child: Text('Retensi data')),
                            Text(': 90 Hari'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Icon(Icons.warning_rounded, size: 16, color: denyColor),
                            const SizedBox(width: 6),
                            const Text(
                              'Jika DENY',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const _CheckText('Privasi maksimal'),
                        const _CrossText('Saran konten jadi kurang tepat'),
                        const _CheckText('Fitur inti tetap berfungsi'),
                        const SizedBox(height: 16),

                        // Allow Button
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: allowColor,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: controller.onAllow,
                            child: const Text(
                              'ALLOW',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Deny Button
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: denyColor,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: controller.onDeny,
                            child: const Text(
                              'DENY',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Remind me later Button -> sesuai desain gambar
            SizedBox(
              width: 310,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: topBarColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: controller.onRemindMeLater,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Remind me later',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// 🔹 Widget kecil
class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('• '),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _CheckText extends StatelessWidget {
  final String text;
  const _CheckText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, size: 14),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _CrossText extends StatelessWidget {
  final String text;
  const _CrossText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.close, size: 14),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}