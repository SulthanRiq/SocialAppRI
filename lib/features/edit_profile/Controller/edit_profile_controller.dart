import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_profile.dart';

class EditProfileController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // UI state
  final isLoading = true.obs;
  final isSaving = false.obs;

  // form
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final bioC = TextEditingController();

  // gender
  final gender = 'Pria'.obs;

  // avatar
  final pickedImage = Rxn<File>(); // file lokal yg dipilih
  final photoUrl = ''.obs; // url dari Firestore (kalau ada)

  String get uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('User belum login (FirebaseAuth.currentUser null)');
    return u.uid;
  }

  DocumentReference<Map<String, dynamic>> get userDoc => _db.collection('users').doc(uid);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameC.dispose();
    usernameC.dispose();
    bioC.dispose();
    super.onClose();
  }

  /// ✅ Load profil HANYA dari Firestore (tidak menyentuh Storage)
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final snap = await userDoc.get();

      if (!snap.exists || snap.data() == null) {
        // Kalau doc belum ada, buat doc kosong
        final created = UserProfile.empty(uid);
        await userDoc.set({
          'name': created.name,
          'username': created.username,
          'bio': created.bio,
          'gender': created.gender,
          'photoUrl': created.photoUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        _apply(created);
      } else {
        final profile = UserProfile.fromMap(uid, snap.data()!);
        _apply(profile);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _apply(UserProfile p) {
    nameC.text = p.name;
    usernameC.text = p.username; // tanpa '@'
    bioC.text = p.bio;
    gender.value = p.gender.isEmpty ? 'Pria' : p.gender;
    photoUrl.value = p.photoUrl; // ✅ dari Firestore saja
  }

  Future<void> pickAvatar() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (x == null) return;

      pickedImage.value = File(x.path);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  /// ✅ Upload: hanya dipanggil kalau user benar-benar pilih gambar
  Future<String> uploadAvatar(File file) async {
    final ref = _storage.ref().child('users/$uid/avatar.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  String sanitizeUsername(String raw) {
    var u = raw.trim();
    if (u.startsWith('@')) u = u.substring(1);
    return u;
  }

  /// ✅ Save: TIDAK akan menyentuh Storage kalau tidak pilih gambar baru
  Future<void> save() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return;

    isSaving.value = true;
    try {
      String finalPhoto = photoUrl.value; // default pakai yg ada di Firestore

      // ✅ HANYA upload jika user pilih gambar baru
      if (pickedImage.value != null) {
        finalPhoto = await uploadAvatar(pickedImage.value!);
      }

      final name = nameC.text.trim();
      final username = sanitizeUsername(usernameC.text);
      final bio = bioC.text.trim();
      final g = gender.value;

      // Simpan ke Firestore
      await userDoc.set({
        'name': name,
        'username': username,
        'bio': bio,
        'gender': g,
        'photoUrl': finalPhoto,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Simpan state lokal
      photoUrl.value = finalPhoto;

      // Optional sinkron ke FirebaseAuth
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        if (finalPhoto.isNotEmpty) await user.updatePhotoURL(finalPhoto);
      }

      Get.snackbar('Berhasil', 'Profil berhasil disimpan ✅');
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan: $e');
    } finally {
      isSaving.value = false;
    }
  }
}
