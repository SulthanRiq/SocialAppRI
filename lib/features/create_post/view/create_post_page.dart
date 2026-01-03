// Create Post Page

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_mobile/core/controllers/post_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../register/widgets/base64_image_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Set<String> _selectedTopics = {};
  bool _isPosting = false;

  final Map<String, Color> topicColors = {
    'Technology': const Color(0xFFB8860B),
    'Sports': const Color(0xFF6B9B7F),
    'Design': const Color(0xFF9B8BB3),
    'Business': const Color(0xFF8FA870),
    'Politics': const Color(0xFF4A3A3A),
    'Science': const Color(0xFF2B5F75),
    'Health': const Color(0xFFA97676),
    'Gaming': const Color(0xFF4A8B8B),
  };

  final AuthController authController = Get.put(AuthController());
  final PostController postController = Get.find<PostController>();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan dialog pilihan (Galeri atau Kamera)
  Future<void> _showImageSourceDialog() async {
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
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
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

  // Fungsi untuk mengambil gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Fungsi untuk hapus gambar
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Fungsi untuk posting
  Future<void> _handlePost() async {
    if (_postController.text.trim().isEmpty && _selectedImage == null) return;

    await postController.createPost(
      content: _postController.text.trim(),
      imageFile: _selectedImage,
      topics: _selectedTopics.toList(),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post berhasil dibuat')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFBFC8CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Container(
              height: 60,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Close (X)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  // Tombol Post
                  ElevatedButton(
                    onPressed: _isPosting ? null : _handlePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isPosting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blue,
                            ),
                          )
                        : const Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan foto profil
                    Obx(() {
                      final user = authController.currentUser.value;
                      final photoUrl = user?.photoUrl;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Base64CircleAvatar(
                            base64String: photoUrl,
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // Topic Selection
                    const Text(
                      'Pilih Topic (Opsional):',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: topicColors.keys.map((topic) {
                        final isSelected = _selectedTopics.contains(topic);
                        return FilterChip(
                          label: Text(topic),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTopics.add(topic);
                              } else {
                                _selectedTopics.remove(topic);
                              }
                            });
                          },
                          selectedColor: topicColors[topic]!.withOpacity(0.3),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Preview gambar yang dipilih
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // BOTTOM ACTION BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Tombol tambah foto
                  IconButton(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk suggest chip
  Widget _buildSuggestChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}
