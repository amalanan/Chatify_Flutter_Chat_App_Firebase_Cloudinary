// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
// import 'chat_page.dart';
//
// class NewChatPage extends StatelessWidget {
//   NewChatPage({super.key});
//
//   final String _currentUid = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'New Chat',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: context.isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('chat_users').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(color: AppColors.primary),
//               );
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No users found',
//                   style: TextStyle(
//                     color: context.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//               );
//             }
//
//             final users = snapshot.data!.docs
//                 .where((doc) => doc.id != _currentUid)
//                 .toList();
//
//             return ListView.separated(
//               itemCount: users.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final userDoc = users[index];
//                 final userData = userDoc.data() as Map<String, dynamic>;
//                 final name = userData['name'] ?? 'Unknown';
//                 final image = userData['image'] ?? '';
//
//                 return _userItem(
//                   context: context,
//                   receiverId: userDoc.id,
//                   name: name,
//                   image: image,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _userItem({
//     required BuildContext context,
//     required String receiverId,
//     required String name,
//     required String image,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(15),
//       onTap: () => _openOrCreateChat(context, receiverId, name, image),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: context.isDarkMode
//               ? Colors.white.withOpacity(0.05)
//               : AppColors.grey,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 26,
//               backgroundColor: AppColors.grey.withOpacity(0.3),
//               backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
//               child: image.isEmpty
//                   ? Icon(Icons.person, color: AppColors.grey)
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                   color: context.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _openOrCreateChat(
//       BuildContext context,
//       String receiverId,
//       String receiverName,
//       String receiverImage,
//       ) async {
//     final chatsRef = FirebaseFirestore.instance.collection('chats');
//
//     // Look for an existing 1:1 chat between the two users.
//     final existing = await chatsRef
//         .where('members', arrayContains: _currentUid)
//         .where('is_group', isEqualTo: false)
//         .get();
//
//     String? chatId;
//
//     for (final doc in existing.docs) {
//       final members = List<String>.from(doc['members'] ?? []);
//       if (members.contains(receiverId) && members.length == 2) {
//         chatId = doc.id;
//         break;
//       }
//     }
//
//     // If none exists, create a new chat document.
//     if (chatId == null) {
//       final newChatRef = chatsRef.doc();
//       await newChatRef.set({
//         'members': [_currentUid, receiverId],
//         'is_group': false,
//         'is_active': true,
//         'lastMessage': '',
//       });
//       chatId = newChatRef.id;
//     }
//
//     if (!context.mounted) return;
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatPage(
//           chatId: chatId!,
//           receiverId: receiverId,
//           receiverName: receiverName,
//           receiverImage: receiverImage,
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import 'chat_page.dart';

class NewChatPage extends StatelessWidget {
  NewChatPage({super.key});

  String get _currentUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'New Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('chat_users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No users found',
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              );
            }

            final users = snapshot.data!.docs
                .where((doc) => doc.id != _currentUid)
                .toList();

            return ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final userDoc = users[index];
                final userData = userDoc.data() as Map<String, dynamic>;
                final name = userData['name'] ?? 'Unknown';
                final image = userData['image'] ?? '';

                return _userItem(
                  context: context,
                  receiverId: userDoc.id,
                  name: name,
                  image: image,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _userItem({
    required BuildContext context,
    required String receiverId,
    required String name,
    required String image,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => _openOrCreateChat(context, receiverId, name, image),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : AppColors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.grey.withOpacity(0.3),
              backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
              child: image.isEmpty
                  ? Icon(Icons.person, color: AppColors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _openOrCreateChat(
      BuildContext context,
      String receiverId,
      String receiverName,
      String receiverImage,
      ) async {
    final chatsRef = FirebaseFirestore.instance.collection('chats');

    // Look for an existing 1:1 chat between the two users.
    final existing = await chatsRef
        .where('members', arrayContains: _currentUid)
        .where('is_group', isEqualTo: false)
        .get();

    String? chatId;

    for (final doc in existing.docs) {
      final members = List<String>.from(doc['members'] ?? []);
      if (members.contains(receiverId) && members.length == 2) {
        chatId = doc.id;
        break;
      }
    }

    // If none exists, create a new chat document.
    if (chatId == null) {
      final newChatRef = chatsRef.doc();
      await newChatRef.set({
        'members': [_currentUid, receiverId],
        'is_group': false,
        'is_active': true,
        'lastMessage': '',
      });
      chatId = newChatRef.id;
    }

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          chatId: chatId!,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverImage: receiverImage,
        ),
      ),
    );
  }
}