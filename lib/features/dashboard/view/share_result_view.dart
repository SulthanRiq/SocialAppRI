import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareResultView extends StatefulWidget {
  final String quizScore;
  final String readingTime;
  final String status;
  final String articleTitle;
  final String source;
  final String verifiedBy;

  const ShareResultView({
    super.key,
    this.quizScore = '2/2',
    this.readingTime = '3m 15s',
    this.status = 'Informed Reader',
    this.articleTitle = '"Politisi X Korupsi..."',
    this.source = 'detik.com',
    this.verifiedBy = 'Budi',
  });

  @override
  State<ShareResultView> createState() => _ShareResultViewState();
}

class _ShareResultViewState extends State<ShareResultView> {
  final TextEditingController _captionController = TextEditingController();
  List<bool> _selectedSuggestions = [false, false, false];

  final List<String> _suggestions = [
    '"Saya sudah baca artikel lengkapnya sebelum share"',
    '"Masih dalam proses investigasi, belum ada putusan hukum"',
    '"Link fact-check: [URL]"',
  ];

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah minimal 1 suggestion dipilih
    bool hasSelectedSuggestion = _selectedSuggestions.contains(true);

    return Scaffold(
      backgroundColor: const Color(0xFFBCCCD6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: const Color(0xFF60859A),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Back",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "SHARE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_box, color: Colors.black87, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'VERIFIKASI BERHASIL!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quiz: ${widget.quizScore} ✓',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reading Time: ${widget.readingTime}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${widget.status}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.black38, thickness: 1),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.description_outlined, color: Colors.black87, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'POST PREVIEW:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.articleTitle,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.source,
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '✓ Verified Read by ${widget.verifiedBy}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.black87, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SMART SUGGESTIONS:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    '(Pilih minimal salah satu)',
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  if (!hasSelectedSuggestion)
                                    const Text(
                                      ' *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: !hasSelectedSuggestion
                            ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
                            : null,
                      ),
                      child: Column(
                        children: List.generate(_suggestions.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _selectedSuggestions[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSuggestions[index] = value ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFF60859A),
                                    side: const BorderSide(color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _suggestions[index],
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tulis caption tambahan :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        controller: _captionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: '(Optional)',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                          contentPadding: EdgeInsets.all(12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _handleShare,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelectedSuggestion
                                ? const Color(0xFF8FA37E)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Share sekarang',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleShare() {
    // Validasi: Cek apakah minimal 1 suggestion dipilih
    bool hasSelectedSuggestion = _selectedSuggestions.contains(true);

    if (!hasSelectedSuggestion) {
      _showValidationDialog();
      return;
    }

    String shareText = '${widget.articleTitle}\n${widget.source}\n\n';
    shareText += '✓ Verifikasi Saya:\n';
    shareText += '✓ Status: ${widget.status}\n';
    shareText += '✓ Skor Quiz: ${widget.quizScore}\n';
    shareText += '✓ Waktu Baca: ${widget.readingTime}\n\n';

    for (int i = 0; i < _selectedSuggestions.length; i++) {
      if (_selectedSuggestions[i]) {
        shareText += '${_suggestions[i]}\n';
      }
    }

    if (_captionController.text.isNotEmpty) {
      shareText += '\n${_captionController.text}';
    }

    _showShareBottomSheet(shareText);
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Perhatian!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Mohon pilih minimal satu smart suggestion sebelum melakukan share.',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF60859A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Mengerti', style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  void _showShareBottomSheet(String text) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  text: text,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  text: text,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.send,
                  label: 'Telegram',
                  color: const Color(0xFF0088CC),
                  text: text,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.more_horiz,
                  label: 'More',
                  color: Colors.grey,
                  text: text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required BuildContext ctx,
    required IconData icon,
    required String label,
    required Color color,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        Share.share(text);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}