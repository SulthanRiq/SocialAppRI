import 'package:flutter/material.dart';

class ArticleDetailView extends StatelessWidget {
  const ArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBCCCD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B95A8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Content Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Artikel
                  const Text(
                    'POLITISI X KORUPSI TRILIUNAN RUPIAH !\nBukti Mengejutkan !',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata (Tanggal, Waktu Baca, Views)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('28 okt 2025', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('3 menit', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(width: 12),
                      const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('8,900 views', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ANALISIS Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.search, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'ANALISIS',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildAnalysisItem('✓', 'Emotional Trigger: 85%'),
                        _buildAnalysisItem('✓', 'Viral Potential: High (8,900 shares/15menit)'),
                        _buildAnalysisItem('✗', 'Slaim "Triliunan" - no source'),
                        _buildAnalysisItem('✗', 'Slaim "Bukti" - not shown'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Konten Artikel - Paragraf 1
                  const Text(
                    'Beredar kabar yang menyebutkan bahwa seorang politisi senior terlibat dalam kasus korupsi dengan nilai yang sangat besar. Namun, informasi ini mengundang banyak tanda tanya di media sosial.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle - Kronologi yang Dilalui
                  const Text(
                    'Kronologi yang Diklaim',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Konten Artikel - Paragraf 2
                  const Text(
                    'Menurut sumber yang tidak disebutkan namanya, politisi tersebut diduga terlibat dalam proyek besar yang merugikan negara. Namun, detail spesifik tentang proyek, waktu kejadian, dan bukti pendukung tidak dijelaskan dengan jelas.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle - Fakta atau Spekulasi
                  const Text(
                    'Fakta Sebenarnya',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Konten Artikel - Paragraf 3
                  const Text(
                    'Hingga saat ini, belum ada konfirmasi resmi dari aparat penegak hukum mengenai kasus ini. Nama politisi yang disebutkan juga tidak ada, dan tidak ada dokumen hukum yang mendung klaim tersebut rupiah.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // Icon lightbulb dengan Tips Cek Berita
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 18, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tips Cek Berita Hoax:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text('• Periksa sumber berita', style: TextStyle(fontSize: 12)),
                            Text('• Cek tanggal publikasi', style: TextStyle(fontSize: 12)),
                            Text('• Waspadai judul sensasional', style: TextStyle(fontSize: 12)),
                            Text('• Cari konfirmasi dari sumber kredibel', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol Kembali ke Dashboard
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6572),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.home, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Kembali ke Dashboard',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 14,
              color: icon == '✓' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}