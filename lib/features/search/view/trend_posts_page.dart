import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class TrendPostsPage extends StatefulWidget {
  final String trendTitle;

  const TrendPostsPage({super.key, required this.trendTitle});

  @override
  State<TrendPostsPage> createState() => _TrendPostsPageState();
}

class _TrendPostsPageState extends State<TrendPostsPage> {
  late final Map<String, List<Map<String, dynamic>>> trendPosts;

  @override
  void initState() {
    super.initState();

    trendPosts = {
      'Berani bermimpi besar': [
        {
          'id': 'mimpi_1',
          'username': 'Alya',
          'handle': '@alya_07',
          'time': '1 jam',
          'content': 'Berani bermimpi besar itu dimulai dari langkah kecil.',
          'imageUrl': 'https://picsum.photos/seed/mimpi1/800/600',
          'commentsCount': 12,
          'likesCount': 35,
          'sharesCount': 7,
          'isLiked': false,
          'comments': <Map<String, String>>[
            {'user': 'Raka', 'text': 'Setuju banget!'},
            {'user': 'Dina', 'text': 'Semangat terus ya!'},
          ],
        },
        {
          'id': 'mimpi_2',
          'username': 'Raka',
          'handle': '@raka.id',
          'time': '3 jam',
          'content': 'Mimpi besar + konsisten = hasil nyata.',
          'imageUrl': 'https://picsum.photos/seed/mimpi2/800/600',
          'commentsCount': 8,
          'likesCount': 21,
          'sharesCount': 4,
          'isLiked': true,
          'comments': <Map<String, String>>[
            {'user': 'Alya', 'text': 'Keren kata-katanya!'},
          ],
        },
      ],
      'Indonesia Bersatu': [
        {
          'id': 'indo_1',
          'username': 'Bima',
          'handle': '@bima_nusantara',
          'time': '45 mnt',
          'content': 'Beda pilihan tetap satu tujuan: Indonesia maju.',
          'imageUrl': 'https://picsum.photos/seed/bangsa1/800/600',
          'commentsCount': 4,
          'likesCount': 18,
          'sharesCount': 2,
          'isLiked': false,
          'comments': <Map<String, String>>[
            {'user': 'Sari', 'text': 'Amin!'},
          ],
        },
      ],
      'Bebas Narkoba': [
        {
          'id': 'anti_1',
          'username': 'Dina',
          'handle': '@dina.care',
          'time': '2 jam',
          'content': 'Katakan tidak pada narkoba, katakan iya pada masa depan.',
          'imageUrl': 'https://picsum.photos/seed/narkoba1/800/600',
          'commentsCount': 10,
          'likesCount': 40,
          'sharesCount': 9,
          'isLiked': false,
          'comments': <Map<String, String>>[
            {'user': 'Fahri', 'text': 'Setuju, jaga masa depan.'},
            {'user': 'Alya', 'text': 'Keren edukasinya!'},
          ],
        },
      ],
    };
  }

  List<Map<String, dynamic>> get _posts => trendPosts[widget.trendTitle] ?? [];

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFB8C5CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.trendTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // LIST POSTINGAN
            Expanded(
              child: _posts.isEmpty
                  ? const Center(child: Text('Belum ada postingan'))
                  : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = _posts[index];
                  return _PostCard(
                    username: p['username'] ?? '',
                    handle: p['handle'] ?? '',
                    time: p['time'] ?? '',
                    content: p['content'] ?? '',
                    imageUrl: p['imageUrl'] ?? '',
                    commentsCount: (p['commentsCount'] ?? 0) as int,
                    likesCount: (p['likesCount'] ?? 0) as int,
                    sharesCount: (p['sharesCount'] ?? 0) as int,
                    isLiked: (p['isLiked'] ?? false) as bool,
                    onLike: () => _toggleLike(index),
                    onComment: () => _openComments(index),
                    onShare: () => _showShareBottomSheet(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike(int index) {
    setState(() {
      final post = _posts[index];
      final bool isLiked = (post['isLiked'] ?? false) as bool;

      post['isLiked'] = !isLiked;

      int likes = (post['likesCount'] ?? 0) as int;
      post['likesCount'] = isLiked ? (likes - 1) : (likes + 1);
    });
  }

  void _openComments(int index) {
    final post = _posts[index];
    final List<Map<String, String>> comments =
        (post['comments'] as List<Map<String, String>>?) ?? [];

    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            void addComment() {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              setModalState(() {
                comments.insert(0, {'user': 'You', 'text': text});
                controller.clear();
              });

              setState(() {
                post['commentsCount'] = (post['commentsCount'] ?? 0) + 1;
                post['comments'] = comments;
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.65,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Komentar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(child: Text('Belum ada komentar'))
                          : ListView.separated(
                        padding: const EdgeInsets.all(14),
                        itemCount: comments.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final c = comments[i];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?u=${c['user']}',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c['user'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        c['text'] ?? '',
                                        style:
                                        const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => addComment(),
                              decoration: InputDecoration(
                                hintText: 'Tulis komentar...',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: addComment,
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(controller.dispose);
  }

  // =========================
  // ✅ SHARE BOTTOM SHEET (MODEL DASHBOARD)
  // =========================
  void _showShareBottomSheet(int index) {
    final post = _posts[index];

    final String username = post['handle'] ?? '';
    final String text = post['content'] ?? '';
    final String link = 'app://trend/${widget.trendTitle}/${post['id']}';
    final String shareText = '$username\n$text\n\n$link';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Share to',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  text: shareText,
                  onShared: () => _incShareCount(index),
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.public, // ✅ aman untuk "Facebook"
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  text: shareText,
                  onShared: () => _incShareCount(index),
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.alternate_email, // ✅ "Twitter"
                  label: 'Twitter',
                  color: const Color(0xFF1DA1F2),
                  text: shareText,
                  onShared: () => _incShareCount(index),
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.more_horiz,
                  label: 'More',
                  color: Colors.grey,
                  text: shareText,
                  onShared: () => _incShareCount(index),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy link'),
              subtitle: Text(link),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: link));
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link disalin')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _incShareCount(int index) {
    setState(() {
      _posts[index]['sharesCount'] = (_posts[index]['sharesCount'] ?? 0) + 1;
    });
  }

  Widget _buildShareButton({
    required BuildContext ctx,
    required IconData icon,
    required String label,
    required Color color,
    required String text,
    required VoidCallback onShared,
  }) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(ctx);
        await Share.share(text);
        onShared();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String username;
  final String handle;
  final String time;
  final String content;
  final String imageUrl;

  final int commentsCount;
  final int likesCount;
  final int sharesCount;
  final bool isLiked;

  final VoidCallback onComment;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const _PostCard({
    required this.username,
    required this.handle,
    required this.time,
    required this.content,
    required this.imageUrl,
    required this.commentsCount,
    required this.likesCount,
    required this.sharesCount,
    required this.isLiked,
    required this.onComment,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?u=$handle'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '  $handle',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: ' · $time',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.black54),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.3),
          ),

          const SizedBox(height: 10),

          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('Gambar gagal dimuat'),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          Row(
            children: [
              _ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                iconColor: isLiked ? Colors.red : Colors.black54,
                label: likesCount.toString(),
                onTap: onLike,
              ),
              const SizedBox(width: 18),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: commentsCount.toString(),
                onTap: onComment,
              ),
              const SizedBox(width: 18),
              _ActionButton(
                icon: Icons.share,
                label: sharesCount.toString(),
                onTap: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = iconColor ?? Colors.black54;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}