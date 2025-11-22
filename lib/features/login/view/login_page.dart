import 'package:flutter/material.dart';
import 'package:projek_mobile/features/register/view/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.alternate_email, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Email or Username',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // FIELD PASSWORD
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock_outline, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Password',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // TODO: aksi lupa password
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
                    SizedBox(
                      width: 140,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: aksi login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),

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
}
