import 'package:flutter/material.dart';

class PoliticsCommentView extends StatefulWidget {
  const PoliticsCommentView({super.key});

  @override
  State<PoliticsCommentView> createState() => _PoliticsCommentViewState();
}

class _PoliticsCommentViewState extends State<PoliticsCommentView> {
  final TextEditingController _commentController = TextEditingController();

  // Data komentar dummy untuk politik
  final List<CommentData> _comments = [
    CommentData(
      username: '@berita_bangsa',
      timeAgo: '2j',
      comment: 'Rakyat susah, mereka malah korupsi! Kapan Indonesia bersih koruptor? 😡',
      likes: 14,
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    CommentData(
      username: '@suara_hati_rakyat',
      timeAgo: '2j',
      comment: 'Pemerintah harus!!! itu sangat rakyat untuk keadilan dan pendidikan! Miris banget 😭',
      likes: 24,
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
    ),
    CommentData(
      username: '@anti_korupsi_id',
      timeAgo: '37m',
      comment: 'Hukuman seumur-hidup!!! Jangan ada toleransi untuk koruptor!',
      likes: 35,
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
    ),
    CommentData(
      username: '@warga_peduli',
      timeAgo: '5m',
      comment: 'Masih ada aja oknum yang korupsi. Kapan negara ini maju kalau begini terus 😞',
      likes: 16,
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B95A8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B95A8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Komentar',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // List komentar
          Expanded(
            child: Container(
              color: const Color(0xFFB8C5CC),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(comment: _comments[index]);
                },
              ),
            ),
          ),

          // Input komentar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Icon gambar
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: Colors.black54),
                  onPressed: () {},
                ),

                // Text field
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan komentar...',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),

                // Icon send
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF6B95A8)),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      // TODO: Kirim komentar
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          // Suggestion buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSuggestionButton('Suggest'),
                _buildSuggestionButton('Suggest'),
                _buildSuggestionButton('Suggest'),
              ],
            ),
          ),

          // Keyboard (static representation)
          Container(
            color: const Color(0xFFD1D5DB),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                // Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKeyButton('Q'),
                    _buildKeyButton('W'),
                    _buildKeyButton('E'),
                    _buildKeyButton('R'),
                    _buildKeyButton('T'),
                    _buildKeyButton('Y'),
                    _buildKeyButton('U'),
                    _buildKeyButton('I'),
                    _buildKeyButton('O'),
                    _buildKeyButton('P'),
                  ],
                ),
                const SizedBox(height: 6),
                // Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 15),
                    _buildKeyButton('A'),
                    _buildKeyButton('S'),
                    _buildKeyButton('D'),
                    _buildKeyButton('F'),
                    _buildKeyButton('G'),
                    _buildKeyButton('H'),
                    _buildKeyButton('J'),
                    _buildKeyButton('K'),
                    _buildKeyButton('L'),
                    const SizedBox(width: 15),
                  ],
                ),
                const SizedBox(height: 6),
                // Row 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKeyButton('⬆', isWide: true),
                    _buildKeyButton('Z'),
                    _buildKeyButton('X'),
                    _buildKeyButton('C'),
                    _buildKeyButton('V'),
                    _buildKeyButton('B'),
                    _buildKeyButton('N'),
                    _buildKeyButton('M'),
                    _buildKeyButton('⌫', isWide: true),
                  ],
                ),
                const SizedBox(height: 6),
                // Row 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKeyButton('123', isWide: true),
                    _buildKeyButton('space', isExtraWide: true),
                    _buildKeyButton('Go', isWide: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildKeyButton(String text, {bool isWide = false, bool isExtraWide = false}) {
    double width = 28;
    if (isWide) width = 45;
    if (isExtraWide) width = 140;

    return Container(
      width: width,
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// Model data komentar
class CommentData {
  final String username;
  final String timeAgo;
  final String comment;
  final int likes;
  final String avatarUrl;

  CommentData({
    required this.username,
    required this.timeAgo,
    required this.comment,
    required this.likes,
    required this.avatarUrl,
  });
}

// Widget item komentar
class CommentItem extends StatelessWidget {
  final CommentData comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username dan waktu
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (comment.timeAgo.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        comment.timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Komentar
                Text(
                  comment.comment,
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 6),

                // Likes dan Balas
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.likes}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Balas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}