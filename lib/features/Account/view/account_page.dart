import 'package:flutter/material.dart';
import 'protected_mode_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092); // biru abu-abu
    const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
    const Color cardColor = Color(0xFFE8EEF2);   // abu-abu card terang
    const Color buttonGreen = Color(0xFF7BA87B); // hijau tombol

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A5A2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.manage_accounts),
                SizedBox(width: 8),
                Text(
                  'Account Setting',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'INFORMASI AKUN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Divider(thickness: 1),

            const SizedBox(height: 8),
            // Informasi Akun card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Username', '@budisantoso'),
                  _infoRow('Email', 'budai@gmail.com'),
                  _infoRow('Phone', '+62 812-xxx-xxx'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonGreen,
                        elevation: 2,
                      ),
                      onPressed: () {
                        // TODO: buka halaman edit info
                      },
                      child: const Text('Edit Info'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'UBAH PASSWORD',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),

            // Ubah password card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last Changed : 30 Day ago'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      // TODO: buka halaman change password
                    },
                    child: const Text(
                      '[Change Password]',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'PROTECTED MODE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),

            // Protected mode card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status : OFF'),
                  const SizedBox(height: 4),
                  const Text('Lindungi diri dari komentar negatif'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 120,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonGreen,
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProtectedModePage(),
                          ),
                        );
                      },
                      child: const Text('Aktifkan'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}