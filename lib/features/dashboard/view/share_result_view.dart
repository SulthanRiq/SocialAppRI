import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFBCCCD6),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // VERIFIKASI BERHASIL
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

                    // Card Quiz Info
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

                    // POST PREVIEW
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

                    // Card Post Preview
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

                    // SMART SUGGESTIONS
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.black87, size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SMART SUGGESTIONS:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(Pilih salah satu untuk ditambahkan)',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Checkbox List
                    ...List.generate(_suggestions.length, (index) {
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

                    const SizedBox(height: 20),

                    // Caption Tambahan
                    const Text(
                      'Tulis caption tambahan :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // TextField
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

                    // Tombol Share
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _handleShare,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FA37E),
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

                    // Bottom Indicator
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil di-share!'),
        backgroundColor: Color(0xFF8FA37E),
      ),
    );

    // Kembali ke dashboard
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}