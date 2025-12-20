import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditProfileController());

    const topBarColor = Color(0xFF5E8092);
    const bgColor = Color(0xFFD9D9D9);

    InputDecoration inputDeco({String? hint}) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: Colors.black54),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit profil',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
            child: Form(
              key: c.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Avatar + edit gambar
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: c.isSaving.value ? null : c.pickAvatar,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(child: _avatarWidget(c)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: c.isSaving.value ? null : c.pickAvatar,
                          child: const Text(
                            'Edit gambar',
                            style: TextStyle(
                              color: Color(0xFF2F6D8C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text('Nama', style: TextStyle(color: Colors.black.withOpacity(0.65))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: c.nameC,
                    enabled: !c.isSaving.value,
                    decoration: inputDeco(),
                    validator: (v) {
                      final val = (v ?? '').trim();
                      if (val.isEmpty) return 'Nama wajib diisi';
                      if (val.length < 3) return 'Minimal 3 karakter';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Text('Nama Pengguna', style: TextStyle(color: Colors.black.withOpacity(0.65))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: c.usernameC,
                    enabled: !c.isSaving.value,
                    decoration: inputDeco(hint: '@username'),
                    validator: (v) {
                      final val = (v ?? '').trim();
                      if (val.isEmpty) return 'Username wajib diisi';
                      if (val.contains(' ')) return 'Tidak boleh spasi';
                      final clean = val.startsWith('@') ? val.substring(1) : val;
                      if (clean.length < 3) return 'Minimal 3 karakter';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Text('Bio', style: TextStyle(color: Colors.black.withOpacity(0.65))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: c.bioC,
                    enabled: !c.isSaving.value,
                    decoration: inputDeco(hint: 'Tulis sesuatu tentang diri Anda...'),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Jenis Kelamin',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Obx(() => Radio<String>(
                        value: 'Pria',
                        groupValue: c.gender.value,
                        onChanged: c.isSaving.value
                            ? null
                            : (v) => c.gender.value = v ?? 'Pria',
                      )),
                      const Text('Pria'),
                      const SizedBox(width: 18),
                      Obx(() => Radio<String>(
                        value: 'Wanita',
                        groupValue: c.gender.value,
                        onChanged: c.isSaving.value
                            ? null
                            : (v) => c.gender.value = v ?? 'Wanita',
                      )),
                      const Text('Wanita'),
                    ],
                  ),

                  const SizedBox(height: 26),

                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F94A6),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        onPressed: c.isSaving.value ? null : c.save,
                        child: Obx(() {
                          return c.isSaving.value
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _avatarWidget(EditProfileController c) {
    final File? file = c.pickedImage.value;
    if (file != null) return Image.file(file, fit: BoxFit.cover);

    final url = c.photoUrl.value;
    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 40),
      );
    }
    return const Icon(Icons.person, size: 40);
  }
}
