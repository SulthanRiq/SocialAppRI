import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/core/controllers/post_controller.dart';
import '../models/user_model.dart';
import '../../features/register/services/auth_service.dart';
import 'analytics_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<File?> selectedProfileImage = Rx<File?>(null);
  final RxBool isCheckingSession = true.obs; // Status checking session

  // Text Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // SharedPreferences keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUsername = 'username';

  @override
  void onInit() {
    super.onInit();

    // Check session saat app start
    _checkSession();

    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        currentUser.value = null;
      }
    });
  }

  @override
  void onClose() {
    // usernameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }

  // Check session dari SharedPreferences
  Future<void> _checkSession() async {
    try {
      isCheckingSession.value = true;
      print('🔍 Checking session...');

      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      final userId = prefs.getString(_keyUserId);

      if (isLoggedIn && userId != null) {
        print('✅ Session found, loading user data...');
        await _loadUserData(userId);

        // Auto navigate to home jika sudah login
        await Future.delayed(const Duration(milliseconds: 500));
        if (currentUser.value != null) {
          Get.offAllNamed('/home');
        }
      } else {
        print('ℹ️ No active session found');
      }
    } catch (e) {
      print('🔴 Error checking session: $e');
    } finally {
      isCheckingSession.value = false;
    }
  }

  // Save session ke SharedPreferences
  Future<void> _saveSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserId, user.uid);
      await prefs.setString(_keyUserEmail, user.email);
      await prefs.setString(_keyUsername, user.username);
      print('✅ Session saved');
    } catch (e) {
      print('🔴 Error saving session: $e');
    }
  }

  // Clear session dari SharedPreferences
  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyUsername);
      print('✅ Session cleared');
    } catch (e) {
      print('🔴 Error clearing session: $e');
    }
  }

  // Get saved user info (optional, untuk display di UI)
  Future<Map<String, String?>> getSavedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'email': prefs.getString(_keyUserEmail),
        'username': prefs.getString(_keyUsername),
      };
    } catch (e) {
      return {'email': null, 'username': null};
    }
  }

  // Pick image from gallery or camera
  Future<void> pickProfileImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        selectedProfileImage.value = File(pickedFile.path);
        print('✅ Profile image selected: ${pickedFile.path}');
      }
    } catch (e) {
      print('🔴 Error picking image: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Show image source dialog
  Future<void> showImageSourceDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  pickProfileImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  pickProfileImage(context, ImageSource.camera);
                },
              ),
              if (selectedProfileImage.value != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    selectedProfileImage.value = null;
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text('Batal'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    final userData = await _authService.getUserData(uid);
    if (userData != null) {
      currentUser.value = userData;
      // Save session setiap kali load user data
      await _saveSession(userData);
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validasi input register
  String? _validateRegisterInput() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty) {
      return 'Username tidak boleh kosong';
    }

    if (username.length < 3) {
      return 'Username minimal 3 karakter';
    }

    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!GetUtils.isEmail(email)) {
      return 'Format email tidak valid';
    }

    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    if (confirmPassword.isEmpty) {
      return 'Confirm password tidak boleh kosong';
    }

    if (password != confirmPassword) {
      return 'Password tidak sama';
    }

    return null; // Valid
  }

  // Register function
  Future<void> register(BuildContext context) async {
    // Validasi input
    final validationError = _validateRegisterInput();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.registerWithEmailPassword(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        photoFile: selectedProfileImage.value,
      );

      isLoading.value = false;

      if (result['success']) {
        final userModel = result['user'];

        if (userModel != null) {
          currentUser.value = userModel;
          // Save session setelah register berhasil
          await _saveSession(userModel);
        }

        // Track signup
        final analyticsController = Get.find<AnalyticsController>();
        await analyticsController.trackSignUp(method: 'email');

        // Set current user
        await analyticsController.setCurrentUser(result['user']);

        // Clear fields
        _clearFields();

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green.shade400,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Navigate to home
        print('✅ Navigating to home page...');
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          Get.offAllNamed('/home');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red.shade400,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      print('🔴 Registration error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Login function
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Email dan password tidak boleh kosong',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.loginWithEmailPassword(
        email: email,
        password: password,
      );

      isLoading.value = false;

      if (result['success']) {
        // Load user data dan save session
        final user = result['user'];
        if (user != null) {
          currentUser.value = user;
          await _saveSession(user);
        }

        final analyticsController = Get.find<AnalyticsController>();
        await analyticsController.trackLogin(method: 'email');

        // Set current user
        await analyticsController.setCurrentUser(result['user']);

        // Refresh posts
        try {
          final postController = Get.find<PostController>();
          postController.refreshPosts();
        } catch (e) {
          print('Post controller not found: $e');
        }

        _clearFields();

        Get.showSnackbar(
          GetSnackBar(
            title: 'Berhasil',
            message: result['message'],
            backgroundColor: Colors.green.shade400,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed('/home');
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: 'Error',
            message: result['message'],
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Terjadi kesalahan: ${e.toString()}',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
    }
  }

  // Logout function - Clear session
  Future<void> logout() async {
    try {
      // Logout dari Firebase Auth & Google
      await _authService.signOut();

      // Clear session dari SharedPreferences
      await _clearSession();

      // Track logout
      final analyticsController = Get.find<AnalyticsController>();
      await analyticsController.trackLogout();

      // Clear current user
      currentUser.value = null;

      // Clear text controllers tanpa dispose
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      selectedProfileImage.value = null;

      print('✅ Logout successful');
    } catch (e) {
      print('🔴 Logout error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Masukkan email yang valid',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
      return;
    }

    isLoading.value = true;

    final result = await _authService.resetPassword(email);

    isLoading.value = false;

    if (result['success']) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Berhasil',
          message: result['message'],
          backgroundColor: Colors.green.shade400,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: result['message'],
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
    }
  }

  Future<void> loginWithFacebook() async {
    isLoading.value = true;

    final result = await _authService.loginWithFacebook();

    isLoading.value = false;

    if (result['success']) {
      // Save session setelah login Facebook berhasil
      final user = result['user'];
      if (user != null) {
        currentUser.value = user;
        await _saveSession(user);
      }
    }

    Get.showSnackbar(
      GetSnackBar(
        title: result['success'] ? 'Berhasil' : 'Error',
        message: result['message'],
        backgroundColor: result['success']
            ? Colors.green.shade400
            : Colors.red.shade400,
        duration: const Duration(seconds: 3),
      ),
    );

    if (result['success']) {
      Get.offAllNamed('/home');
    }
  }

  // Clear all fields
  void _clearFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedProfileImage.value = null;
  }
}