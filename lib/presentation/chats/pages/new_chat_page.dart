import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widgets/new_chat_page/user_list_item.dart';
import 'chat_page.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

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
            color: context.isDarkMode ? AppColors.secondary : AppColors.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('chat_users').snapshots(),
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

            final users =
                snapshot.data!.docs
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

                return UserListItem(
                  receiverId: userDoc.id,
                  name: name,
                  image: image,
                  onTap:
                      () => _openOrCreateChat(context, userDoc.id, name, image),
                );
              },
            );
          },
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

    final existing =
        await chatsRef
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
        builder:
            (context) => ChatPage(
              chatId: chatId!,
              receiverId: receiverId,
              receiverName: receiverName,
              receiverImage: receiverImage,
            ),
      ),
    );
  }
}
