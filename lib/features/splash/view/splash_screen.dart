import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Check session setelah animation
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Tunggu minimal 2 detik untuk splash screen
    await Future.delayed(const Duration(seconds: 2));

    final authController = Get.find<AuthController>();

    // Tunggu sampai session checking selesai
    while (authController.isCheckingSession.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Navigate berdasarkan status login
    if (authController.currentUser.value != null) {
      // User sudah login, ke home
      Get.offAllNamed('/home');
    } else {
      // User belum login, ke login page
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B95A8),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Icon Aplikasi
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/social_bear.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // App Name
              const Text(
                'SocialApp',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // Tagline
              Text(
                'Connect, Share, Stay Safe',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 50),

              // Loading Indicator
              Obx(() {
                final authController = Get.find<AuthController>();
                return authController.isCheckingSession.value
                    ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}