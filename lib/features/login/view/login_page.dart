import 'package:flutter/material.dart';
import 'package:projek_mobile/features/register/view/register_page.dart';
import '../../dashboard/view/dashboard_content_page.dart';
import '../../../core/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    final Color topBarColor = const Color(0xFF7A5A2F);   // coklat
    final Color bgColor = const Color(0xFF82AFC3);       // biru muda
    final Color accentGreen = const Color(0xFF7ED957);   // hijau teks
    final Color buttonGreen = const Color(0xFF6E9B4B);   // hijau tombol

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR "Welcome To SocialApp"
            Container(
              height: 70,
              width: double.infinity,
              color: topBarColor,
              alignment: Alignment.center,
              child: const Text(
                'Welcome To SocialApp',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Gambar beruang
                    SizedBox(
                      height: 190,
                      child: Image.asset(
                        'assets/images/social_bear.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tagline
                    Text(
                      'Connect, Share, Stay Safe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentGreen,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // FIELD EMAIL
                    _label(Icons.alternate_email, 'Email'),
                    TextField(
                      controller: authController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    // FIELD PASSWORD
                    _label(Icons.lock_outline, 'Password'),
                    Obx(() => TextField(
                      controller: authController.passwordController,
                      obscureText: !authController.isPasswordVisible.value,
                      decoration: _inputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                          authController.togglePasswordVisibility,
                        ),
                      ),
                    )),

                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // TODO: aksi lupa password
                          authController.resetPassword(
                              authController.emailController.text.trim(),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // TOMBOL LOGIN
                    Obx(() => SizedBox(
                      width: 140,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : authController.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: 12),

                    // TOMBOL REGISTER
                    SizedBox(
                      width: 140,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                              ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.2,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // GARIS PEMBATAS
                    SizedBox(
                      width: 200,
                      child: Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'or Login with',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),

                    const SizedBox(height: 12),

                    // GOOGLE & FACEBOOK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // TODO: login dengan Google
                          },
                          child: Image.asset(
                            'assets/icons/google.png',
                            width: 36,
                            height: 36,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            // TODO: login dengan Facebook
                            authController.loginWithFacebook();
                          },
                          child: Image.asset(
                            'assets/icons/facebook.png',
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(IconData icon, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
    );
  }

}
