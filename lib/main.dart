import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:projek_mobile/core/controllers/auth_controller.dart';
import 'package:projek_mobile/core/controllers/comment_controller.dart';
import 'package:projek_mobile/core/controllers/post_controller.dart';
import 'package:projek_mobile/features/inbox/controller/chat_controller.dart';
import 'package:projek_mobile/features/splash/view/splash_screen.dart';
import 'features/notification/controller/notification_controller.dart';
// Import pages
import 'features/login/view/login_page.dart';
import 'features/register/view/register_page.dart';
import 'features/dashboard/view/dashboard_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  Get.put(AuthController());
  Get.put(PostController());
  Get.put(CommentController());
  Get.put(NotificationController());
  Get.put(ChatController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      // Initial route
      initialRoute: '/splash',

      // Define routes
      getPages: [
        GetPage(
            name: '/splash',
            page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
      ],
    );
  }
}