import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notifikasi3_privacy_controller.dart';

class PermissionMessagesPhonePage
    extends GetView<Notifikasi3PrivacyController> {
  const PermissionMessagesPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFD1DEE4);
    const Color topBarColor = Color(0xFF6F9FB5);
    const Color cardColor = Color(0xFFE6E6E6);
    const Color allowColor = Color(0xFF1E7A3B);
    const Color denyColor = Color(0xFF8B3A3A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP BAR (FIXED) =================
            Container(
              height: 48,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.black),
                  const Spacer(),
                  GestureDetector(
                    onTap: controller.onDeny,
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= TITLE (FIXED) =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PERMISSION REQUEST',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ================= FULL-WIDTH SCROLL AREA =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: SizedBox(
                  width: double.infinity, // penting: area biru ikut scroll
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ================= CARD PUTIH =================
                      Container(
                        width: 320,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.black,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SocialApp ingin menggunakan :'),
                              const SizedBox(height: 4),
                              const Text(
                                'Messages (Metadata) & Phone Access',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 10),
                              const Text('Apa itu :'),
                              const _Bullet(
                                'Metadata percakapan — waktu pesan dikirim/dibaca, '
                                'jumlah pesan, status pengiriman (tanpa isi pesan)',
                              ),
                              const _Bullet(
                                'Nomor telepon dan status koneksi panggilan',
                              ),

                              const SizedBox(height: 10),
                              const Text('Digunakan untuk :'),
                              const _Check(
                                'Analisis performa sistem perpesanan',
                              ),
                              const _Check(
                                'Menampilkan Top Contacts dan Active Friends',
                              ),
                              const _Check(
                                'Memungkinkan panggilan langsung dari aplikasi',
                              ),

                              const SizedBox(height: 10),
                              const Text('Duration : Ongoing'),
                              const Text('Can revoke : Anytime'),
                              const SizedBox(height: 4),
                              const Text('Data retention :'),
                              const _Bullet(
                                'Metadata – 30 Days | Phone – 14 Days',
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: const [
                                  Icon(
                                    Icons.warning_rounded,
                                    size: 15,
                                    color: denyColor,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Jika DENY',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const _Check('Privacy komunikasi maksimal'),
                              const _Cross(
                                'Tidak dapat menampilkan Active Friends atau Top Contacts',
                              ),
                              const _Cross(
                                'Fitur panggilan langsung dinonaktifkan',
                              ),
                              const _Check(
                                'Pesan tetap dapat dikirim dan diterima',
                              ),

                              const SizedBox(height: 14),

                              SizedBox(
                                width: double.infinity,
                                height: 34,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: allowColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: controller.onAllow,
                                  child: const Text(
                                    'ALLOW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 34,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: denyColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: controller.onDeny,
                                  child: const Text(
                                    'DENY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= REMIND ME LATER =================
                      SizedBox(
                        width: 320,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: topBarColor,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          onPressed: controller.onRemindMeLater,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.schedule,
                                  color: Colors.black, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Remind me later',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SMALL WIDGETS =================
class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• '),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  final String text;
  const _Check(this.text);

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

class _Cross extends StatelessWidget {
  final String text;
  const _Cross(this.text);

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
