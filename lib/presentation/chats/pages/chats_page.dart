import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../data/models/chats/chats.dart';
import '../../auth/pages/signup_or_signin.dart';
import '../widgets/chats_page/chat_list_item.dart';
import '../widgets/chats_page/empty_state.dart';
import 'chat_page.dart';
import 'new_chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: context.isDarkMode ? AppColors.secondary : AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color:
                  context.isDarkMode
                      ? AppColors.secondary
                      : Colors.purple.shade900,
            ),
            onPressed: () async {
              final confirm =
                  await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Sign Out',
                            style: TextStyle(
                              color:
                                  context.isDarkMode
                                      ? AppColors.secondary
                                      : AppColors.primary,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to sign out?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  color:
                                      context.isDarkMode
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ) ??
                  false;

              if (!confirm) return;
              if (!context.mounted) return;
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('chats')
                  .where('members', arrayContains: currentUid)
                  .orderBy('lastMessageTime', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return EmptyState(context: context);
            }
            final chats =
                snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final unread =
                      data['unreadCount'] is Map
                          ? (data['unreadCount'][currentUid] ?? 0) as int
                          : 0;
                  return (
                    model: ChatsModel.fromJson(doc.id, data),
                    unread: unread,
                  );
                }).toList();

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final chat = chats[index].model;
                final unreadCount = chats[index].unread;

                final receiverId = chat.members.firstWhere(
                  (uid) => uid != currentUid,
                  orElse: () => '',
                );

                return Dismissible(
                  key: Key(chat.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          context.isDarkMode
                              ? AppColors.secondary
                              : AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  'Delete Chat',
                                  style: TextStyle(
                                    color:
                                        context.isDarkMode
                                            ? AppColors.secondary
                                            : AppColors.primary,
                                  ),
                                ),
                                content: const Text(
                                  'Are you sure you want to delete this conversation? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color:
                                            context.isDarkMode
                                                ? AppColors.secondary
                                                : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ) ??
                        false;
                  },
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chat.id)
                        .delete();
                  },
                  child: FutureBuilder<DocumentSnapshot>(
                    future:
                        receiverId.isNotEmpty
                            ? FirebaseFirestore.instance
                                .collection('chat_users')
                                .doc(receiverId)
                                .get()
                            : null,
                    builder: (context, userSnapshot) {
                      String receiverName = 'Unknown';
                      String receiverImage = '';

                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>?;
                        receiverName = userData?['name'] ?? 'Unknown';
                        receiverImage = userData?['image'] ?? '';
                      }

                      return ChatListItem(
                        name: chat.isGroup ? 'Group Chat' : receiverName,
                        image: receiverImage,
                        unreadCount: unreadCount,
                        subtitle:
                            chat.lastMessage.isNotEmpty
                                ? chat.lastMessage
                                : (chat.isGroup
                                    ? 'Group Chat'
                                    : 'Private Chat'),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chat.id)
                              .update({'unreadCount.$currentUid': 0});

                          if (!context.mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatPage(
                                    chatId: chat.id,
                                    receiverId: receiverId,
                                    receiverName: receiverName,
                                    receiverImage: receiverImage,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: FloatingActionButton(
          backgroundColor:
              context.isDarkMode ? AppColors.secondary : AppColors.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewChatPage()),
            );
          },
          child: const Icon(Icons.edit_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
