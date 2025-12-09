import 'package:flutter/material.dart';
import 'package:projek_mobile/features/dashboard/view/share_result_view.dart';
import 'package:projek_mobile/features/dashboard/view/article_detail_view.dart';

class ShareView extends StatefulWidget {
  final dynamic article;

  const ShareView({super.key, required this.article});

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  int? _readStatusValue;
  int? _understandStatusValue;

  /// --------------------------------------------
  /// FUNGSI DIPANGGIL SAAT TOMBOL SHARE DITEKAN
  /// --------------------------------------------
  void _shareToSocialMedia() {
    String quizScore = _calculateQuizScore();
    String status = _getReaderStatus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareResultView(
          quizScore: quizScore,
          readingTime: '3m 15s',
          status: status,
          articleTitle: widget.article['title'] ?? 'Artikel Tidak Diketahui',
          source: widget.article['source'] ?? 'Sumber Tidak Diketahui',
          verifiedBy: 'Budi',
        ),
      ),
    );
  }

  /// --------------------------------------------
  /// FUNGSI UNTUK MEMBUKA ARTIKEL LENGKAP
  /// --------------------------------------------
  void _openFullArticle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(
          article: widget.article,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Back", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Content\nVerification",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // --- TIDAK MENGUBAH UI ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning_amber_outlined, size: 28),
                          SizedBox(width: 8),
                          Text(
                            "TUNGGU SEBENTAR!",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 2, color: Colors.black54, height: 30),
                    const Row(
                      children: [
                        Icon(Icons.psychology, size: 24),
                        SizedBox(width: 8),
                        Text("ANALISIS :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ANALISIS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Konten ini terdeteksi :", style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 12),
                          _buildAnalysisItem(Icons.sentiment_dissatisfied_outlined, "Emotional Trigger", "85%", "Dirancang memicu kemarahan"),
                          const SizedBox(height: 10),
                          _buildAnalysisItem(Icons.flash_on, "Viral Potential High", "", "8,900 shares dalam 15 menit"),
                          const SizedBox(height: 10),
                          _buildAnalysisItem(Icons.warning_amber_rounded, "Unverified Claims", "", ""),
                          Padding(
                            padding: const EdgeInsets.only(left: 34.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('• "Triliunan" - no source', style: TextStyle(fontSize: 13)),
                                Text('• "Bukti" - not shown', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Row(
                      children: [
                        Icon(Icons.checklist_rtl, size: 24),
                        SizedBox(width: 8),
                        Text("VERIFIKASI PEMAHAMAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Text("Sudah baca artikelnya?", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          _buildRadioOption(1, "Ya, baca semua", _readStatusValue, (v) => setState(() => _readStatusValue = v)),
                          _buildRadioOption(2, "Belum, baru judul", _readStatusValue, (v) => setState(() => _readStatusValue = v)),
                          _buildRadioOption(3, "Sebagian", _readStatusValue, (v) => setState(() => _readStatusValue = v)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text("Seberapa pemahaman kamu?", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          _buildRadioOption(1, "100%", _understandStatusValue, (v) => setState(() => _understandStatusValue = v)),
                          _buildRadioOption(2, "50%", _understandStatusValue, (v) => setState(() => _understandStatusValue = v)),
                          _buildRadioOption(3, "Lainnya", _understandStatusValue, (v) => setState(() => _understandStatusValue = v)),
                        ],
                      ),
                    ),

                    const Divider(thickness: 2, color: Colors.black54, height: 40),

                    const Center(
                      child: Text(
                        "PILIH TINDAKAN",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                          child: const Text(
                            "KEMBALI KE DASHBOARD",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _openFullArticle,
                          child: const Text(
                            "BACA ARTIKEL LENGKAP",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF60859A),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _shareToSocialMedia,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FA37E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Share", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------
  // LOGIC QUIZ
  // ---------------------------------------
  String _calculateQuizScore() {
    int score = 0;
    if (_readStatusValue == 1) score++;
    if (_understandStatusValue == 1) score++;
    return '$score/2';
  }

  String _getReaderStatus() {
    if (_readStatusValue == 1 && _understandStatusValue == 1) {
      return 'Informed Reader';
    } else if (_readStatusValue == 1 || _understandStatusValue == 1) {
      return 'Partial Reader';
    } else {
      return 'Quick Reader';
    }
  }

  // ---------------------------------------
  // UI COMPONENT
  // ---------------------------------------
  Widget _buildAnalysisItem(IconData icon, String title, String stat, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (stat.isNotEmpty)
                      TextSpan(text: "\n$stat", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (desc.isNotEmpty) Text(desc, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(int value, String text, int? groupValue, Function(int?) onChanged) {
    return RadioListTile<int>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(text, style: const TextStyle(fontSize: 14)),
      dense: true,
      visualDensity: VisualDensity.compact,
      activeColor: Colors.black,
    );
  }
}