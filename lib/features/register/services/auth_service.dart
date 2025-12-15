import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk listen perubahan auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Convert Image File to Base64 String
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      print('🔵 Converting image to Base64...');

      // Read file as bytes
      final bytes = await imageFile.readAsBytes();

      // Check file size (max 500KB untuk foto profil)
      final fileSizeInKB = bytes.length / 1024;
      print('Image size: ${fileSizeInKB.toStringAsFixed(2)} KB');

      if (fileSizeInKB > 500) {
        print('🔴 Image too large: ${fileSizeInKB.toStringAsFixed(2)} KB');
        return null;
      }

      // Convert to base64
      final base64String = base64Encode(bytes);

      print('✅ Image converted to Base64 (length: ${base64String.length})');
      return base64String;
    } catch (e) {
      print('🔴 Error converting image to Base64: $e');
      return null;
    }
  }

  // Register dengan Email & Password
  Future<Map<String, dynamic>> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
    File? photoFile,
  }) async {
    try {
      print('🔵 Starting registration for: $email');

      // 1. Cek apakah username sudah digunakan
      print('🔵 Checking username availability...');
      final usernameExists = await _checkUsernameExists(username);
      if (usernameExists) {
        print('🔴 Username already exists');
        return {
          'success': false,
          'message': 'Username sudah digunakan',
        };
      }
      print('✅ Username available');

      // 2. Create user dengan Firebase Auth
      print('🔵 Creating Firebase Auth user...');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('✅ Firebase Auth user created: ${userCredential.user?.uid}');

      // 3. Convert photo to Base64 jika ada
      String? photoBase64;
      if (photoFile != null) {
        print('🔵 Converting profile photo to Base64...');
        photoBase64 = await convertImageToBase64(photoFile);

        if (photoBase64 == null) {
          print('⚠️ Photo too large or conversion failed, continuing without photo');
        } else {
          print('✅ Profile photo converted to Base64');
        }
      }

      // 3. Update display name
      print('🔵 Updating display name...');
      await userCredential.user?.updateDisplayName(username);
      print('✅ Display name updated');

      // 4. Buat user model
      print('🔵 Creating user model...');
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        username: username,
        email: email.trim(),
        photoUrl: photoBase64,
        createdAt: DateTime.now(),
      );
      print('✅ User model created');

      // 5. Simpan data user ke Firestore
      print('🔵 Saving user data to Firestore...');
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());
      print('✅ User data saved to Firestore');

      print('✅ Registration completed successfully!');
      return {
        'success': true,
        'message': 'Registrasi berhasil!',
        'user': newUser,
      };
    } on FirebaseAuthException catch (e) {
      print('🔴 FirebaseAuthException: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': _handleAuthException(e),
      };
    } catch (e) {
      print('🔴 Unexpected error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Login dengan Email & Password
  Future<Map<String, dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Get user data dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromMap(
          userDoc.data() as Map<String, dynamic>,
        );

        return {
          'success': true,
          'message': 'Login berhasil!',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Data user tidak ditemukan',
        };
      }
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _handleAuthException(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Sign Out (including Google)
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
    ]);
  }

  // Get user data dari Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData({
    required String uid,
    String? username,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (username != null) updateData['username'] = username;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;

      await _firestore
          .collection('users')
          .doc(uid)
          .update(updateData);

      return true;
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  // Cek apakah username sudah digunakan
  Future<bool> _checkUsernameExists(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  // Handle Firebase Auth Exception
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'User tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {
        'success': true,
        'message': 'Email reset password telah dikirim.',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _handleAuthException(e),
      };
    }
  }

  // ===================== FACEBOOK LOGIN =====================
  Future<Map<String, dynamic>> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        return {'success': false, 'message': 'Login Facebook dibatalkan'};
      }

      final OAuthCredential credential =
      FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user!;

      final doc =
      await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        final userModel = UserModel(
          uid: user.uid,
          username: user.displayName ?? 'Facebook User',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(
          userModel.toMap(),
        );
      }

      return {'success': true, 'message': 'Login Facebook berhasil'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Login Facebook gagal'
      };
    }
  }


}