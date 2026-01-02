import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController usernameC = TextEditingController();

  // State
  RxBool isLoading = true.obs;
  RxBool isSaving = false.obs;
  Rx<File?> pickedImage = Rx<File?>(null);
  RxString photoUrl = ''.obs;
  RxString currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    usernameC.dispose();
    super.onClose();
  }

  // ================= LOAD USER DATA
  void loadUserData() async {
    try {
      isLoading.value = true;

      final user = _authController.currentUser.value;
      if (user == null) {
        Get.snackbar('Error', 'User not found');
        Get.back();
        return;
      }

      // Load data ke form
      usernameC.text = user.username;
      photoUrl.value = user.photoUrl ?? '';
      currentUsername.value = user.username;

    } catch (e) {
      print('❌ Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data profil',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PICK AVATAR
  Future<void> pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        pickedImage.value = File(image.path);
        print('✅ Image picked: ${image.path}');
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================= CHECK USERNAME AVAILABILITY
  Future<bool> isUsernameAvailable(String username) async {
    try {
      // Skip check jika username tidak berubah
      if (username.toLowerCase() == currentUsername.value.toLowerCase()) {
        return true;
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('❌ Error checking username: $e');
      return false;
    }
  }

  // ================= SAVE PROFILE
  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isSaving.value = true;

      final user = _authController.currentUser.value;
      if (user == null) throw 'User not found';

      // Validasi username
      String newUsername = usernameC.text.trim();
      if (newUsername.startsWith('@')) {
        newUsername = newUsername.substring(1);
      }

      // Check username availability
      if (newUsername.toLowerCase() != currentUsername.value.toLowerCase()) {
        final isAvailable = await isUsernameAvailable(newUsername);
        if (!isAvailable) {
          Get.snackbar(
            'Error',
            'Username "$newUsername" sudah digunakan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Prepare update data
      Map<String, dynamic> updateData = {
        'username': newUsername,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Convert image to base64 if picked
      if (pickedImage.value != null) {
        final bytes = await pickedImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        updateData['photoUrl'] = base64Image;
        print('✅ Image converted to base64');
      }

      // Update Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updateData);

      // Update local user data
      final updatedUser = user.copyWith(
        username: newUsername,
        photoUrl: updateData['photoUrl'] ?? user.photoUrl,
        updatedAt: DateTime.now(),
      );

      _authController.currentUser.value = updatedUser;

      // ✅ UPDATE SEMUA POSTS USER (username & photo)
      await _updateUserPosts(user.uid, newUsername, updateData['photoUrl']);

      // ✅ UPDATE SEMUA COMMENTS USER (username & photo)
      await _updateUserComments(user.uid, newUsername, updateData['photoUrl']);

      print('✅ Profile updated successfully');

      Get.back();
      Get.snackbar(
        'Sukses',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      print('❌ Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ================= UPDATE USER POSTS
  Future<void> _updateUserPosts(String userId, String newUsername, String? newPhotoUrl) async {
    try {
      // Get all posts by user
      final postsSnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      // Update each post
      final batch = _firestore.batch();
      for (var doc in postsSnapshot.docs) {
        batch.update(doc.reference, {
          'username': newUsername,
          if (newPhotoUrl != null) 'userPhoto': newPhotoUrl,
        });
      }

      await batch.commit();
      print('✅ Updated ${postsSnapshot.docs.length} posts');
    } catch (e) {
      print('❌ Error updating posts: $e');
    }
  }

  // ================= UPDATE USER COMMENTS
  Future<void> _updateUserComments(String userId, String newUsername, String? newPhotoUrl) async {
    try {
      // Get all comments by user
      final commentsSnapshot = await _firestore
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .get();

      // Update each comment
      final batch = _firestore.batch();
      for (var doc in commentsSnapshot.docs) {
        batch.update(doc.reference, {
          'username': newUsername,
          if (newPhotoUrl != null) 'userPhoto': newPhotoUrl,
        });
      }

      await batch.commit();
      print('✅ Updated ${commentsSnapshot.docs.length} comments');
    } catch (e) {
      print('❌ Error updating comments: $e');
    }
  }
}