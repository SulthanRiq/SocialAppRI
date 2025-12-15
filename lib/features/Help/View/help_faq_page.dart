import 'package:flutter/material.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092);
    const Color bgColor = Color(0xFFB8C5CC);
    const Color cardColor = Color(0xFFE8EEF2);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Container(
              height: 56,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Help & FAQ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const _FaqContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqContent extends StatelessWidget {
  const _FaqContent();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 11.5, height: 1.35, color: Colors.black87);
    const boldStyle = TextStyle(fontSize: 11.5, height: 1.35, fontWeight: FontWeight.w700);

    Widget h(String t) => Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(t, style: boldStyle),
    );

    Widget p(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(t, style: textStyle),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        h('1. Umum'),
        p('Q1. Apa itu SocialApp?\n'
            'SocialApp adalah platform sosial yang memungkinkan pengguna untuk berbagi momen, berinteraksi melalui postingan, mengikuti teman, dan membangun komunitas dengan minat yang sama.'),
        p('Q2. Siapa yang bisa menggunakan SocialApp?\n'
            'Setiap pengguna berusia 13 tahun ke atas dapat membuat akun dan menikmati fitur SocialApp sesuai dengan ketentuan layanan dan kebijakan privasi.'),
        p('Q3. Apakah SocialApp gratis digunakan?\n'
            'Ya, semua fitur utama SocialApp dapat digunakan secara gratis. Namun, beberapa fitur tambahan (seperti badge premium atau promosi konten) mungkin memerlukan langganan.'),

        h('2. Akun & Privasi'),
        p('Q1. Bagaimana cara membuat akun baru?\n'
            'Klik tombol “Daftar”, masukkan email aktif atau nomor telepon, buat username unik, dan atur kata sandi. Setelah itu, verifikasi akun melalui email atau kode OTP.'),
        p('Q2. Saya lupa kata sandi, bagaimana cara memulihkannya?\n'
            'Buka halaman Login → Lupa Kata Sandi, masukkan email atau nomor terdaftar, lalu ikuti instruksi reset yang dikirimkan.'),
        p('Q3. Bagaimana cara mengubah username atau foto profil?\n'
            'Masuk ke Profil → Edit Profil, ubah data yang diinginkan, lalu tekan Simpan.'),
        p('Q4. Apakah data pribadi saya aman?\n'
            'Ya. SocialApp menggunakan enkripsi dan kontrol privasi untuk melindungi data pengguna, serta tidak membagikan informasi pribadi tanpa izin.'),
        p('Q5. Bagaimana cara menghapus akun saya?\n'
            'Pergi ke Pengaturan → Akun → Hapus Akun, konfirmasi penghapusan, dan akunmu akan dihapus permanen setelah 30 hari.'),

        h('3. Postingan & Interaksi'),
        p('Q1. Bagaimana cara membuat postingan baru?\n'
            'Tekan ikon “+”, pilih foto/video atau tulis status, tambahkan caption dan tag, lalu klik Bagikan.'),
        p('Q2. Bagaimana cara menghapus atau mengedit postingan saya?\n'
            'Buka postingan → klik ikon (⋮) → pilih Edit atau Hapus Postingan.'),
        p('Q3. Bagaimana cara melaporkan komentar atau postingan yang tidak pantas?\n'
            'Ketuk (⋮) pada postingan/komentar → pilih Laporkan → pilih alasan pelaporan (spam, ujaran kebencian, pelecehan, dll).'),
        p('Q4. Apakah saya bisa membatasi siapa yang bisa mengomentari postingan saya?\n'
            'Ya. Masuk ke Pengaturan Privasi → Komentar, lalu pilih apakah semua orang, teman, atau hanya pengguna tertentu yang bisa berkomentar.'),

        h('4. Bantuan & Dukungan Pengguna'),
        p('Hubungi Kami:\n'
            '• Email : support@socialapp.com\n'
            '• Sosial Media : @socialapp_support\n'
            '• Jam Operasional: Senin–Jumat, pukul 09.00–17.00 WIB'),
      ],
    );
  }
}
