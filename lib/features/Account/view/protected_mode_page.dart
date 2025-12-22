// import 'package:flutter/material.dart';
// import 'package:projek_mobile/features/dashboard/view/dashboard_protected_view.dart'; // <-- ganti importnya
//
// enum ProtectionLevel { standard, maximum }
//
// class ProtectedModePage extends StatefulWidget {
//   const ProtectedModePage({super.key});
//
//   @override
//   State<ProtectedModePage> createState() => _ProtectedModePageState();
// }
//
// class _ProtectedModePageState extends State<ProtectedModePage> {
//   ProtectionLevel _selectedLevel = ProtectionLevel.standard;
//
//   @override
//   Widget build(BuildContext context) {
//     const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
//     const Color cardColor = Color(0xFFE8EEF2);   // abu-abu card terang
//     const Color buttonGreen = Color(0xFF7BA87B); // hijau tombol
//
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF7A5A2F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Protected Mode'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'PROTECTED MODE',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // Card deskripsi utama
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: cardColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 'Lindungi diri kamu dari\n'
//                     '• Komentar negatif\n'
//                     '• Toxic Content\n'
//                     '• Harassment\n'
//                     '• Hate Speech',
//               ),
//             ),
//
//             const SizedBox(height: 16),
//             const Divider(thickness: 1),
//             const SizedBox(height: 8),
//
//             const Text(
//               'PILIH LEVEL PROTEKSI',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // LEVEL STANDARD
//             ProtectionLevelCard(
//               title: 'STANDAR',
//               isSelected: _selectedLevel == ProtectionLevel.standard,
//               onSelect: () {
//                 setState(() => _selectedLevel = ProtectionLevel.standard);
//               },
//               features: const [
//                 'Filter kata kasar otomatis',
//                 'Hide toxic comments',
//                 'Report button enhanced',
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // LEVEL MAXIMUM
//             ProtectionLevelCard(
//               title: 'MAXIMUM',
//               isSelected: _selectedLevel == ProtectionLevel.maximum,
//               onSelect: () {
//                 setState(() => _selectedLevel = ProtectionLevel.maximum);
//               },
//               features: const [
//                 'Semua fitur Standard',
//                 'Verified accounts only bisa comment',
//                 'AI pre-screening aktif',
//                 'Transparent moderation log',
//               ],
//               note: 'Best protection untuk public figures & creators',
//             ),
//
//             const SizedBox(height: 24),
//             const Center(
//               child: Text('Kamu bisa ubah level kapan saja'),
//             ),
//             const SizedBox(height: 12),
//
//             SizedBox(
//               width: double.infinity,
//               height: 44,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: buttonGreen,
//                   elevation: 2,
//                 ),
//                 onPressed: () {
//                   final levelText = _selectedLevel == ProtectionLevel.standard
//                       ? 'Standard'
//                       : 'Max';
//
//                   // (optional) snack bar info
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Protected Mode ($levelText) diaktifkan',
//                       ),
//                     ),
//                   );
//
//                   // 👉 Arahkan ke DashboardView (layout yang kamu kirim)
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const DashboardViewProtected(),
//                     ),
//                         (route) => false, // buang stack lama
//                   );
//                 },
//                 child: const Text('Aktifkan Sekarang'),
//               ),
//             ),
//
//             const SizedBox(height: 8),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   // TODO: buka halaman detail / FAQ
//                 },
//                 child: const Text('Pelajari Lebih lanjut'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProtectionLevelCard extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onSelect;
//   final List<String> features;
//   final String? note;
//
//   const ProtectionLevelCard({
//     super.key,
//     required this.title,
//     required this.isSelected,
//     required this.onSelect,
//     required this.features,
//     this.note,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     const Color cardColor = Color(0xFFD9D9D9);
//     const Color buttonGreen = Color(0xFF6E9B4B);
//
//     return InkWell(
//       onTap: onSelect,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: cardColor,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: isSelected ? buttonGreen : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Radio + title
//             Row(
//               children: [
//                 Radio<bool>(
//                   value: true,
//                   groupValue: isSelected,
//                   onChanged: (_) => onSelect(),
//                   activeColor: buttonGreen,
//                 ),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(thickness: 1),
//
//             const SizedBox(height: 6),
//             // fitur
//             ...features.map(
//                   (f) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 2),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(
//                       Icons.check_box,
//                       size: 18,
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(f),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (note != null) ...[
//               const SizedBox(height: 6),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.lightbulb_outline,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       note!,
//                       style: const TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//             const SizedBox(height: 10),
//             SizedBox(
//               width: 100,
//               height: 36,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: buttonGreen,
//                   elevation: 2,
//                 ),
//                 onPressed: onSelect,
//                 child: const Text('Select'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }