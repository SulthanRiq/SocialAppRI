import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Warna biar konsisten dengan AccountPage
  static const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
  static const Color cardColor = Color(0xFFE8EEF2);   // abu-abu card terang
  static const Color buttonGreen = Color(0xFF7BA87B); // hijau tombol

  final _formKey = GlobalKey<FormState>();

  // Controller input (default mengikuti yang di AccountPage)
  final _usernameC = TextEditingController(text: '@budisantoso');
  final _emailC = TextEditingController(text: 'budai@gmail.com');
  final _phoneC = TextEditingController(text: '+62 812-xxx-xxx');

  bool _isSaving = false;

  @override
  void dispose() {
    _usernameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    // Simulasi save (tanpa database, sesuai request "jadi 1 saja")
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A5A2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header kecil
                Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text(
                      'Edit Informasi Akun',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Username
                const Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _usernameC,
                  decoration: _inputDecoration('Masukkan username'),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Username wajib diisi';
                    if (!value.startsWith('@')) {
                      return 'Username harus diawali @';
                    }
                    if (value.length < 4) return 'Username terlalu pendek';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Email
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Masukkan email'),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Email wajib diisi';
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Phone
                const Text(
                  'Phone',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneC,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Masukkan nomor HP'),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Nomor HP wajib diisi';
                    if (value.length < 8) return 'Nomor HP terlalu pendek';
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Tombol Save
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonGreen,
                      elevation: 2,
                    ),
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),

                const SizedBox(height: 10),

                // Tombol batal (opsional)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
