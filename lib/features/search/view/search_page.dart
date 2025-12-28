import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import '../../dashboard/view/dashboard_register_page.dart';
import '../../focs/view/focs_page.dart';
import '../../notification/view/notification_page.dart';
import '../../inbox/view/inbox_page.dart';
import 'trend_posts_page.dart';
import '../../profile/view/profile.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/post_controller.dart';
import '../controller/search_controller.dart' as custom;
import '../../register/widgets/base64_image_widget.dart';
import '../../comment/view/comment_bottom_sheet.dart';
import '../../dashboard/view/share_post_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1;
  int _selectedTabIndex = 0;

  final AuthController authController = Get.find<AuthController>();
  final PostController postController = Get.find<PostController>();
  final custom.SearchController searchController = Get.put(custom.SearchController());

  final TextEditingController _searchTextController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    searchController.clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFB8C5CC);
    final Color tabBarColor = const Color(0xFF9AADBA);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan foto profil
            Obx(() {
              final user = authController.currentUser.value;
              final photoUrl = user?.photoUrl;

              return Container(
                height: 70,
                width: double.infinity,
                color: topBarColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Foto profil
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileMenuPage(),
                          ),
                        );
                      },
                      child: Base64CircleAvatar(
                        base64String: photoUrl,
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // SEARCH BAR
            Container(
              color: topBarColor,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {
                      _isSearchActive = value.isNotEmpty;
                    });
                    searchController.searchPosts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari postingan atau pengguna...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    suffixIcon: _isSearchActive
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchTextController.clear();
                        setState(() {
                          _isSearchActive = false;
                        });
                        searchController.clearSearch();
                        FocusScope.of(context).unfocus();
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // TAB BAR (hanya tampil jika tidak search)
            if (!_isSearchActive)
              Container(
                height: 50,
                color: tabBarColor,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: _selectedTabIndex == 0
                                ? const Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 3,
                              ),
                            )
                                : null,
                          ),
                          child: Text(
                            'Untuk Anda',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _selectedTabIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: _selectedTabIndex == 1
                                ? const Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 3,
                              ),
                            )
                                : null,
                          ),
                          child: Text(
                            'Sedang Tren',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _selectedTabIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // CONTENT AREA
            Expanded(
              child: _isSearchActive
                  ? _buildSearchResults()
                  : (_selectedTabIndex == 0
                  ? _buildUntukAndaTab()
                  : _buildSedangTrenTab()),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FocsCScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InboxScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  // ✅ BUILD SEARCH RESULTS
  Widget _buildSearchResults() {
    return Obx(() {
      // Loading state
      if (searchController.isSearching.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Empty state
      if (searchController.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada hasil untuk "${searchController.searchQuery.value}"',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      // Search results list
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: searchController.searchResults.length,
        itemBuilder: (context, index) {
          final post = searchController.searchResults[index];
          final isLiked = postController.isPostLikedByCurrentUser(post);
          final isOwnPost = postController.isOwnPost(post);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USER INFO & DELETE BUTTON
                Row(
                  children: [
                    Base64CircleAvatar(
                      base64String: post.userPhoto,
                      radius: 20,
                      backgroundColor: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _formatTime(post.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isOwnPost)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 22,
                        ),
                        onPressed: () {
                          _showDeleteDialog(context, post);
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // CONTENT
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                // IMAGE
                if (post.imageBase64 != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      base64Decode(post.imageBase64!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Divider(
                  color: Colors.grey.shade400,
                  thickness: 1,
                ),

                const SizedBox(height: 8),

                // ✅ LIKE, COMMENT & SHARE BUTTONS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Like Button
                        InkWell(
                          onTap: isOwnPost
                              ? null
                              : () => postController.toggleLike(post),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isOwnPost
                                      ? Colors.grey.shade400
                                      : (isLiked
                                      ? Colors.red
                                      : Colors.grey.shade700),
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${post.likes}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Comment Button
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  CommentBottomSheet(post: post),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: Colors.grey.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${post.commentsCount}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Share Button
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SharePostView(post: post),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.share_outlined,
                              color: Colors.grey.shade700,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (isOwnPost) ...[
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '(Postingan Anda)',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _goToTrend(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrendPostsPage(trendTitle: title),
      ),
    );
  }

  Widget _buildUntukAndaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Berani bermimpi besar',
          postsCount: '7,189 postingan',
          onTap: () => _goToTrend('Berani bermimpi besar'),
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Indonesia Bersatu',
          postsCount: '1,724 postingan',
          onTap: () => _goToTrend('Indonesia Bersatu'),
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Bebas Narkoba',
          postsCount: '1,622 postingan',
          onTap: () => _goToTrend('Bebas Narkoba'),
        ),
      ],
    );
  }

  Widget _buildSedangTrenTab() {
    final trends = [
      {
        'rank': '#1',
        'title': '#MAYATYAWARDS2025',
        'posts': '1,98 jt postingan',
        'goTitle': 'MAYATYAWARDS2025',
      },
      {
        'rank': '#2',
        'title': '#Berani bermimpi besar',
        'posts': '7.189 postingan',
        'goTitle': 'Berani bermimpi besar',
      },
      {
        'rank': '#3',
        'title': '#IndonesiaBebasNarkoba',
        'posts': '2.449 postingan',
        'goTitle': 'Bebas Narkoba',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(trends.length, (i) {
              final t = trends[i];
              final bool isLast = i == trends.length - 1;

              return Column(
                children: [
                  _buildTrendingItem(
                    category: 'Sedang tren dalam indonesia',
                    title: t['title'] as String,
                    postsCount: t['posts'] as String,
                    rankText: t['rank'] as String,
                    onTap: () => _goToTrend(t['goTitle'] as String),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 14,
                        thickness: 0.8,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingItem({
    required String category,
    required String title,
    required String postsCount,
    required String rankText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    postsCount,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              rankText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard({
    required String category,
    required String title,
    required String postsCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              postsCount,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  void _showDeleteDialog(BuildContext context, post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Postingan'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              postController.deletePost(post);
              Navigator.pop(context);
              Get.snackbar(
                'Sukses',
                'Postingan berhasil dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}