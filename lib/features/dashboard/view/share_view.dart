import 'package:flutter/material.dart';

class ShareView extends StatefulWidget {
  const ShareView({super.key});

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  int? _readStatusValue = 0;
  int? _understandStatusValue = 0;

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

            // CONTENT
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

                    // ANALISIS
                    const Row(
                      children: [
                        Icon(Icons.psychology, size: 24),
                        SizedBox(width: 8),
                        Text("ANALISIS :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                Text("• \"Triliunan\" - no source", style: TextStyle(fontSize: 13)),
                                Text("• \"Bukti\" - not shown", style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // VERIFIKASI
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
                          _buildRadioOption(1, "Ya, baca semua", _readStatusValue, (val) => setState(() => _readStatusValue = val)),
                          _buildRadioOption(2, "Belum, baru judul", _readStatusValue, (val) => setState(() => _readStatusValue = val)),
                          _buildRadioOption(3, "Sebagian", _readStatusValue, (val) => setState(() => _readStatusValue = val)),
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
                          _buildRadioOption(1, "100%", _understandStatusValue, (val) => setState(() => _understandStatusValue = val)),
                          _buildRadioOption(2, "50%", _understandStatusValue, (val) => setState(() => _understandStatusValue = val)),
                          _buildRadioOption(3, "Lainnya", _understandStatusValue, (val) => setState(() => _understandStatusValue = val)),
                        ],
                      ),
                    ),

                    const Divider(thickness: 2, color: Colors.black54, height: 40),

                    // BUTTON SHARE FINAL
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Shared successfully!")));
                          },
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
                  style: const TextStyle(color: Colors.black, fontFamily: 'sans-serif'),
                  children: [
                    TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    if (stat.isNotEmpty) TextSpan(text: "\n$stat", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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