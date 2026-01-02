import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_profile_controller.dart';
import '../../register/widgets/base64_image_widget.dart';

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
          'Edit Profil',
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
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                    color: topBarColor,
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(child: _avatarWidget(c)),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: topBarColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: c.isSaving.value ? null : c.pickAvatar,
                          child: const Text(
                            'Ubah Foto Profil',
                            style: TextStyle(
                              color: Color(0xFF2F6D8C),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Username Field
                  Text(
                    'Nama Pengguna',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: c.usernameC,
                    enabled: !c.isSaving.value,
                    decoration: inputDeco(hint: 'username'),
                    validator: (v) {
                      final val = (v ?? '').trim();
                      if (val.isEmpty) return 'Username wajib diisi';
                      if (val.contains(' ')) return 'Tidak boleh mengandung spasi';

                      final clean = val.startsWith('@') ? val.substring(1) : val;
                      if (clean.length < 3) {
                        return 'Username minimal 3 karakter';
                      }
                      if (clean.length > 20) {
                        return 'Username maksimal 20 karakter';
                      }

                      // Validasi hanya huruf, angka, underscore
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(clean)) {
                        return 'Hanya huruf, angka, dan underscore';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Info text
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Username hanya bisa berisi huruf, angka, dan underscore (_)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F94A6),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: c.isSaving.value ? null : c.save,
                        child: Obx(() {
                          return c.isSaving.value
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
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
    // Prioritas: picked image > current photoUrl > default icon
    final File? file = c.pickedImage.value;
    if (file != null) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }

    final url = c.photoUrl.value;
    if (url.isNotEmpty) {
      return Base64CircleAvatar(
        base64String: url,
        radius: 50,
        backgroundColor: Colors.grey.shade300,
      );
    }

    return Icon(
      Icons.person,
      size: 50,
      color: Colors.grey.shade600,
    );
  }
}