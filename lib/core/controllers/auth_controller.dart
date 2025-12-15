import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:projek_mobile/core/controllers/post_controller.dart';
import '../models/user_model.dart';
import '../../features/register/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<File?> selectedProfileImage = Rx<File?>(null);

  // Text Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
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
      // Gunakan ScaffoldMessenger untuk snackbar yang lebih reliable
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

        final userModel = result['user']; // 👈 ambil user

        if (userModel != null) {
          currentUser.value = userModel; // 🔥 FORCE LOGIN
        }

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

        // Gunakan Navigator biasa atau Get.offAll
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          // Option 1: Gunakan Navigator.pushReplacement
          // Navigator.of(context).pushReplacementNamed('/home');

          // Option 2: Atau gunakan Get.offAllNamed jika route sudah di-setup
          Get.offAllNamed('/home');

          // Option 3: Atau direct navigation ke HomePage
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => const HomePage()),
          // );
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
        final postController = Get.find<PostController>();
        postController.refreshPosts();

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

  // Logout function - Updated untuk menghindari TextEditingController error
  Future<void> logout() async {
    try {
      // Logout dari Firebase Auth & Google
      await _authService.signOut();

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