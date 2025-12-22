// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:projek_mobile/core/controllers/comment_controller.dart';
//
// class PoliticsCommentView extends StatefulWidget {
//   final String articleId;
//
//   const PoliticsCommentView({super.key, required this.articleId});
//
//   @override
//   State<PoliticsCommentView> createState() => _PoliticsCommentViewState();
// }
//
// class _PoliticsCommentViewState extends State<PoliticsCommentView> {
//   final TextEditingController _commentController = TextEditingController();
//   late CommentController _controller = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.put(CommentController());
//     _controller.loadComments(widget.articleId);
//   }
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     Get.delete<CommentController>();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF6B95A8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6B95A8),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Komentar',
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               color: const Color(0xFFB8C5CC),
//               child: Obx(() {
//                 if (_controller.isLoading.value) {
//                   return Center(
//                     child: CircularProgressIndicator(color: Color(0xFF6B95A8)),
//                   );
//                 }
//
//                 if (_controller.comments.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'Belum ada komentar',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   itemCount: _controller.comments.length,
//                   itemBuilder: (context, index) {
//                     final comment = _controller.comments[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 18,
//                             backgroundImage: NetworkImage(comment.avatarUrl),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       comment.username,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                     if (comment.timeAgo.isNotEmpty) ...[
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         comment.timeAgo,
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   comment.comment,
//                                   style: const TextStyle(fontSize: 13, height: 1.3),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () => _controller.likeComment(comment.id),
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.favorite, size: 14, color: Colors.red),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             '${comment.likes}',
//                                             style: const TextStyle(fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     const Text(
//                                       'Balas',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.image_outlined, color: Colors.black54),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: const InputDecoration(
//                       hintText: 'Tambahkan komentar...',
//                       hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     ),
//                   ),
//                 ),
//                 Obx(() => IconButton(
//                   icon: _controller.isSending.value
//                       ? SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                       : const Icon(Icons.send, color: Color(0xFF6B95A8)),
//                   onPressed: _controller.isSending.value
//                       ? null
//                       : () {
//                     if (_commentController.text.isNotEmpty) {
//                       _controller.addComment(
//                         widget.articleId,
//                         _commentController.text,
//                       );
//                       _commentController.clear();
//                     }
//                   },
//                 )),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildSuggestionButton('Suggest'),
//                 _buildSuggestionButton('Suggest'),
//                 _buildSuggestionButton('Suggest'),
//               ],
//             ),
//           ),
//           Container(
//             color: const Color(0xFFD1D5DB),
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildKeyButton('Q'),
//                     _buildKeyButton('W'),
//                     _buildKeyButton('E'),
//                     _buildKeyButton('R'),
//                     _buildKeyButton('T'),
//                     _buildKeyButton('Y'),
//                     _buildKeyButton('U'),
//                     _buildKeyButton('I'),
//                     _buildKeyButton('O'),
//                     _buildKeyButton('P'),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     const SizedBox(width: 15),
//                     _buildKeyButton('A'),
//                     _buildKeyButton('S'),
//                     _buildKeyButton('D'),
//                     _buildKeyButton('F'),
//                     _buildKeyButton('G'),
//                     _buildKeyButton('H'),
//                     _buildKeyButton('J'),
//                     _buildKeyButton('K'),
//                     _buildKeyButton('L'),
//                     const SizedBox(width: 15),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildKeyButton('⬆', isWide: true),
//                     _buildKeyButton('Z'),
//                     _buildKeyButton('X'),
//                     _buildKeyButton('C'),
//                     _buildKeyButton('V'),
//                     _buildKeyButton('B'),
//                     _buildKeyButton('N'),
//                     _buildKeyButton('M'),
//                     _buildKeyButton('⌫', isWide: true),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildKeyButton('123', isWide: true),
//                     _buildKeyButton('space', isExtraWide: true),
//                     _buildKeyButton('Go', isWide: true),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSuggestionButton(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE5E7EB),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 12, color: Colors.black87),
//       ),
//     );
//   }
//
//   Widget _buildKeyButton(String text, {bool isWide = false, bool isExtraWide = false}) {
//     double width = 28;
//     if (isWide) width = 45;
//     if (isExtraWide) width = 140;
//
//     return Container(
//       width: width,
//       height: 35,
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(4),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 1,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }