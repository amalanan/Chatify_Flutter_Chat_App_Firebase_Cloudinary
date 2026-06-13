// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
//
// class ChatPage extends StatefulWidget {
//   final String chatId;
//   final String receiverId;
//   final String receiverName;
//   final String receiverImage;
//
//   const ChatPage({
//     super.key,
//     required this.chatId,
//     required this.receiverId,
//     required this.receiverName,
//     required this.receiverImage,
//   });
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final String _currentUid = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//
//     final chatRef = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId);
//
//     final messageRef = chatRef.collection('messages').doc();
//
//     await messageRef.set({
//       'sender_id': _currentUid,
//       'text': text,
//       'imageUrl': null,
//       'sent_time': FieldValue.serverTimestamp(),
//     });
//
//     await chatRef.set({
//       'members': [_currentUid, widget.receiverId],
//       'is_active': true,
//       'is_group': false,
//       'lastMessage': text,
//     }, SetOptions(merge: true));
//
//     _messageController.clear();
//
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: AppColors.grey.withOpacity(0.3),
//               backgroundImage:
//                   widget.receiverImage.isNotEmpty
//                       ? NetworkImage(widget.receiverImage)
//                       : null,
//               child:
//                   widget.receiverImage.isEmpty
//                       ? Icon(Icons.person, color: AppColors.grey, size: 20)
//                       : null,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               widget.receiverName,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: context.isDarkMode ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance
//                       .collection('chats')
//                       .doc(widget.chatId)
//                       .collection('messages')
//                       .orderBy('sent_time', descending: true)
//                       .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(color: AppColors.primary),
//                   );
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'Say hi 👋',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   );
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   controller: _scrollController,
//                   reverse: true,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data() as Map<String, dynamic>;
//                     final isMe = data['sender_id'] == _currentUid;
//                     final text = data['text'] ?? '';
//
//                     return _messageBubble(
//                       context: context,
//                       text: text,
//                       isMe: isMe,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _messageInputField(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _messageBubble({
//     required BuildContext context,
//     required String text,
//     required bool isMe,
//   }) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.7,
//         ),
//         decoration: BoxDecoration(
//           color:
//               isMe
//                   ? AppColors.primary
//                   : context.isDarkMode
//                   ? Colors.white.withOpacity(0.08)
//                   : AppColors.grey,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: Radius.circular(isMe ? 16 : 4),
//             bottomRight: Radius.circular(isMe ? 4 : 16),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color:
//                 isMe
//                     ? Colors.white
//                     : context.isDarkMode
//                     ? Colors.white
//                     : Colors.black,
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _messageInputField(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message',
//               ).applyDefaults(Theme.of(context).inputDecorationTheme),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: _sendMessage,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.send_rounded,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String get _currentUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatRef =
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    final messageRef = chatRef.collection('messages').doc();

    await messageRef.set({
      'sender_id': _currentUid,
      'text': text,
      'imageUrl': null,
      'sent_time': FieldValue.serverTimestamp(),
    });

    await chatRef.set({
      'members': [_currentUid, widget.receiverId],
      'is_active': true,
      'is_group': false,
      'lastMessage': text,
    }, SetOptions(merge: true));

    _messageController.clear();

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.grey.withOpacity(0.3),
              backgroundImage: widget.receiverImage.isNotEmpty
                  ? NetworkImage(widget.receiverImage)
                  : null,
              child: widget.receiverImage.isEmpty
                  ? Icon(Icons.person, color: AppColors.grey, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.receiverName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('sent_time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                    CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hi 👋',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data =
                    messages[index].data() as Map<String, dynamic>;
                    final isMe = data['sender_id'] == _currentUid;
                    final text = data['text'] ?? '';

                    return _messageBubble(
                      context: context,
                      text: text,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          _messageInputField(context),
        ],
      ),
    );
  }

  Widget _messageBubble({
    required BuildContext context,
    required String text,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : context.isDarkMode
              ? Colors.white.withOpacity(0.08)
              : AppColors.grey,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe
                ? Colors.white
                : context.isDarkMode
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _messageInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
